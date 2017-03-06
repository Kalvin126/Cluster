//
//  TripDayTableViewCell.swift
//  Cluster
//
//  Created by Kalvin Loc on 6/10/16.
//  Copyright © 2016 Red Panda. All rights reserved.
//

import UIKit

class TripDayTableViewCell: UITableViewCell {

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var avgMPGLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    
    var trip: Trip? {
        didSet {
            loadTrip()
        }
    }
    
    fileprivate func loadTrip() {
        if let t = trip {
            let formatter = DateFormatter()
            formatter.dateFormat = "h:mma"
            
            timeLabel.text = formatter.string(from: t.startDate as Date)
            avgMPGLabel.text = String(format: "%0.1f", t.avgMPG)
            
            let timeStr = timeBetweenStringForDate(t.startDate, date1: t.endDate!)
            detailLabel.text = timeStr + " - \(String(format: "%.1f", t.distanceTraveled)) mi"
        }
    }
    
}
