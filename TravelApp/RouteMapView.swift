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
    var session: NSURLSession {
        return NSURLSession.sharedSession()
    }
    var mapView = GMSMapView()
    var longPath = GMSMutablePath()
    var camera = GMSCameraPosition()
    
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
        var camera = GMSCameraPosition.cameraWithLatitude(passedData[0].latitude, longitude:passedData[0].longitude, zoom: 13.5)
        mapView = GMSMapView.mapWithFrame(mapFrame, camera:camera)
        mapView.mapType = kGMSTypeTerrain
        var path = GMSMutablePath()
        for var index = 0; index < passedData.count; ++index {
            var pin = GMSMarker()
            pin.position = CLLocationCoordinate2DMake(passedData[index].latitude, passedData[index].longitude)
            pin.snippet = passedData[index].name
            pin.appearAnimation = kGMSMarkerAnimationPop
            pin.map = mapView
        if(getTotalDist(passedData) < 50000.0){
            if(index < passedData.count-1){
            var loc1 : CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: passedData[index].latitude, longitude: passedData[index].longitude)
            var loc2 : CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: passedData[index+1].latitude, longitude: passedData[index+1].longitude)
            self.fetchDirectionsFrom(loc1, to: loc2){optionalRoute in
                if let encodedRoute = optionalRoute
                {
                    let path = GMSPath(fromEncodedPath: encodedRoute)
                    let line = GMSPolyline(path: path)
                    line.strokeWidth = 4.0
                    line.map = self.mapView
                }
            }
        }
    }
        else{
            longPath.addLatitude(passedData[index].latitude, longitude: passedData[index].longitude)
            }
}
        var polyline = GMSPolyline(path:longPath)
        polyline.strokeColor = UIColor.yellowColor()
        polyline.strokeWidth = 4.0
        polyline.map = self.mapView
        self.view.addSubview(mapView)
        self.view.addSubview(startNavButton)
        super.viewDidLoad()
    }
    func backAction(sender:UIButton){
        self.performSegueWithIdentifier("RouteMapViewToRoute", sender: self)
    }
    
    func navAction(sender:UIButton){
    }
    
    func fetchDirectionsFrom(from: CLLocationCoordinate2D, to: CLLocationCoordinate2D, completion: ((String?) -> Void)) -> ()
    {
        let rUrl1 = "http://maps.googleapis.com/maps/api/directions/json?origin="+String(format:"%f", from.latitude)+","+String(format:"%f", from.longitude)
        let rUrl2 = "&destination="+String(format:"%f", to.latitude)+","+String(format:"%f", to.longitude)+"&sensor=false&mode=walking"
        let urlString = rUrl1+rUrl2
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        session.dataTaskWithURL(NSURL(string: urlString)!) {data, response, error in
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            var encodedRoute: String?
            if let json = NSJSONSerialization.JSONObjectWithData(data, options:nil, error:nil) as? [String:AnyObject] {
                if let routes = json["routes"] as AnyObject? as? [AnyObject] {
                    if let route = routes.first as? [String : AnyObject] {
                        if let polyline = route["overview_polyline"] as AnyObject? as? [String : String] {
                            if let points = polyline["points"] as AnyObject? as? String {
                                encodedRoute = points
                                
                            }
                        }
                    }
                }
            }
            
            dispatch_async(dispatch_get_main_queue()) {
                completion(encodedRoute)
            }
            }.resume()
    }
    
    func getTotalDist(locs : [Marker]) -> Double{
        var dist : Double = 0.0
        for var index = 0; index < locs.count; ++index {
             if(index < locs.count-1){
              dist = dist + GMSGeometryDistance(CLLocationCoordinate2DMake(locs[index].latitude, locs[index].longitude), CLLocationCoordinate2DMake(locs[index+1].latitude, locs[index+1].longitude))
            }
        }
    return dist
    }
}
