//
//  RouteTableView.swift
//  TravelApp
//
//  Created by Eli on 06.12.14.
//  Copyright (c) 2014 Eli. All rights reserved.
//

import UIKit
import Parse

class RouteTableView : UIViewController,UITableViewDelegate,UITableViewDataSource{
    
    var tableView:UITableView = UITableView()
    var selectedItems :[Marker] = []
    var textfieldInput : UITextField!
    
    override func viewDidLoad() {

        //Add and Configure TableView
        tableView.frame = CGRectMake(10, 75, 300, 400)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.autoresizingMask = UIViewAutoresizing.FlexibleHeight
        tableView.allowsMultipleSelection = true
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.reloadData()
        self.view.addSubview(tableView)
        
        //Add and Configure CreateRouteButton
        var createRouteButton = UIButton.buttonWithType(UIButtonType.System) as UIButton
        createRouteButton.frame = CGRectMake(175,25,150,50)
        createRouteButton.setTitle("Create New Route", forState: UIControlState.Normal)
        createRouteButton.addTarget(self, action: "createRouteAction:", forControlEvents: UIControlEvents.TouchUpInside)
        
        //Add and Configure NavigationBar
        var navBar = UINavigationBar()
        navBar.frame = CGRectMake(self.view.bounds.minX,self.view.bounds.minY,self.view.bounds.width,70)
        navBar.backgroundColor = UIColor.grayColor()
        self.view.addSubview(navBar)
        navBar.addSubview(createRouteButton)
        var backButton = UIButton.buttonWithType(UIButtonType.System) as UIButton
        backButton.frame = CGRectMake(20,25,50,50)
        backButton.setTitle("Cancel", forState: UIControlState.Normal)
        backButton.addTarget(self, action: "backAction:", forControlEvents: UIControlEvents.TouchUpInside)
        navBar.addSubview(backButton)
        super.viewDidLoad()
    }
 
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return RouteModel.sharedInstance.allLocs.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:UITableViewCell? = tableView.dequeueReusableCellWithIdentifier("cell") as? UITableViewCell
        if !(cell==nil)
        {
            cell = UITableViewCell(style: UITableViewCellStyle.Subtitle,
                reuseIdentifier: "cell")
        }

        cell!.textLabel.text = RouteModel.sharedInstance.allLocs[indexPath.item].name
        cell!.detailTextLabel?.text =  RouteModel.sharedInstance.allLocs[indexPath.item].address
        return cell!
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
         self.selectedItems.append(RouteModel.sharedInstance.allLocs[indexPath.row])
    }
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        self.selectedItems.removeObject(RouteModel.sharedInstance.allLocs[indexPath.row])
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "DataToMap"){
            var svc = segue.destinationViewController as RouteMapView
            svc.passedData = selectedItems
        }
    }
    
    func backAction(sender:UIButton){
        self.performSegueWithIdentifier("RouteTableViewToRoute", sender: self)
    }
    
    func createRouteAction(sender:UIButton){
        if(self.selectedItems.count > 1){
        var inputAlert = UIAlertController(title:"Enter Route Name", message:"" , preferredStyle: .Alert)
        inputAlert.addAction(UIAlertAction(title: "Create", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
            self.textfieldInput = inputAlert.textFields![0] as UITextField
            if(Array(arrayLiteral: self.textfieldInput.text)[0] != ""){
            let route = Route(markers: self.selectedItems, name: self.textfieldInput.text)
            RouteModel.sharedInstance.allRoutes.append(route)
            var parseSave = PFObject(className: "Route")
            parseSave.setObject(self.textfieldInput.text, forKey: "routeName")
                var tempNames : [String] = []
                for m in self.selectedItems{
                    tempNames.append(m.name)
                }
            parseSave.setObject(tempNames, forKey: "listOfPoints")
            parseSave.save()
            self.performSegueWithIdentifier("DataToMap", sender: self)}
            else{
            var inputAlert = UIAlertController(title:"Please name your Route", message:"" , preferredStyle: .Alert)
            inputAlert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
                    self.selectedItems.removeAll(keepCapacity: false)
                    self.tableView.reloadData()
                }))
                self.presentViewController(inputAlert, animated: true, completion: nil)
            }
        }))
        inputAlert.addTextFieldWithConfigurationHandler({(textfield:UITextField!)
        in textfield.placeholder = "Enter Route Name"
        textfield.secureTextEntry = false
        })
        self.presentViewController(inputAlert, animated: true, completion:nil)
    }
        else{
        var inputAlert = UIAlertController(title:"Select at least 2 places", message:"" , preferredStyle: .Alert)
            inputAlert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
                self.selectedItems.removeAll(keepCapacity: false)
                self.tableView.reloadData()
            }))
            self.presentViewController(inputAlert, animated: true, completion: nil)
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