//
//  DiagData.swift
//  Cluster
//
//  Created by Kalvin Loc on 5/22/16.
//  Copyright © 2016 Red Panda. All rights reserved.
//

import Foundation

protocol DiagDataObserver: class {

    func tripDataDidUpdate(_ dataManager: DiagData)

}

class DiagData {
    static let sharedData = DiagData()
    
    fileprivate var observers = [DiagDataObserver]()
    
    fileprivate(set) var supportedPIDs = [UInt]()
    
    fileprivate(set) var prevTime = Date()
    fileprivate(set) var deltTime = 1.0
    
    fileprivate(set) var actualAF = 14.7
    fileprivate(set) var maf = 0.0
    
    fileprivate(set) var engineCoolantTemp = 0.0
    
    fileprivate(set) var rpm = 0
    fileprivate(set) var speed: Speed = 0.0
    
    fileprivate(set) var throttlePos = 0.0
    
    // MARK: Fuel
    
    fileprivate var gasHead: LinkedNode<Double>?
    fileprivate var gasTail: LinkedNode<Double>?
    fileprivate var gasTotal = 0.0
    fileprivate var gasCount = 0
    
    var gasLevel: Double {
        get {
            guard gasCount != 0 else { return 0.0 }
            
            // Return average
            return gasTotal/Double(gasCount)
        }
        
        set {
            // Remove First
            if gasCount >= Konstants.Fuel.surveyCount {
                let newHead = gasHead!.nextNode!
                
                gasTotal -= gasHead!.num
                gasCount -= 1
                
                gasHead!.nextNode = nil
                gasHead = newHead
            }
            
            // Append newValue
            let newNode = LinkedNode<Double>(num: newValue)
            
            if gasHead == nil {
                gasHead = newNode
            }
            
            if let tailNode = gasTail {
                tailNode.nextNode = newNode
                
            } else {
                gasTail = newNode
            }
            
            gasTotal += gasTail!.num
            gasCount += 1
        }
    }
    
    fileprivate(set) var fuelSystemStatus: FuelSystemStatus = .OpenLoopDrive
    
    var deltaFuel: Double { // NOT THREAD SAFE
        get {
            if fuelSystemStatus != .OpenLoopDrive {
                return ((maf * deltTime) / 454 / 6.17) / actualAF
                // (gallons of fuel) = (grams of air) / (air/fuel ratio) / 6.17 / 454
            }
            
            return 0.0
        }
    }
    
    // MARK: MPG
    
    var mpg: Double {
        get {
            guard fuelSystemStatus != .OpenLoopDrive else { // Engine Braking case
                return 9999.0
            }
            
            // MPG = (14.7 * 6.17 * 454 * VSS * 0.621371) / (3600 * MAF)
            // MPG = 7.10734 (VSS / MAF)
            // MPG = (0.483492 * AF * VSS)/ MAF
            let instantMPG = 0.483492*(actualAF * speed / maf)
            
            guard instantMPG.isFinite else {
                return 0.0
            }
            
            return instantMPG
        }
    }
    
    // MARK: Gear
    
    var gear: Gear {
        get {
            guard (speed.toMilesPerHour() >= 10.0) && (rpm > 850) else {
                return .neutral
            }
            
            let ratio = (Double(rpm) * Konstants.Tires.circumference) / (speed.toMilesPerHour() * Konstants.Gear.final * 88.0)
            
            var gear = 6
            var delta = 1.5
            
            Konstants.Gear.allRatios.forEach {
                let d = abs(ratio - $1)
                
                if d < delta {
                    delta = d
                    gear = $0
                }
            }
            
            return Gear(rawValue: gear) ?? Gear.neutral
        }
    }
    
    // MARK: Distance
    
    var deltaDistance: Double { // NOT THREAD SAFE
        get {
            return deltTime * (speed.toMilesPerHour() / 3600)
        }
    }
    
    fileprivate(set) var voltage = "not ready"
    
    func addObserver(_ observer: DiagDataObserver) {
        observers.append(observer)
    }
    
    func removeObserver(_ observer: DiagDataObserver) {
        if let observerPos = observers.index(where: { $0 === observer }) {
            observers.remove(at: observerPos)
        }
    }
    
    deinit {
        observers.removeAll()
    }
    
    // MARK: Trouble Codes
    
    func requestTroubleCode() {
        // TODO FLECUSensor - troubleCodesForResponse
    }
    
}

extension DiagData: OBDDelegate {
    
    func managerDidInititialize(_ manager: OBDManager) {
        
        supportedPIDs = manager.availiblePIDs as! [UInt]
        
    }
    
    func scanTargetsForOBD(_ manager: OBDManager) -> [UInt] {
        return [0x03, 0x0C, 0x0D, 0x11, 0x2F, 0x44]
//        return [0x03, 0x05, 0x0C, 0x0D, 0x10, 0x11, 0x2F, 0x44]
    }
    
    func OBD(_ manager: OBDManager, didRecieveResponse response: FLScanToolResponse) {
        let sensor = FLECUSensor(forPID: response.pid)
        sensor?.currentResponse = response
        
        if let pid = PID(rawValue: response.pid) {
        switch pid {
            case .fuelSystemStatus:
                guard let fuelSysStatus = sensor?.value(forMeasurement1: false) else {
                    return
                }
                
                fuelSystemStatus = FuelSystemStatus(rawValue: fuelSysStatus as! String)!
                
            case .engineCoolantTemp:
                engineCoolantTemp = sensor?.value(forMeasurement1: false) as! Double
                
            case .engineRPM:
                rpm = sensor?.value(forMeasurement1: false) as! Int
                
            case .vehicleSpeed:
                speed = sensor?.value(forMeasurement1: true) as! Double
                
            case .maf:
                maf = (sensor?.value(forMeasurement1: true) as! Double)
                
            case .throttlePos:
                throttlePos = (sensor?.value(forMeasurement1: false) as! Double)
                
            case .fuelTankInputLevel:
                gasLevel = sensor?.value(forMeasurement1: false) as! Double
                
            case .airFuelRatio:
                actualAF = 14.7*(sensor?.value(forMeasurement1: false) as! Double)
            }
        }
        else {
            NSLog("Error werid PID")
        }
    }
    
    func managerDidFinishProcessingResponseRound(_ manager: OBDManager) {
        // Update calculated values
        deltTime = abs(prevTime.timeIntervalSinceNow)
        prevTime = Date()
        
        // Done updating calculated values
        
        observers.forEach { $0.tripDataDidUpdate(self) }
    }

    func OBD(_ manager: OBDManager, didRecieveVoltage volt: String) {
        voltage = volt
    }
}
