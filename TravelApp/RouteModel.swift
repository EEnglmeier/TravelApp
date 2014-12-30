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
        let oet = Marker(longitude:11.593287, latitude:48.146113 , name: "Oettingenstrasse", address: "Oettingenstarsse 67")
        let fkirche = Marker(longitude: 11.573984, latitude: 48.138515, name: "Frauenkirche", address: "Frauenplatz12")
        let iTor = Marker(longitude: 11.581934, latitude: 48.135014, name: "Isartor", address: "Isartorplatz")
        allLocs = [munich,tokyo,newYork,lmu,oet,fkirche,iTor]
        let route = Route(markers: [munich,tokyo,newYork],name: "Route1")
        let route2 = Route(markers: [munich], name: "Route2")
        let route3 = Route(markers: allLocs, name: "Route3")
        let route4 = Route(markers: allLocs, name: "Route4")
        let route5 = Route(markers: [lmu,oet,fkirche,iTor], name: "LMU-OET-FKirche-Isartor")
        allRoutes = [route,route2,route3,route4,route5]
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