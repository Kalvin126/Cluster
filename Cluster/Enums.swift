//
//  Enums.swift
//  Cluster
//
//  Created by Kalvin Loc on 4/29/16.
//  Copyright © 2016 Red Panda. All rights reserved.
//

import Foundation

// MARK: PIDs

enum PID: UInt {
    case fuelSystemStatus   = 0x03
    case engineCoolantTemp  = 0x05
    case engineRPM          = 0x0C
    case vehicleSpeed       = 0x0D  // Max 255 km/h
    case maf                = 0x10  // Max 655.35 grams/sec
    case throttlePos        = 0x11  // Max 100 percent
    case fuelTankInputLevel = 0x2f  // Max 100 percent
    case airFuelRatio       = 0x44  // actual A/F / expected A/F (14.7
}

func ==(left: UInt, right: PID) -> Bool {
    return left == right.rawValue
}

// MARK: Fuel System Status

enum FuelSystemStatus: String { // TODO: get raw values
    case OpenLoopDrive              = "OL-Drive"
    case ClosedLoop                 = "Closed Loop"
    case OpenLoopLoadDecel          = "Open Loop"
    case OpenLoopFailure            = "OL-Fault"
    case ClosedLoopFaultFeedBack    = "CL-Fault"
}

func ==(left: String, right: FuelSystemStatus) -> Bool {
    return left == right.rawValue
}

// MARK: Gearing 

