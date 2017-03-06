//
//  LinkedNode.swift
//  Cluster
//
//  Created by Kalvin Loc on 7/4/16.
//  Copyright © 2016 Red Panda. All rights reserved.
//

import Foundation

final class LinkedNode<T> {
    
    var num: T
    
    var nextNode: LinkedNode?
    
    init(num: T) {
        self.num = num
    }
    
}
