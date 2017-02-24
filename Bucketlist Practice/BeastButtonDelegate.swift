//
//  BeastButtonDelegate.swift
//  Bucketlist Practice
//
//  Created by George Hsin on 11/18/16.
//  Copyright © 2016 George Hsin. All rights reserved.
//

import Foundation
protocol BeastButtonDelegate: class {
    func BeastButtonPressed(sender: CustomCell, indexPath: Int)
}
