//
//  Marker.swift
//  TravelApp
//
//  Created by Eli on 06.12.14.
//  Copyright (c) 2014 Eli. All rights reserved.
//

import Foundation

struct Marker : Equatable{
    
   private var longitude,latitude : Double
   private var name:String
    
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
    if(lhs.getName() == rhs.getName() && lhs.getLatitude() == rhs.getLatitude() && lhs.getLongitude() == rhs.getLongitude()){return true}
    else {return false}
}