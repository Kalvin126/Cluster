//
//  TripComputer.swift
//  Cluster
//
//  Created by Kalvin Loc on 5/21/16.
//  Copyright © 2016 Red Panda. All rights reserved.
//

import Foundation
import RealmSwift
import UIKit        // For UIDevice

class TripComputer {
    
    static let sharedComputer = TripComputer()
    
    fileprivate(set) var currentTank: Tank?
    fileprivate(set) var currentTrip: Trip?
    
    init() {
        DiagData.sharedData.addObserver(self)
        
        NotificationCenter.default.addObserver(self, selector: #selector(batteryDeviceStateDidChange(_:)), name: NSNotification.Name.UIDeviceBatteryStateDidChange, object: nil)
        
        
        resetTrip()
    }
    
    // MARK: Tank
    
    func loadCurrentTankFromMemory() {
        let userDef = UserDefaults.standard
        
        if userDef.dictionaryRepresentation().keys.contains("currentTankID") {
            let currentTankID = userDef.integer(forKey: "currentTankID")
            
            let realm = try! Realm()
            currentTank = realm.objects(Tank.self).filter("id = \(currentTankID)").first!
        }
        else {
            resetTank()
        }
    }
    
    func resetTank() {
        if let cTank = currentTank {
            let realm = try! Realm()
            
            try! realm.write {
                cTank.endDate = Date()
            }
        }
        
        beginNewTank()
    }
    
    fileprivate func beginNewTank() {
        let userDef = UserDefaults.standard

        let newTank = Tank(value: ["id": userDef.integer(forKey: "currentTankID") + 1])
        currentTank = newTank
        
        let realm = try! Realm()
        try! realm.write {
            realm.add(newTank, update: true)
        }
        
        userDef.set(newTank.id, forKey: "currentTankID")
        userDef.synchronize()
    }
    
    // MARK: Trip
    
    func resetTrip() {
        if let cTrip = currentTrip {
            let realm = try! Realm()
            
            try! realm.write {
                cTrip.endDate = Date()
            }
        }
        
        beginNewTrip()
    }
    
    fileprivate func beginNewTrip() { 
        let userDef = UserDefaults.standard
        let realm = try! Realm()
        
        var nextID = userDef.integer(forKey: "currentTripID")
        
        if let cTrip = realm.objects(Trip.self).filter("id = \(nextID)").first , cTrip.fuelUsed > 0.0 {
            nextID += 1
        }
        
        let newTrip = Trip(value: ["id": nextID])
        currentTrip = newTrip
        
        try! realm.write {
            realm.add(newTrip, update: true)
        }
        
        userDef.set(newTrip.id, forKey: "currentTripID")
        userDef.synchronize()
    }
    
    // MARK: UIDevice Stuff
    
    @objc func batteryDeviceStateDidChange(_ notif: Foundation.Notification) {
        if UIDevice.current.batteryState == .unplugged {
            resetTrip()
        }
    }
    
    // MARK: Trip Filters 
    
//    func trips(forWeek week: Int) -> TripWeek {
//        let negWeek = -week
//        
//        let cal = Calendar.current
//        let now = cal.date(byAdding: .weekOfYear, value: negWeek, to: Date())
//        var startOfWeek = Date()
//        var endOfWeek: Date
//        var interval: TimeInterval = 0
//        
//        
//        let weekRange = cal.range(of: .weekOfYear, in: .day, for: now!)
//        
//        weekra
//        
//        endOfWeek = startOfWeek.addingTimeInterval(interval - 1)
//        
//        let realm = try! Realm()
//        let trips = [Trip](realm.objects(Trip.self).filter("startDate >= %@ AND endDate <= %@", startOfWeek, endOfWeek))
//        
//        var tripDays = [TripDay]()
//        
//        for i in (0..<7).reversed() {
//            let day = (cal as NSCalendar).date(byAdding: .day, value: i, to: startOfWeek, options: .matchStrictly)!
//            
//            let tripsForDay = trips.filter() { cal.isDate($0.startDate, inSameDayAs: day) }
//            
//            if tripsForDay.count != 0 {
//                let tripDay = TripDay(trips: tripsForDay.reversed(), date: day)
//                
//                tripDays.append(tripDay)
//            }
//        }
//        
//        let tripWeek = TripWeek(tripDays: tripDays, startDate: startOfWeek, endDate: endOfWeek)
//        
//        return tripWeek
//    }
    
}

extension TripComputer: DiagDataObserver {
    
    func tripDataDidUpdate(_ dataManager: DiagData) {
        updateCurrentTrip(dataManager)
        updateCurrentTank(dataManager)
    }
    
    fileprivate func updateCurrentTrip(_ dataManager: DiagData) {
        if let cTrip = currentTrip {
            let realm = try! Realm()
            try! realm.write {
                if dataManager.engineCoolantTemp > cTrip.highestCoolantTemp {
                    cTrip.highestCoolantTemp = dataManager.engineCoolantTemp
                }
                
                if dataManager.speed > cTrip.highestSpeed {
                    cTrip.highestSpeed = dataManager.speed
                }
                
                if dataManager.rpm > cTrip.highestRPM {
                    cTrip.highestRPM = dataManager.rpm
                }
                
                cTrip.distanceTraveled += dataManager.deltaDistance
                cTrip.fuelUsed += dataManager.deltaFuel
            }
        }
    }
    
    fileprivate func updateCurrentTank(_ dataManager: DiagData) {
        if let cTank = currentTank {
            let realm = try! Realm()
            
            try! realm.write {
                if dataManager.engineCoolantTemp > cTank.highestCoolantTemp {
                    cTank.highestCoolantTemp = dataManager.engineCoolantTemp
                }
                
                if dataManager.speed > cTank.highestSpeed {
                    cTank.highestSpeed = dataManager.speed
                }
                
                if dataManager.rpm > cTank.highestRPM {
                    cTank.highestRPM = dataManager.rpm
                }
                
                cTank.distanceTraveled += dataManager.deltaDistance
                cTank.fuelUsed += dataManager.deltaFuel
            }
        }
    }
    
}
