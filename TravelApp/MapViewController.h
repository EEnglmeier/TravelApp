//
//  MapViewController.h
//  TravelApp
//
//  Created by Katrin Schauer on 15.12.14.
//  Copyright (c) 2014 Eli. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>
#import <CoreLocation/CoreLocation.h>
#import "ShowPicture.h"
#import <Parse/Parse.h>
#import "DetailView.h"
#import "CustomInfoWindow.h"
#import "BuildDetailView.h"

@interface MapViewController : UIViewController <GMSMapViewDelegate, CLLocationManagerDelegate>

- (void) fetchPlaces;

@property (strong, nonatomic) IBOutlet GMSMapView *mapView_;


@end
