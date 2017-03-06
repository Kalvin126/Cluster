//
//  TripDayTVC.swift
//  Cluster
//
//  Created by Kalvin Loc on 6/10/16.
//  Copyright © 2016 Red Panda. All rights reserved.
//

import Charts
import UIKit

class TripDayTVC: UITableViewController {

    var barGraph: BarChartView?
    
    var tripDay: TripDay?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupGraph()
        reloadGraphData()
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
    }
    
    func reloadGraphData() {
        // Chart Limit Line
        let targetLine = ChartLimitLine(limit: 31.0, label: "31") // TODO constant
        targetLine.valueTextColor = UIColor.white
        targetLine.labelPosition = .leftTop
        
        barGraph?.rightAxis.addLimitLine(targetLine)
        
        // Chart Data
        var dataEntries = [BarChartDataEntry]()
        
        for i in (0..<tripDay!.trips.count) {
            let tripForEntry = tripDay!.trips[i]
            let dataEntry = BarChartDataEntry(x: Double(tripDay!.trips.count-1-i), y: tripForEntry.avgMPG)
            
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet = BarChartDataSet(values: dataEntries, label: nil)
        chartDataSet.drawValuesEnabled = false
        
        let chartData = BarChartData(dataSet: chartDataSet)
        
        chartDataSet.colors = [UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.6)]
        
        barGraph?.data = chartData
    }
    
}

// MARK: TableViewDataSource
extension TripDayTVC {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tripDay!.trips.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: "tripDayCell")!
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let tripForCell = tripDay?.trips[(indexPath as NSIndexPath).row]
        
        (cell as! TripDayTableViewCell).trip = tripForCell
    }
    
}
