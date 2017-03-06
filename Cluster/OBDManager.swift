//
//  OBDManager.swift
//  Cluster
//
//  Created by Kalvin Loc on 4/29/16.
//  Copyright © 2016 Red Panda. All rights reserved.
//

import UIKit

class OBDManager: NSObject {    
    fileprivate let scanTool = FLScanTool(for: kScanToolDeviceTypeELM327)
    
    weak var delegate: OBDDelegate?
    
    var scanning = false
    var receivingResponses = false {
        didSet {
            if  !receivingResponses &&
                UIDevice.current.batteryState == .unplugged {
                exit(2)
            }
        }
    }
    
    var availiblePIDs: [Any]! {
        return scanTool?.supportedSensors
    }
    
    func scan() {
        scanTool?.delegate = self
        
        if (scanTool?.isWifiScanTool)! {
            scanTool?.host = "192.168.0.10"
            scanTool?.port = 35000
        }
        
        scanTool?.startScan()
    }
    
    func stopScan() {
        if (scanTool?.isWifiScanTool)! {
            scanTool?.cancelScan()
        }
        
        scanTool?.sensorScanTargets = nil
        scanTool?.delegate = nil
    }
    
}

protocol OBDDelegate: class {
    
    func scanTargetsForOBD(_ manager: OBDManager) -> [UInt]
    
    
    func managerDidInititialize(_ manager: OBDManager)
    func OBD(_ manager: OBDManager, didRecieveResponse response: FLScanToolResponse)
    func managerDidFinishProcessingResponseRound(_ manager: OBDManager)
    
    func OBD(_ manager: OBDManager, didRecieveVoltage volt: String)
}

// MARK: FLScanToolDelegate
extension OBDManager: FLScanToolDelegate {
    
    func scanDidStart(_ scanTool: FLScanTool!) {
        print("Started Scan")
        scanning = true
        
        scanTool.getTroubleCodes()
    }
    
    func scanDidPause(_ scanTool: FLScanTool!) {
        print("Scan paused")
        
    }
    
    func scanDidCancel(_ scanTool: FLScanTool!) {
        print("Scan Canceled")
        scanning = false
    }
    
    func scanToolDidConnect(_ scanTool: FLScanTool!) {
        print("connected!")
    }
    
    func scanToolWillSleep(_ scanTool: FLScanTool!) {
        print("sleeping")
    }
    
    func scanToolDidFail(toInitialize scanTool: FLScanTool!) {
        print(")failed to init")
    }
    
    func scanToolDidInitialize(_ scanTool: FLScanTool!) {
        print("Scan Inited")
        
        scanTool.sensorScanTargets = delegate?.scanTargetsForOBD(self)
        
        delegate?.managerDidInititialize(self)
        // TODO 1F - Egine run time
    }
    
    func scanTool(_ scanTool: FLScanTool!, didReceiveResponse responses: [Any]!) {
        // repsonses can be nil if car is shutoff
        
        if responses == nil {
            receivingResponses = false
        }
        else {
            receivingResponses = true
            
            for response in (responses as! [FLScanToolResponse]) {
                guard response.pid != 0 else {
                    continue
                }
                
                delegate?.OBD(self, didRecieveResponse: response)
            }
        }
        delegate?.managerDidFinishProcessingResponseRound(self)
    }
   
    func scanTool(_ scanTool: FLScanTool!, didReceiveError error: Error!) {
        print(error)
    }
    
    func scanToolDidDisconnect(_ scanTool: FLScanTool!) {
        
    }
    
    func scanTool(_ scanTool: FLScanTool!, didReceiveVoltage voltage: String!) {
        delegate?.OBD(self, didRecieveVoltage: voltage)
    }
}
