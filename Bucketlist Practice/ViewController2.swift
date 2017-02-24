//
//  ViewController2.swift
//  Bucketlist Practice
//
//  Created by George Hsin on 11/17/16.
//  Copyright © 2016 George Hsin. All rights reserved.
//

import UIKit

class ViewControllerTwo: UITableViewController {
    weak var cancelbuttondelegate: CancelButtonDelegate?
    weak var donebuttondelegate: DoneButtonDelegate?
    @IBOutlet weak var cellText: UITextField!
    var editTask: Tasks?
    @IBAction func cancelButtonPressed(sender: UIBarButtonItem) {
        cancelbuttondelegate?.cancelButtonPressedFrom(self)
    }
    @IBAction func DoneButtonPressed(sender: UIBarButtonItem) {
        if let object = editTask {
            object.task = cellText.text!
            donebuttondelegate?.DoneButtonPressed(self, FinishEditing: editTask!)
        }
        else {
            let object = cellText.text!
            donebuttondelegate?.DoneButtonPressed(self, FinishAdding: object)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        if let object = editTask {
            cellText.text = editTask?.task
        }
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
