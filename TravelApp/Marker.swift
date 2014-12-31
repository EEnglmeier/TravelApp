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
    var address : String
    
    init(longitude:Double,latitude:Double,name:String,address:String){
        self.longitude = longitude
        self.latitude = latitude
        self.name = name
        self.address = address
    }
    
}

func == (lhs:Marker,rhs:Marker) -> Bool{
    return lhs.name == rhs.name && lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude && lhs.address == rhs.address}