//
//  TripTVC.swift
//  Cluster
//
//  Created by Kalvin Loc on 5/27/16.
//  Copyright © 2016 Red Panda. All rights reserved.
//

import Charts
import UIKit

class TripsTVC: UITableViewController {
    
    var barGraph: BarChartView?
    
    var tripData: [TripWeek] = [TripWeek]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupGraph()
        
        refreshData()
        reloadGraphData()
    }
    
    func refreshData() {
//        tripData.append(TripComputer.sharedComputer.trips(forWeek: 0))
//        tripData.append(TripComputer.sharedComputer.trips(forWeek: 1))
//        tripData.append(TripComputer.sharedComputer.trips(forWeek: 2))
//        tripData.append(TripComputer.sharedComputer.trips(forWeek: 3))
//    
//        tableView.reloadData()
    }
    
    func setupGraph() {
        barGraph = BarChartView(frame: CGRect(x: 0,y: 0,width: UIScreen.main.bounds.width, height: 225))
        barGraph?.backgroundColor = UIColor.tealColor()
        tableView.tableHeaderView = barGraph
        
        // Graph View settings
        barGraph?.noDataText = "No Information. Have a drive arround!"
        barGraph?.chartDescription?.text = ""
        
        // Scaling
        barGraph?.setScaleEnabled(false)
        barGraph?.dragEnabled = false
        
        // Grid
        barGraph?.xAxis.drawAxisLineEnabled  = false
        barGraph?.xAxis.drawGridLinesEnabled = false
        barGraph?.xAxis.labelTextColor = UIColor.white
        barGraph?.xAxis.labelPosition = .bothSided
        
        barGraph?.rightAxis.drawAxisLineEnabled  = false
        barGraph?.rightAxis.drawLabelsEnabled = false
        
        barGraph?.leftAxis.drawAxisLineEnabled  = false
        barGraph?.leftAxis.drawGridLinesEnabled = false
        barGraph?.leftAxis.labelTextColor = UIColor.white
        barGraph?.leftAxis.labelCount = 4
        barGraph?.leftAxis.spaceTop = 0.15
        
        // Legend
        barGraph?.legend.enabled = false
        
        barGraph?.animate(xAxisDuration: 0.5, yAxisDuration: 1.0)
        
        barGraph?.delegate = self
    }
    
    func reloadGraphData() {
        // Chart Limit Line
        let targetLine = ChartLimitLine(limit: 31.0, label: "31") // TODO constant
        targetLine.valueTextColor = UIColor.white
        targetLine.labelPosition = .leftTop
        
        barGraph?.rightAxis.addLimitLine(targetLine)
        
        // Chart Data
        var dataEntries = [BarChartDataEntry]()
        
        for i in (0..<tripData[0].tripDays.count) {
            let tripWeek = tripData[0]
            let tripForEntry = tripWeek.tripDays[i]
            
            let entry = BarChartDataEntry(x: Double(tripWeek.tripDays.count-i-1), y: tripForEntry.avgMPG)

            dataEntries.append(entry)
        }
        
        let chartDataSet = BarChartDataSet(values: dataEntries, label: nil)
        chartDataSet.drawValuesEnabled = false
        
        let chartData = BarChartData(dataSet: chartDataSet)
        
        chartDataSet.colors = [UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.6)]
        
        barGraph?.data = chartData
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if segue.identifier == "tripDaySegue" {
            let dest = segue.destination as! TripDayTVC
            
            let path = tableView.indexPathForSelectedRow!
            let selectedTripDay = tripData[(path as NSIndexPath).section].tripDays[(path as NSIndexPath).row]
            
            dest.tripDay = selectedTripDay
        }
    }
    
}

// MARK: IBActions
extension TripsTVC {
    
    @IBAction func pressedReset(_ sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: "Reset Trip", message: "Are you sure?", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in }
        let resetAction = UIAlertAction(title: "Reset", style: .destructive) { _ in
            TripComputer.sharedComputer.resetTrip()
        }
        
        alertController.addActions([cancelAction, resetAction])
        
        present(alertController, animated: true) { }
    }
    
}

// MARK: UITableViewDataSource
extension TripsTVC {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return tripData.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tripData[section].tripDays.count
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let tripWeekForHeader = tripData[section]
        
        let cellAsHeader = tableView.dequeueReusableCell(withIdentifier: "headerCell") as! TripsHeaderTableViewCell
        cellAsHeader.tripWeek = tripWeekForHeader
        cellAsHeader.isCurrentWeek = (section == 0)
        
        return cellAsHeader
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: "tripCell")!
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let tripForCell = tripData[(indexPath as NSIndexPath).section].tripDays[(indexPath as NSIndexPath).row]
        
        (cell as! TripsTableViewCell).tripDay = tripForCell
    }

}

extension TripsTVC: ChartViewDelegate {
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        
    }
    
    
    
    
    
}
