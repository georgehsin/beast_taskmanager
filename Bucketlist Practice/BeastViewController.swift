//
//  BeastViewController.swift
//  Bucketlist Practice
//
//  Created by George Hsin on 11/18/16.
//  Copyright © 2016 George Hsin. All rights reserved.
//

import UIKit
import CoreData

class BeastViewController: UITableViewController, UISearchBarDelegate {
    var beastedlist = [Beast]()
    var data = [String]()
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(searchActive) {
            return filtered.count
        }
        return beastedlist.count
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MyCell") as! BeastedCell
        //        REMEMBER TO CHANGE SOMETHING TO ACCESS OBJECT AND ATTRIBUTE
        if(searchActive){
            cell.beastedlabel.text = filtered[indexPath.row]
        }
        else {
            cell.beastedlabel.text = beastedlist[indexPath.row].beasted
        }
        cell.datetime.text = beastedlist[indexPath.row].date
        return cell
    }

    
    override func viewDidLoad() {
        let userRequest = NSFetchRequest(entityName: "Beast")
        do {
            let results = try managedObjectContext.executeFetchRequest(userRequest)
            beastedlist = results as! [Beast]
        } catch {
            print("\(error)")
        }
        super.viewDidLoad()
        self.tableView.reloadData()
        searchBar.delegate = self
        print ("printing filtered")
        print (filtered)
        self.searchActive = false
    }
        // Do any additional setup after loading the view, typically from a nib.

    override func viewWillAppear(animated: Bool) {
        let userRequest = NSFetchRequest(entityName: "Beast")
        do {
            let results = try managedObjectContext.executeFetchRequest(userRequest)
            beastedlist = results as! [Beast]
        } catch {
            print("\(error)")
        }
        self.tableView.reloadData()
        self.searchBar.text = ""
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        managedObjectContext.deleteObject(beastedlist[indexPath.row])
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
                print("Success")
            } catch {
                print("\(error)")
            }
        }
        let userRequest = NSFetchRequest(entityName: "Beast")
        do {
            let results = try managedObjectContext.executeFetchRequest(userRequest)
            beastedlist = results as! [Beast]
        } catch {
            print("\(error)")
        }
        tableView.reloadData()
    }
    
//    ---------- SEARCHBAR -----------
    var searchActive : Bool = false
    @IBOutlet weak var searchBar: UISearchBar!
    var filtered:[String] = []
    
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        for i in 0...beastedlist.count-1 {
            data.append(beastedlist[i].beasted!)
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
        print (data)
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
        print (filtered)
        self.tableView.reloadData()
    }

}
    
    

