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
    var navUrl : NSURL = NSURL(string: "https://www.google.de/maps/?saddr=Google+Inc,+8th+Avenue,+New+York,+NY&daddr=John+F.+Kennedy+International+Airport,+Van+Wyck+Expressway,+Jamaica,+New+York&directionsmode=transit")!
    
    var testUrl : NSURL = NSURL(string: "https://www.google.de/maps/?saddr=51.84,-8.30&daddr=51.84,-8.30&directionsmode=transit")!

    override func viewDidLoad() {
        var viewFrame = self.view.frame
        var mapFrame = CGRectMake(viewFrame.origin.x, 70, viewFrame.size.width, viewFrame.size.height)
        var navBar = UINavigationBar()
        navBar.frame = CGRectMake(self.view.bounds.minX,self.view.bounds.minY,self.view.bounds.width,70)
        navBar.backgroundColor = UIColor.grayColor()
        self.view.addSubview(navBar)
        var backButton = UIButton.buttonWithType(UIButtonType.System) as UIButton
        backButton.frame = CGRectMake(0,20,150,50)
        backButton.setTitle("Back to Overview", forState: UIControlState.Normal)
        backButton.addTarget(self, action: "backAction:", forControlEvents: UIControlEvents.TouchUpInside)
        var startNavButton = UIButton.buttonWithType(UIButtonType.System) as UIButton
        startNavButton.frame = CGRectMake(100,500,150,50)
        startNavButton.setTitle("Start Navigation", forState: UIControlState.Normal)
        startNavButton.addTarget(self, action: "navAction:", forControlEvents: UIControlEvents.TouchUpInside)
        navBar.addSubview(backButton)

        
        var camera = GMSCameraPosition.cameraWithLatitude(passedData[0].latitude, longitude:passedData[0].longitude, zoom:1)
        var mapView = GMSMapView.mapWithFrame(mapFrame, camera:camera)
        mapView.mapType = kGMSTypeTerrain
        var path = GMSMutablePath()
        for marker in passedData{
            path.addLatitude(marker.latitude, longitude: marker.longitude)
            var pin = GMSMarker()
            pin.position = CLLocationCoordinate2DMake(marker.latitude, marker.longitude)
            pin.snippet = marker.name
            pin.appearAnimation = kGMSMarkerAnimationPop
            pin.map = mapView
        }
        var polyline = GMSPolyline(path:path)
        polyline.strokeColor = UIColor.yellowColor()
        polyline.strokeWidth = 4.0
        polyline.map = mapView
        self.view.addSubview(mapView)
        self.view.addSubview(startNavButton)
        super.viewDidLoad()
    }
    func backAction(sender:UIButton){
        self.performSegueWithIdentifier("RouteMapViewToRoute", sender: self)
    }
    func navAction(sender:UIButton){
        let app = UIApplication.sharedApplication()
        if(app.canOpenURL(navUrl)){
           app.openURL(NSURL(string: makeNavString(passedData[0].longitude, lat_1: passedData[0].latitude, long_2: passedData[1].longitude, lat_2: passedData[1].latitude))!)
        }
    }
    
    func makeNavString(long_1:Double,lat_1:Double,long_2:Double,lat_2:Double) -> String{
        var longitude_1 : String = String(format:"%f", long_1)
        var latitude_1 : String = String(format:"%f", lat_1)
        var longitude_2 : String = String(format:"%f", long_2)
        var latitude_2 : String = String(format:"%f", lat_2)
        var res = "https://www.google.de/maps/?saddr="+latitude_1+","+longitude_1+"&daddr="+latitude_2+","+longitude_2+"&directionsmode=transit"
        return res
    }
}
