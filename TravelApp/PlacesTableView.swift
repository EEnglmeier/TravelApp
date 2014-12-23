//
//  PlacesTableView.swift
//  TravelApp
//
//  Created by Eli on 23.12.14.
//  Copyright (c) 2014 Eli. All rights reserved.
//

import Foundation

class PlacesTableView: UIViewController,UITableViewDelegate,UITableViewDataSource{
    
    var tableView:UITableView = UITableView()
    var selectedItems :[Marker] = []
    
    override func viewDidLoad() {
        //Add and Configure TableView
        tableView.frame = CGRectMake(10, 75, 300, 400)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.autoresizingMask = UIViewAutoresizing.FlexibleHeight
        tableView.allowsMultipleSelection = false
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.reloadData()
        self.view.addSubview(tableView)
        
        //Add and Configure NavigationBar
        var navBar = UINavigationBar()
        navBar.frame = CGRectMake(self.view.bounds.minX,self.view.bounds.minY,self.view.bounds.width,70)
        navBar.backgroundColor = UIColor.grayColor()
        self.view.addSubview(navBar)
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(!RouteModel.sharedInstance.allLocs.isEmpty){
            tableView.allowsSelection = true
            return RouteModel.sharedInstance.allLocs.count}
        else{
            tableView.allowsSelection = false;
            return 1;
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "cell")
        if(!RouteModel.sharedInstance.allLocs.isEmpty){
            cell.textLabel.numberOfLines = 0
            cell.textLabel.text = RouteModel.sharedInstance.allLocs[indexPath.item].name
            cell.detailTextLabel?.text =  RouteModel.sharedInstance.allLocs[indexPath.item].address
        }
        else{
            cell.textLabel.text = "No Places found"
        }
        return cell
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.selectedItems.append(RouteModel.sharedInstance.allLocs[indexPath.row])
    }
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        self.selectedItems.removeObject(RouteModel.sharedInstance.allLocs[indexPath.row])
    }
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return !RouteModel.sharedInstance.allLocs.isEmpty
    }
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if(editingStyle == UITableViewCellEditingStyle.Delete && !RouteModel.sharedInstance.allLocs.isEmpty){
            RouteModel.sharedInstance.allLocs.removeAtIndex(indexPath.row)
            tableView.reloadData()
        }
    }
}