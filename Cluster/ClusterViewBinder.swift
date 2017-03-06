//
//  ClusterViewModel.swift
//  Cluster
//
//  Created by Kalvin Loc on 4/29/16.
//  Copyright © 2016 Red Panda. All rights reserved.
//

import UIKit

import ReactiveSwift
import ReactiveCocoa

class ClusterViewModel {
    
    var engineCoolantTemp = MutableProperty(0.0)
    var rpm = MutableProperty(0)
    var speed: MutableProperty<Speed> = MutableProperty(0.0)
    var throttlePos = MutableProperty(0.0)
    
    // MARK: Fuel
    
    var gasLevel = MutableProperty(0.0)
    var fuelSystemStatus: MutableProperty<FuelSystemStatus> = MutableProperty(.OpenLoopDrive)
    
    // MARK: MPG
    
    var avgMPG = MutableProperty(0.0)
    var mpg = MutableProperty(0.0)
    
    // MARK: Gear

//    var gear = Gear.neutral {
//        didSet {
//            let currGear = gear
//            
//            view.gearLabel.text = (currGear == .neutral ? "1/N" : "\(currGear.rawValue)")
//        }
//    }
    
    // MARK: Distance

    var totalDistance = MutableProperty(0.0)
    var range = MutableProperty(0.0)
    
    init() {
        DiagData.sharedData.addObserver(self)
    }
    
}

// MARK: - Actions
extension ClusterViewModel {
    
    func resetLabels() {
        engineCoolantTemp.value = 0.0
        rpm.value = 0
        speed.value = 0.0
        throttlePos.value = 0.0
        
        gasLevel.value = 0.0
        
        avgMPG.value = 0.0
        mpg.value = 0.0
        
        totalDistance.value = 0.0
        range.value = 0.0
    }

}

// MARK: - DiagDataObserver
extension ClusterViewModel: DiagDataObserver {
    
    func tripDataDidUpdate(_ dataManager: DiagData) {
        engineCoolantTemp.value = dataManager.engineCoolantTemp
                      rpm.value = dataManager.rpm
                    speed.value = dataManager.speed
              throttlePos.value = dataManager.throttlePos
        
                 gasLevel.value = dataManager.gasLevel
         fuelSystemStatus.value = dataManager.fuelSystemStatus
        
                      mpg.value = dataManager.mpg
        
//                     gear = dataManager.gear
        
        if let cTrip = TripComputer.sharedComputer.currentTrip {
            avgMPG.value = cTrip.avgMPG
            
            totalDistance.value = cTrip.distanceTraveled
        }
        
//        if let cTank = TripComputer.sharedComputer.currentTank {
//            range = cTank.avgMPG * (Konstants.tankSize * (gasLevel/100.0))
//        }
    }
    
}
