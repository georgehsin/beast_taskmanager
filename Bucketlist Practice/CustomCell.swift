//
//  CustomCell.swift
//  Bucketlist Practice
//
//  Created by George Hsin on 11/18/16.
//  Copyright © 2016 George Hsin. All rights reserved.
//

import Foundation
import UIKit

class CustomCell: UITableViewCell {
    

    weak var beastbuttondelegate: BeastButtonDelegate?
    var indexpath: Int?
    @IBOutlet weak var cellTask: UILabel!
    @IBAction func beastButtonPressed(sender: UIButton) {
        if let index = indexpath {
            beastbuttondelegate?.BeastButtonPressed(self, indexPath: index)
            print("buttonpressed")
        }
    }
    
    
}
