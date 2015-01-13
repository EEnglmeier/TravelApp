//
//  RouteModel.swift
//  TravelApp
//
//  Created by Eli on 06.12.14.
//  Copyright (c) 2014 Eli. All rights reserved.
//

import Foundation
import Parse
@objc
class RouteModel{
    
    var allLocs : [Marker] = []
    var allRoutes : [Route] = []
    var pic : [UIImage] = []
    
    init(){
        getAllPlacesFromParse()
        getAllRoutesFromParse()
    }
    
    func getAllPlacesFromParse(){
        var query : PFQuery = PFQuery(className: "Place")
        query.orderByDescending("name")
        var objs = query.findObjects()
        if(objs != nil && !objs.isEmpty){
        for o in objs{
        var geoObj = o.objectForKey("geoData") as PFGeoPoint
        var objName = o.objectForKey("name") as String
        var objAddress = o.objectForKey("adress") as String
        var objCat = o.objectForKey("category") as String
       // pic.append(o.objectForKey("imageFile") as UIImage))
        allLocs.append(Marker(longitude: geoObj.longitude, latitude: geoObj.latitude, name: objName, address: objAddress, category: objCat, images: pic))
            }
        }
    }
    
    func getAllRoutesFromParse(){
        for m in allLocs{
            println(m.name)
        }
        var query : PFQuery = PFQuery(className: "Route")
        query.orderByDescending("routeName")
        var objs = query.findObjects()
        for o in objs{
            var routeName = o.objectForKey("routeName") as String
            var routePlaces = o.objectForKey("listOfPoints") as [String]
            var tempMarkers : [Marker] = []
            for nm in routePlaces{
                tempMarkers.append(self.getMarkerByName(nm))
            }
        allRoutes.append(Route(markers: tempMarkers, name: routeName))
        }
    }
    
    func updateAllData(){
        allLocs = []
        allRoutes = []
        getAllPlacesFromParse()
        getAllRoutesFromParse()
    }
    
    func getMarkerPosByName(mn : String) -> Int{
        var result = 0
        for var index = 0; index < allLocs.count; ++index{
            if(allLocs[index].name == mn){
                result = index
            }
        }
        return result
    }
    
    func getMarkerByName(nm : String) -> Marker{
        var result : Marker!
        for var index = 0; index < allLocs.count; ++index{
            if(allLocs[index].name == nm){
                result = allLocs[index]
            }
        }
        return result
    }
    
    func removeMarkerByName(nm : String){
        var rmMarker = self.getMarkerByName(nm)
        allLocs.removeObject(rmMarker)
    }
    
    func removeAssociatedRoutes(markerName:String){
        var rmMarker = self.getMarkerByName(markerName)
        for var index = 0; index < allRoutes.count; ++index{
            if(allRoutes[index].containsMarker(rmMarker)){
                var parseDelete = PFQuery(className: "Route")
                parseDelete.whereKey("routeName", containsString: allRoutes[index].name)
                var obj = parseDelete.findObjects()
                obj[0].deleteEventually()
                allRoutes.removeAtIndex(index)
            }
        }
        self.updateAllData()
    }
    
    func updateMarker(longitude:Double,latitude:Double,name:String,address:String,category:String,images:[UIImage]){
    var pos = getMarkerPosByName(name)
    allLocs[pos].name = name
    allLocs[pos].longitude = longitude
    allLocs[pos].latitude = latitude
    allLocs[pos].address = address
    allLocs[pos].category = category
    allLocs[pos].pictures = images
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
