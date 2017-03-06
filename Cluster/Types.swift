//
//  Types.swift
//  Cluster
//
//  Created by Kalvin Loc on 5/5/16.
//  Copyright © 2016 Red Panda. All rights reserved.
//

import Foundation
import RealmSwift

enum Gear: Int {
    case neutral
    case first, second, third, fourth, fifth
}

// MARK: Speed alias
// initialized as km/hr

typealias Speed = Double

extension Speed {
    
    func toMilesPerHour() -> Speed {
        return 0.621371*self
    }
    
}

// MARK: Trip

class Trip: Object {
    dynamic var id = 0
    
    dynamic var startDate = Date()
    dynamic var endDate: Date? = nil
    
    dynamic var highestCoolantTemp = 0.0
    dynamic var highestSpeed = 0.0
    dynamic var highestRPM = 0
    
    dynamic var distanceTraveled = 0.0
    dynamic var fuelUsed = 0.0
    
    var avgMPG: Double {
        get {
            guard distanceTraveled != 0.0 || fuelUsed != 0.0 else {
                return 0.0
            }
            
            return distanceTraveled / fuelUsed
        }
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
}

struct TripWeek {
    let tripDays: [TripDay]
    
    let startDate: Date
    let endDate: Date
    
    var avgMPG: Double {
        get {
            let totalDist = tripDays.reduce(0.0) { $0 + $1.totalDist }
            let totalFuel = tripDays.reduce(0.0) { $0 + $1.totalFuel }
            
            guard totalFuel != 0.0 else { return 0.0 }
            
            return totalDist/totalFuel
        }
    }
    
}

struct TripDay {
    let trips: [Trip]
    
    let date: Date
    
    var totalDist: Double {
        get {
            return trips.reduce(0.0) { $0 + $1.distanceTraveled }
        }
    }
    
    var totalFuel: Double {
        get {
            return trips.reduce(0.0) { $0 + $1.fuelUsed         }
        }
    }
    
    var avgMPG: Double {
        get {
            let totFuel = totalFuel
            
            guard totFuel != 0.0 else { return 0.0 }
            
            return totalDist/totFuel
        }
    }
    
}


// MARK: Tank

class Tank: Object {
    dynamic var id = 0
    
    dynamic var startDate = Date()
    dynamic var endDate: Date? = nil
    
    dynamic var highestCoolantTemp = 0.0
    dynamic var highestSpeed = 0.0
    dynamic var highestRPM = 0
    
    dynamic var distanceTraveled = 0.0
    dynamic var fuelUsed = 0.0
    
    var avgMPG: Double {
        get {
            guard distanceTraveled != 0.0 || fuelUsed != 0.0 else {
                return 0.0
            }
            
            return distanceTraveled / fuelUsed
        }
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
