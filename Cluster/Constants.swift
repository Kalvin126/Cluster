//
//  Constants.swift
//  Cluster
//
//  Created by Kalvin Loc on 5/7/16.
//  Copyright © 2016 Red Panda. All rights reserved.
//

import Foundation

struct Konstants {
    
    // MARK: Engine Coolant
    struct EngineCoolant {
        static let warmTemp   = 140.0
        static let hotTemp    = 200.0
    }
    
    // MARK: Fuel
    struct Fuel {
        static let surveyCount = 100
        static let low         = 20.0
    }
    
    // MARK: Gear
    
    struct Gear {
        static let final    = 4.44
        
        static let allRatios = [1 : 2.666, 2 : 1.534, 3 : 1.022, 4 : 0.721, 5 : 0.525]
    }
    
    // MARK: RPM
    
    struct RPM {
        static let max      = 8000
        static let redline  = 7000
        static let warning  = 2500
    }
    
    // MATK: Tank
    static let tankSize   = 13.2
    
    // MARK: TPS
    static let tpsWarn    = 25.0
    
    // MARK: Tires
    
    struct Tires {
        static let width = 205.0
        static let ratio = 55.0
        static let rimDiameter = 16.0
        static let circumference = M_PI * ((width*ratio/2540*2) + rimDiameter) / 12.0
    }
}