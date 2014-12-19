//
//  Route.swift
//  TravelApp
//
//  Created by Eli on 13.12.14.
//  Copyright (c) 2014 Eli. All rights reserved.
//

import Foundation

struct Route{
    var orderderdMarkers : [Marker] = []
    var name : String
    
    init(markers : [Marker], name:String){
    self.orderderdMarkers = markers
    self.name = name
    }
}
