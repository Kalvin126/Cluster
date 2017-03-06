//
//  ReactiveSwift+Cluster.swift
//  Cluster
//
//  Created by Kalvin Loc on 3/5/17.
//  Copyright © 2017 Red Panda. All rights reserved.
//

import ReactiveSwift
import ReactiveCocoa
import Result

enum ClusterError: Error {
    
    case none
    case error

}

class StringProperty: PropertyProtocol {

    var value: String
    
    var signal: Signal<String, NoError>
    
    var producer: SignalProducer<String, NoError> {
        return SignalProducer { (observer, disposable) in
            observer.send(value: self.value)
        }
    }
    
    init() {
        value = ""
        
        signal = Signal { (observer) -> Disposable? in
            
            return nil
        }
        
    }
    
}


