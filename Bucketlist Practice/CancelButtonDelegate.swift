//
//  CancelButtonDelegate.swift
//  Bucketlist Practice
//
//  Created by George Hsin on 11/17/16.
//  Copyright © 2016 George Hsin. All rights reserved.
//

import Foundation
import UIKit
protocol CancelButtonDelegate: class {
    func cancelButtonPressedFrom(controller: UIViewController)
}
