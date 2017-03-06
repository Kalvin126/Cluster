//
//  Helpers.swift
//  Cluster
//
//  Created by Kalvin Loc on 3/5/17.
//  Copyright © 2017 Red Panda. All rights reserved.
//

import Foundation

@discardableResult func with<T>(_ value: T, block: (T) -> Void) -> T {
    block(value)
    
    return value
}
