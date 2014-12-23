//
//  RouteModel.swift
//  TravelApp
//
//  Created by Eli on 06.12.14.
//  Copyright (c) 2014 Eli. All rights reserved.
//

import Foundation

class RouteModel{
    
    var allLocs : [Marker] = []
    var allRoutes : [Route] = []
    
    init(){
        let munich = Marker(longitude:11.581981, latitude: 48.135125, name: "Munich")
        let tokyo  = Marker(longitude: 139.691706, latitude: 35.689487, name: "Tokyo")
        let newYork  = Marker (longitude: -74.005941, latitude: 40.712784, name: "New York")
        allLocs = [munich,tokyo,newYork]
        let route = Route(markers: allLocs, name: "Route1")
        allRoutes = [route]
    }
    struct Static{
        static var onceToken : dispatch_once_t = 0
        static var instance : RouteModel? = nil
        
    }
    class var sharedInstance : RouteModel{
        dispatch_once(&Static.onceToken){
            Static.instance = RouteModel()
        }
        return Static.instance!
    }
}