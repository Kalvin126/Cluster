//
//  TripTableViewCell.swift
//  Cluster
//
//  Created by Kalvin Loc on 6/1/16.
//  Copyright © 2016 Red Panda. All rights reserved.
//

import UIKit

class TripsTableViewCell: UITableViewCell {

    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var avgMPGLabel: UILabel!
    
    @IBOutlet weak var detailLabel: UILabel!
    
    var tripDay: TripDay? {
        didSet {
            loadData()
        }
    }
    
    fileprivate func loadData() {
        if let tr = tripDay {
            // day
            
            let formatter = DateFormatter()
            formatter.dateFormat = "EEE"

            dayLabel.text = formatter.string(from: tr.date as Date)
            
            // avgMPG
            avgMPGLabel.text = String(format: "%.1f", tr.avgMPG)
            
            detailLabel.text = "\(tr.trips.count) drive\(tr.trips.count == 1 ? "": "s") - \(String(format: "%.1f", tr.totalDist)) mi"
        }
    }

}
