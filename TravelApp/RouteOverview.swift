//
//  RouteOverview.swift
//  TravelApp
//
//  Created by Eli on 13.12.14.
//  Copyright (c) 2014 Eli. All rights reserved.
//

import UIKit
import Parse

class RouteOverview : UIViewController,UITableViewDelegate,UITableViewDataSource{
    
    var tableView:UITableView = UITableView()
    var selectedItems :[Marker] = []
    var selectedRow = 0

    
    override func viewDidLoad() {
        //Add and Configure TableView
        tableView.frame = CGRectMake(10, 75, 300, 400)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.autoresizingMask = UIViewAutoresizing.FlexibleHeight
        tableView.allowsMultipleSelection = false
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.view.addSubview(tableView)
        
    
        var navBar = UINavigationBar()
        navBar.frame = CGRectMake(self.view.bounds.minX,self.view.bounds.minY,self.view.bounds.width,70)
        navBar.backgroundColor = UIColor.grayColor()
        var newRouteButton = UIButton.buttonWithType(UIButtonType.System) as UIButton
        newRouteButton.frame = CGRectMake(220,25,150,50)
        newRouteButton.setImage(UIImage(named: "Add_Route.png"), forState: UIControlState.Normal)
        newRouteButton.addTarget(self, action: "showRoutesAction:", forControlEvents: UIControlEvents.TouchUpInside)
        navBar.addSubview(newRouteButton)
        self.view.addSubview(navBar)
        var titelLabel = UILabel(frame: CGRectMake(self.view.frame.midX-60, 0, 150, 100))
        titelLabel.text = "Route Overview"
        titelLabel.textColor = UIColor.blackColor()
        //titelLabel.font = UIFont(name: "IowanOldStyle-Bold",size: 15)
        self.view.addSubview(titelLabel)
        super.viewDidLoad()
    }

    override func viewWillAppear(animated: Bool) {
        tableView.reloadData()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(!RouteModel.sharedInstance.allRoutes.isEmpty){
            tableView.allowsSelection = true
            return RouteModel.sharedInstance.allRoutes.count}
        else{
            tableView.allowsSelection = false;
            return 1;
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier("cell") as UITableViewCell
        if(!RouteModel.sharedInstance.allRoutes.isEmpty){
            cell.textLabel.text = RouteModel.sharedInstance.allRoutes[indexPath.item].name}
        else{
        cell.textLabel.text = "No Routes found"
        }
        return cell
    }
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
           return !RouteModel.sharedInstance.allRoutes.isEmpty
    }
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if(editingStyle == UITableViewCellEditingStyle.Delete && !RouteModel.sharedInstance.allRoutes.isEmpty){
            var parseDelete = PFQuery(className: "Route")
            parseDelete.whereKey("routeName", containsString: RouteModel.sharedInstance.allRoutes[indexPath.row].name)
            var obj = parseDelete.findObjects()
            obj[0].deleteEventually()
            RouteModel.sharedInstance.allRoutes.removeAtIndex(indexPath.row)
            tableView.reloadData()
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.selectedRow = indexPath.row
        self.performSegueWithIdentifier("RouteToRouteMapView", sender: self)
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "RouteToRouteMapView"){
            var svc = segue.destinationViewController as RouteMapView
            svc.passedData = RouteModel.sharedInstance.allRoutes[selectedRow].orderderdMarkers
        }
    }
    func showRoutesAction(sender:UIButton){
        self.performSegueWithIdentifier("RouteOverViewToRouteTableView", sender: self)
    }
    @IBAction
    func unwind(segue:UIStoryboardSegue){
        var svc = segue.sourceViewController as RouteMapView
        if(segue.identifier == "RouteMapViewToRoute" && svc.passedData != nil && svc.routeName != nil){
            let route = Route(markers: svc.passedData, name: svc.routeName)
        }
        tableView.reloadData()
    }
    
    @IBAction
    func unwindFromTableView(segue:UIStoryboardSegue){
        tableView.reloadData()
    }
}