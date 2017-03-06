//
//  SupportedPIDTVC.swift
//  Cluster
//
//  Created by Kalvin Loc on 6/12/16.
//  Copyright © 2016 Red Panda. All rights reserved.
//

import UIKit

class SupportedPIDTVC: UITableViewController {

    let supportedSensors = DiagData.sharedData.supportedPIDs
    
}


// MARK: UITableViewDataSource
extension SupportedPIDTVC {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return supportedSensors.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: "pidCell")!
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let pidForCell = supportedSensors[(indexPath as NSIndexPath).row]
        let descrip = FLECUSensor(forPID: pidForCell).descriptionStringForMeasurement1
        
        cell.textLabel?.text = String(format: "%.2X", pidForCell) + " " + descrip!
    }
    
}
