//
//  TripHeaderTableViewCell.swift
//  Cluster
//
//  Created by Kalvin Loc on 6/1/16.
//  Copyright © 2016 Red Panda. All rights reserved.
//

import UIKit

class TripsHeaderTableViewCell: UITableViewCell {

    var tripWeek: TripWeek? {
        didSet {
            loadTripWeek()
        }
    }
    
    var isCurrentWeek = false {
        didSet {
            loadTripWeek()
        }
    }
    
    @IBOutlet weak var rangeLabel: UILabel!
    @IBOutlet weak var weekAVGLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    fileprivate func loadTripWeek() {
        if let tWeek = tripWeek {
            if !isCurrentWeek {
                let formatter = DateFormatter()
                formatter.dateFormat = "MMM d"
                
                rangeLabel.text = "\(formatter.string(from: tWeek.startDate as Date)) - \(formatter.string(from: tWeek.endDate as Date))"
            } else {
                rangeLabel.text = "This Week"
            }
            
            weekAVGLabel.text = String(format: "%0.1f mpg", tWeek.avgMPG)
        }
    }

}
