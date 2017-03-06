//
//  Utilities.swift
//  Cluster
//
//  Created by Kalvin Loc on 5/14/16.
//  Copyright © 2016 Red Panda. All rights reserved.
//

import UIKit

func delay(_ delay:Double, closure:@escaping () -> ()) {
    DispatchQueue.main.asyncAfter(
        deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
}

func createTimemapForSeconds(_ sec: Double) -> [String : Int] {
    let hours = floor(sec / (60.0 * 60.0))
    let minute_divisor = sec.truncatingRemainder(dividingBy: (60.0 * 60.0))
    let minutes = floor(minute_divisor / 60.0)
    let seconds_divisor = sec.truncatingRemainder(dividingBy: 60.0)
    let seconds = ceil(seconds_divisor)
    let timeMap = ["h": Int(hours), "m": Int(minutes), "s": Int(seconds)]
    
    return timeMap
}

func timeBetweenStringForDate(_ date: Date, date1: Date) -> String {
    var timemap = createTimemapForSeconds(date1.timeIntervalSince(date))
    let hoursLeft = timemap["h"]!
    let minLeft = timemap["m"]!
    
    if hoursLeft >= 1 {
        return "\(hoursLeft) hr\(hoursLeft > 1 ? "s" : "")"
    }
    else if minLeft >= 1 {
        return "\(minLeft) min"
    }
    
    return "\(timemap["s"]!) seconds"
}

extension Date {
    func isBetweenDates(_ beginDate: Date, endDate: Date) -> Bool {
        //(([date compare:beginDate] != NSOrderedAscending) && ([date compare:endDate] != NSOrderedDescending));
        return (compare(beginDate) != .orderedAscending) && (compare(endDate) != .orderedDescending)
    }
}

extension UIColor {
    static func tealColor() -> UIColor {
        return UIColor(red: 0.0, green: 128.0/255.0, blue: 128.0/255.0, alpha: 1.0)
    }
}
