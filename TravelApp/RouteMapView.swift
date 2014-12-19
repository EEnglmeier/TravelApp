//
//  RouteMapView.swift
//  TravelApp
//
//  Created by Eli on 06.12.14.
//  Copyright (c) 2014 Eli. All rights reserved.
//

import UIKit

class RouteMapView : UIViewController{
    
    var passedData : [Marker]!
    var routeName : String!
    var routeModel = RouteModel()


    override func viewDidLoad() {
        
        var viewFrame = self.view.frame
        var mapFrame = CGRectMake(viewFrame.origin.x, 70, viewFrame.size.width, viewFrame.size.height)
        var navBar = UINavigationBar()
        navBar.frame = CGRectMake(self.view.bounds.minX,self.view.bounds.minY,self.view.bounds.width,70)
        navBar.backgroundColor = UIColor.grayColor()
        self.view.addSubview(navBar)
        var backButton = UIButton.buttonWithType(UIButtonType.System) as UIButton
        backButton.frame = CGRectMake(20,20,150,50)
        backButton.setTitle("Back to Overview", forState: UIControlState.Normal)
        backButton.addTarget(self, action: "backAction:", forControlEvents: UIControlEvents.TouchUpInside)
        navBar.addSubview(backButton)

        
        var camera = GMSCameraPosition.cameraWithLatitude(passedData[0].getLatitude(), longitude:passedData[0].getLongitude(), zoom:1)
        var mapView = GMSMapView.mapWithFrame(mapFrame, camera:camera)
        mapView.mapType = kGMSTypeTerrain
        var path = GMSMutablePath()
        for marker in passedData{
            path.addLatitude(marker.getLatitude(), longitude: marker.getLongitude())
            var pin = GMSMarker()
            pin.position = CLLocationCoordinate2DMake(marker.getLatitude(), marker.getLongitude())
            pin.snippet = marker.getName()
            pin.appearAnimation = kGMSMarkerAnimationPop
            pin.map = mapView
        }
        var polyline = GMSPolyline(path:path)
        polyline.strokeColor = UIColor.yellowColor()
        polyline.strokeWidth = 4.0
        polyline.map = mapView
        self.view.addSubview(mapView)
        super.viewDidLoad()
    }
    func backAction(sender:UIButton){
        self.performSegueWithIdentifier("RouteMapViewToRoute", sender: self)
    }
}