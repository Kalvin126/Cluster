//
//  UIAlertController.swift
//  Cluster
//
//  Created by Kalvin Loc on 7/4/16.
//  Copyright © 2016 Red Panda. All rights reserved.
//

import UIKit

extension UIAlertController {
    
    func addActions(_ actions: [UIAlertAction]) {
        actions.forEach {
            addAction($0)
        }
    }
    
}
