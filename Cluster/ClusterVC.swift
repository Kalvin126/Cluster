//
//  ClusterVC.swift
//  Cluster
//
//  Created by Kalvin Loc on 4/24/16.
//  Copyright © 2016 Red Panda. All rights reserved.
//

import UIKit

import ReactiveCocoa
import ReactiveSwift

class ClusterVC: UIViewController {
    
    let viewModel = ClusterViewModel()
    
    var firstLaunch = true
    
    var cluster: ClusterView {
        guard let clusterView = view as? ClusterView else {
            fatalError("ERROR: ClusterVC.view not of type ClusterVeiw")
        }
        
        return clusterView
    }
    
}

// MARK: - UIViewController
extension ClusterVC {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        cluster.setup()
        
        initGaugeBindings()
        
        if firstLaunch {
            firstLaunch = false
            
            viewModel.resetLabels()
        }
    }
    
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        return .landscape
    }
    
    override var prefersStatusBarHidden : Bool {
        return false
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
}

// MARK: - Actions
extension ClusterVC {
    
    fileprivate func initGaugeBindings() {
        
        with(viewModel.engineCoolantTemp) {
            cluster.engineTempLabel.reactive.text <~ $0.map { "\($0)" }
            $0.signal.observeValues { self.cluster.updateCoolantStatusWithTemperature($0) }
        }
        
        with(viewModel.rpm) {
            $0.signal.observeValues {
                self.cluster.updateRPMBarWithRPM($0, and: self.viewModel.fuelSystemStatus.value)
            }
        }
        
        with(viewModel.speed) {
            cluster.speedometerLabel.reactive.text <~ $0.map { "\(Int($0.toMilesPerHour()))" }
        }
        
        with(viewModel.throttlePos) {
            cluster.tpsLabel.reactive.text <~ $0.map { "\($0)" }
            $0.signal.observeValues { self.cluster.setTPSStatus(forPosition: $0) }
        }
        
        with(viewModel.gasLevel) {
            cluster.gasLevelLabel.reactive.text <~ $0.map { String(format: "%.1f%%", $0) }
            $0.signal.observeValues { self.cluster.updateFuelLevel(level: $0) }
        }
        
        with(viewModel.avgMPG) {
            cluster.avgMPGLabel.reactive.text <~ $0.map { String(format: "%.1f", $0) }
        }
        
        with(viewModel.mpg) {
            cluster.instantMPGLabel.reactive.text <~ $0.map { ($0 == 9999.0 ? "9999" : String(format: "%.1f", $0)) }
        }
        
        with(viewModel.totalDistance) {
            cluster.distanceTraveledLabel.reactive.text <~ $0.map { String(format: "%.1f mi", $0) }
        }
        
        with(viewModel.range) {
            cluster.rangeLabel.reactive.text <~ $0.map { "~\(Int($0)) mi range"  }
        }
        
    }
    
}
