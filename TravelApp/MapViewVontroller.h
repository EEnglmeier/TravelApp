//
//  MapViewVontroller.h
//  TravelApp
//
//  Created by Katrin Schauer on 15.12.14.
//  Copyright (c) 2014 Eli. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>
#import <CoreLocation/CoreLocation.h>

@interface MapViewController : UIViewController <GMSMapViewDelegate, CLLocationManagerDelegate>
{
    NSMutableArray *pinArray;
}
@property (strong, nonatomic) IBOutlet GMSMapView *mapView_;


@end
