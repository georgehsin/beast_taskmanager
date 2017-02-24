//
//  ViewController.swift
//  Bucketlist Practice
//
//  Created by George Hsin on 11/17/16.
//  Copyright © 2016 George Hsin. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UITableViewController, CancelButtonDelegate, DoneButtonDelegate, BeastButtonDelegate, UISearchBarDelegate {
    
//    ------- DONT FORGET THIS FOR COREDATA - INITIALIZE A VARIABLE AS YOUR COREDATA ARRAY ------
    var something = [Tasks]()
    var beastedlist = [Beast]()
    var data = [String]()
//    ------- DONT FORGET THIS FOR COREDATA - INITIALIZE A VARIABLE AS YOUR COREDATA ARRAY ------
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
//    var something = ["One","Two","Three"]
    
    override func viewDidLoad() {
        let userRequest = NSFetchRequest(entityName: "Tasks")
        do {
            let results = try managedObjectContext.executeFetchRequest(userRequest)
            something = results as! [Tasks]
        } catch {
            print("\(error)")
        }

        super.viewDidLoad()
        getCurrentTime()
        
        searchBar.delegate = self
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func cancelButtonPressedFrom(controller: UIViewController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(searchActive) {
            return filtered.count
        }
        return something.count
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MyCell") as! CustomCell
//        REMEMBER TO CHANGE SOMETHING TO ACCESS OBJECT AND ATTRIBUTE
//        cell!.textLabel?.text = something[indexPath.row].task
        if(searchActive){
            cell.cellTask.text = filtered[indexPath.row]
        }
        else {
            cell.cellTask.text = something[indexPath.row].task
        }
        cell.beastbuttondelegate = self
        cell.indexpath = indexPath.row
        return cell
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "goToUpdate" {
            let navigationController = segue.destinationViewController as! UINavigationController
            let controller = navigationController.topViewController as! ViewControllerTwo
            controller.cancelbuttondelegate = self
            controller.donebuttondelegate = self
            if let indexPath = tableView.indexPathForCell(sender as! CustomCell) {
                 controller.editTask = something[indexPath.row]
            }
        }
        else {
            let navigationController = segue.destinationViewController as! UINavigationController
            let controller = navigationController.topViewController as! ViewControllerTwo
            controller.cancelbuttondelegate = self
            controller.donebuttondelegate = self
        }

    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("goToUpdate", sender: tableView.cellForRowAtIndexPath(indexPath))
//    override func tableView(tableView: UITableView, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) {
//        performSegueWithIdentifier("goToUpdate", sender: tableView.cellForRowAtIndexPath(indexPath))
    }

    @IBAction func AddButtonPressed(sender: UIBarButtonItem) {
        performSegueWithIdentifier("goToAdd", sender: self)
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        managedObjectContext.deleteObject(something[indexPath.row])
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                print("\(error)")
            }
        }
        let userRequest = NSFetchRequest(entityName: "Tasks")
        do {
            let results = try managedObjectContext.executeFetchRequest(userRequest)
            something = results as! [Tasks]
        } catch {
            print("\(error)")
        }
        tableView.reloadData()


    }
    
    func DoneButtonPressed(controller: ViewControllerTwo, FinishEditing object: Tasks) {
        dismissViewControllerAnimated(true, completion: nil)
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                print("\(error)")
            }
        }
        
        tableView.reloadData()
    }
    
    func DoneButtonPressed(controller: ViewControllerTwo, FinishAdding object: String) {
        dismissViewControllerAnimated(true, completion: nil)
//        let missionmanager = NSEntityDescription.insertNewObjectForEntityForName("Tasks", inManagedObjectContext: managedObjectContext) as! Tasks
        let thing = NSEntityDescription.insertNewObjectForEntityForName("Tasks", inManagedObjectContext: managedObjectContext) as! Tasks
//        MISSIONMANAGER IS THE OBJECT (OBJECTS CAN HAVE MORE THAN ONE ATTRIBUTE), TASK IS THE ATTRIBUTE 
//        because we have core data, we don't really need delegates, we can just save the information and pass it on or call on it
        thing.task = object
//        MISSIONMANAGER IS THE OBJECT (OBJECTS CAN HAVE MORE THAN ONE ATTRIBUTE), TASK IS THE ATTRIBUTE
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                print("\(error)")
            }
        }
        let userRequest = NSFetchRequest(entityName: "Tasks")
        do {
            let results = try managedObjectContext.executeFetchRequest(userRequest)
            something = results as! [Tasks]
        } catch {
            print("\(error)")
        }
        tableView.reloadData()
    }
    
    func BeastButtonPressed(sender: CustomCell, indexPath: Int) {
        let item = something[indexPath].task
        managedObjectContext.deleteObject(something[indexPath])
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                print("\(error)")
            }
        }
        let userRequest = NSFetchRequest(entityName: "Tasks")
        do {
            let results = try managedObjectContext.executeFetchRequest(userRequest)
            something = results as! [Tasks]
        } catch {
            print("\(error)")
        }
        tableView.reloadData()
//       ---------- THE LOWER PORTION IS TO ADD TO THE BEASTED LIST -----------
        let thing = NSEntityDescription.insertNewObjectForEntityForName("Beast", inManagedObjectContext: managedObjectContext) as! Beast
        //        MISSIONMANAGER IS THE OBJECT (OBJECTS CAN HAVE MORE THAN ONE ATTRIBUTE), TASK IS THE ATTRIBUTE
        //        because we have core data, we don't really need delegates, we can just save the information and pass it on or call on it
        thing.beasted = item
        let today = getCurrentTime()
        thing.date = today
        //        MISSIONMANAGER IS THE OBJECT (OBJECTS CAN HAVE MORE THAN ONE ATTRIBUTE), TASK IS THE ATTRIBUTE
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                print("\(error)")
            }
        }
        tableView.reloadData()
    }

    func getCurrentTime() -> String {
        
        let date = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "EEE MMM dd"
        let stringValue = formatter.stringFromDate(date)
        
        return stringValue
        
    }

//   --------- SEARCHBAR CODE ----------
    var searchActive : Bool = false
    @IBOutlet weak var searchBar: UISearchBar!
    
    var filtered:[String] = []
    
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        for i in 0...something.count-1 {
            data.append(something[i].task!)
        }
        if searchBar.text == "" {
            searchActive = false
        }
        else {
            searchActive = true;
        }

    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        searchActive = false;
        data = [String]()
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchActive = false;
        data = [String]()
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        

        filtered = data.filter({ (text) -> Bool in
            let tmp: NSString = text
            let range = tmp.rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch)
            return range.location != NSNotFound
        })
        if(filtered.count == 0){
            searchActive = false;
        } else {
            searchActive = true;
        }
        
        self.tableView.reloadData()
    }
    
    override func viewWillAppear(animated: Bool) {
        let userRequest = NSFetchRequest(entityName: "Tasks")
        do {
            let results = try managedObjectContext.executeFetchRequest(userRequest)
            something = results as! [Tasks]
        } catch {
            print("\(error)")
        }
        self.tableView.reloadData()
        self.searchBar.text = ""
    }

    
}



