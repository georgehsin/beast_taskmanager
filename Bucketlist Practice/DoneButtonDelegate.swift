//
//  DoneButtonDelegate.swift
//  Bucketlist Practice
//
//  Created by George Hsin on 11/17/16.
//  Copyright © 2016 George Hsin. All rights reserved.
//

import Foundation
protocol DoneButtonDelegate: class {
    func DoneButtonPressed(controller: ViewControllerTwo, FinishAdding object: String)
    func DoneButtonPressed(controller: ViewControllerTwo, FinishEditing object: Tasks)
}
