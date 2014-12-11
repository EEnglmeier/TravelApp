//
//  RouteTableView.swift
//  TravelApp
//
//  Created by Eli on 06.12.14.
//  Copyright (c) 2014 Eli. All rights reserved.
//

import UIKit

class RouteTableView : UIViewController,UITableViewDelegate,UITableViewDataSource{
    
    @IBOutlet
    var tableView:UITableView!
    let routeModel : RouteModel = RouteModel()
    var selectedItems :[Marker] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.allowsMultipleSelection = true
        self.tableView.registerClass(UITableViewCell.self,forCellReuseIdentifier:"cell")
    }
 
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.routeModel.allLocs.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier("cell") as UITableViewCell
        cell.textLabel.text = self.routeModel.allLocs[indexPath.item].getName()
        return cell
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
         self.selectedItems.append(routeModel.allLocs[indexPath.row])
    /*
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        var cell : UITableViewCell = self.tableView.cellForRowAtIndexPath(indexPath)!;
        cell.accessoryType = UITableViewCellAccessoryType.Checkmark
        */
    }
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        self.selectedItems.removeObject(routeModel.allLocs[indexPath.row])
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "DataToMap"){
            var svc = segue.destinationViewController as RouteMapView
            svc.passedData = selectedItems
        }
    }
    
}
extension Array {
    mutating func removeObject<U: Equatable>(object: U) {
        var index: Int?
        for (idx, objectToCompare) in enumerate(self) {
            if let to = objectToCompare as? U {
                if object == to {
                    index = idx
                }
            }
        }
        
        if((index) != nil) {
            self.removeAtIndex(index!)
        }
    }
}