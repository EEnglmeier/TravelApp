//
//  RouteOverview.swift
//  TravelApp
//
//  Created by Eli on 13.12.14.
//  Copyright (c) 2014 Eli. All rights reserved.
//

import UIKit

class RouteOverview : UIViewController,UITableViewDelegate,UITableViewDataSource{
    
    var tableView:UITableView = UITableView()
    var routeModel : RouteModel = RouteModel()
    var selectedItems :[Marker] = []
    var selectedRow = 0

    
    override func viewDidLoad() {
        
        //Add and Configure TableView
        tableView.frame = CGRectMake(10, 75, 320, 400)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.autoresizingMask = UIViewAutoresizing.FlexibleHeight
        tableView.allowsMultipleSelection = false
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.reloadData()
        self.view.addSubview(tableView)
    
        var navBar = UINavigationBar()
        navBar.frame = CGRectMake(self.view.bounds.minX,self.view.bounds.minY,self.view.bounds.width,70)
        navBar.backgroundColor = UIColor.grayColor()
        var newRouteButton = UIButton.buttonWithType(UIButtonType.System) as UIButton
        newRouteButton.frame = CGRectMake(225,20,150,50)
        newRouteButton.setTitle("Add new Route", forState: UIControlState.Normal)
        newRouteButton.addTarget(self, action: "showRoutesAction:", forControlEvents: UIControlEvents.TouchUpInside)
        navBar.addSubview(newRouteButton)
        self.view.addSubview(navBar)
        println(routeModel.allRoutes.count)
        super.viewDidLoad()
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(!routeModel.allRoutes.isEmpty){
            tableView.allowsSelection = true
            return self.routeModel.allRoutes.count}
        else{
            tableView.allowsSelection = false;
            return 1;
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier("cell") as UITableViewCell
        if(!routeModel.allRoutes.isEmpty){
            cell.textLabel.text = self.routeModel.allRoutes[indexPath.item].name}
        else{
        cell.textLabel.text = "No Routes found"
        }
        return cell
    }
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        if(routeModel.allRoutes.isEmpty){
            return false
        }
        else {
            return true
        }
    }
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if(editingStyle == UITableViewCellEditingStyle.Delete && !routeModel.allRoutes.isEmpty){
            self.routeModel.allRoutes.removeAtIndex(indexPath.row)
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
            svc.passedData = routeModel.allRoutes[selectedRow].orderderdMarkers
            svc.routeModel = self.routeModel
        }
        if(segue.identifier == "RouteOverViewToRouteTableView"){
            var svc = segue.destinationViewController as RouteTableView
            svc.routeModel = self.routeModel
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
        svc.routeModel = self.routeModel
        tableView.reloadData()
    }
}