//
//  RouteModel.swift
//  TravelApp
//
//  Created by Eli on 06.12.14.
//  Copyright (c) 2014 Eli. All rights reserved.
//

import Foundation

class RouteModel{
    
    //let allLocations = Dictionary<String,Marker>()
    var allLocs : [Marker]!
    
    init(){
        let munich = Marker(longitude:11.581981, latitude: 48.135125, name: "Munich")
        let tokyo  = Marker(longitude: 139.691706, latitude: 35.689487, name: "Tokyo")
        let newYork  = Marker (longitude: -74.005941, latitude: 40.712784, name: "New York")
      //  var allLocations  = ["munich":munich,"tokyo":tokyo,"newYork":newYork]
        allLocs = [munich,tokyo,newYork]
    }
    
    /*
    func getAllLocations() -> Dictionary<String,Marker>{
    return allLocations
}
    */
}