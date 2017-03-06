//
//  InfoTVC.swift
//  Cluster
//
//  Created by Kalvin Loc on 5/27/16.
//  Copyright © 2016 Red Panda. All rights reserved.
//

import UIKit

class InfoTVC: UITableViewController {
    
    
    @IBOutlet weak var supportedSensorsLabel: UILabel!
    
    @IBOutlet weak var voltageLabel: UILabel!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        setupLabels()
    }
    
    func setupLabels() {
        // Supported Sensors
        supportedSensorsLabel.text = "\(DiagData.sharedData.supportedPIDs.count)"
        
        // Voltage
        voltageLabel.text = DiagData.sharedData.voltage
    }

    
    @IBAction func closeButtonPressed(_ sender: AnyObject) {
        navigationController?.dismiss(animated: true, completion: nil)
    }

}
