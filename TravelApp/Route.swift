//
//  Route.swift
//  TravelApp
//
//  Created by Eli on 13.12.14.
//  Copyright (c) 2014 Eli. All rights reserved.
//

import Foundation

@objc
class Route : Equatable{
    var orderderdMarkers : [Marker] = []
    var name : String
    
    init(markers : [Marker], name:String){
    self.orderderdMarkers = markers
    self.name = name
    }
    
    func containsMarker(marker : Marker) -> Bool{
        var result = false;
        for m in orderderdMarkers{
            if (m == marker){
                result = true
            }
        }
        return result
    }
}

func == (lhs:Route,rhs:Route) -> Bool{
    return lhs.name == rhs.name
}