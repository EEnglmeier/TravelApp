//
//  Marker.swift
//  TravelApp
//
//  Created by Eli on 06.12.14.
//  Copyright (c) 2014 Eli. All rights reserved.
//

import Foundation

struct Marker : Equatable{
    
    var longitude,latitude : Double
    var name:String
    //var categorie : String!
    //var picture : String!
    //var address : String!
    
    init(longitude:Double,latitude:Double,name:String){
        self.longitude = longitude
        self.latitude = latitude
        self.name = name
    }
    
    func getLongitude()->Double{
        return longitude;
    }
    func getLatitude()->Double{
        return latitude;
    }
    func getName()->String{
        return name;
    }
}

func == (lhs:Marker,rhs:Marker) -> Bool{
    return lhs.getName() == rhs.getName() && lhs.getLatitude() == rhs.getLatitude() && lhs.getLongitude() == rhs.getLongitude()
}