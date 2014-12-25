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
        let munich = Marker(longitude:11.581981, latitude: 48.135125, name: "Munich",address:"Some Random Address")
        let tokyo  = Marker(longitude: 139.691706, latitude: 35.689487, name: "Tokyo",address:"Some Random Address")
        let newYork  = Marker (longitude: -74.005941, latitude: 40.712784, name: "New York",address:"Some Random Address")
        let lmu = Marker(longitude:  11.581076, latitude:48.151043 , name: "LMU", address: "Professor-Huber-Platz 2")
        let oet = Marker(longitude:11.593287, latitude:48.146113 , name: "Oettingenstrasse", address: "Oettingenstarsse xx")
        allLocs = [munich,tokyo,newYork,lmu,oet]
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