//
//  TankTVC.swift
//  Cluster
//
//  Created by Kalvin Loc on 5/28/16.
//  Copyright © 2016 Red Panda. All rights reserved.
//

import RealmSwift
import UIKit

class TankTVC: UITableViewController {

    var tankData = [Tank]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        refreshData()
    }
    
    func refreshData() {
        let realm = try! Realm()
        let trips = realm.objects(Tank.self).sorted(byProperty: "id")
        
        tankData = Array(trips)
        
        tableView.reloadData()
    }
    
    @IBAction func pressedReset(_ sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: "Reset Tank", message: "Are you sure?", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in }
        
        
        let resetAction = UIAlertAction(title: "Reset", style: .destructive) { (action) in
            TripComputer.sharedComputer.resetTank()
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(resetAction)
        
        self.present(alertController, animated: true) { }

    }
}

// MARK: TableViewDataSource
extension TankTVC {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tankData.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: "tankCell")!
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        let tankForCell = tankData[(indexPath as NSIndexPath).row]
        
        let dateLabel = cell.viewWithTag(1) as! UILabel
        let detailLabel = cell.viewWithTag(2) as! UILabel
        let mpgLabel = cell.viewWithTag(3) as! UILabel
        
        let formatter = DateFormatter()
        formatter.dateFormat = "E, M/dd/yy, h:mm a"
        dateLabel.text = formatter.string(from: tankForCell.startDate as Date)
        
        detailLabel.text = String(format: "%.1f mi", tankForCell.distanceTraveled)
        
        mpgLabel.text = String(format: "%.1f mpg", tankForCell.avgMPG)
    }
    
}
