//
//  AppDelegate.swift
//  TravelApp
//
//  Created by Eli on 06.12.14.
//  Copyright (c) 2014 Eli. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    // 1
    let googleMapsApiKey = "AIzaSyBqC8A03Q4a3qr_4bVzzRZKN0skrgguTDg"
    
    func application(application: UIApplication!, didFinishLaunchingWithOptions launchOptions: NSDictionary!) -> Bool {
        // 2
        GMSServices.provideAPIKey(googleMapsApiKey)
        return true
    }
}

