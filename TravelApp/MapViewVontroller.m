//
//  MapViewVontroller.m
//  TravelApp
//
//  Created by Katrin Schauer on 15.12.14.
//  Copyright (c) 2014 Eli. All rights reserved.
//

#import "MapViewVontroller.h"
#import <CoreLocation/CoreLocation.h>
@import CoreLocation;



@interface MapViewController ()

@property (strong, nonatomic) NSMutableArray *marker;
@property (strong, nonatomic) NSMutableArray *places;
@property (strong, nonatomic) CLLocationManager *locationManager;


@end

@implementation MapViewController

//--- Map
GMSMapView *mapView_;

//--- initialisieren des location manager
- (CLLocationManager *)locationManager{
    if (! _locationManager) _locationManager = [[CLLocationManager alloc] init];
    return _locationManager;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
 

    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    [self.locationManager requestWhenInUseAuthorization];
    [self.locationManager startMonitoringSignificantLocationChanges];
    [self.locationManager startUpdatingLocation];
    
    
    CLLocationCoordinate2D currentLocation = mapView_.myLocation.coordinate;
    
//--- Cameraposition
    GMSCameraPosition *cam = [GMSCameraPosition cameraWithTarget:currentLocation zoom:14];
    mapView_ = [GMSMapView mapWithFrame:CGRectZero camera:cam];
    mapView_.camera = cam;
  
    
    //--- Abstand von unten, um Kartenelemente sichtbar zu machen
    UIEdgeInsets mapInsets = UIEdgeInsetsMake(0.0, 0.0, 50.0, 0.0);
    mapView_.padding = mapInsets;
    
    mapView_.settings.zoomGestures = YES;
    mapView_.settings.myLocationButton = YES;
    mapView_.settings.compassButton = YES;
    self.view = mapView_;
    mapView_.delegate = self;
    
    [self pinsOnMap];
}

- (void)showCurrentLocation{
    mapView_.myLocationEnabled = YES;
    [self.locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    NSLog(@"updatedLocation%@", [locations lastObject]);
    CLLocation *location =  (CLLocation *)[locations lastObject];
    CLLocationCoordinate2D currentLocation = [location coordinate];
        GMSCameraPosition *cam = [GMSCameraPosition cameraWithTarget:currentLocation zoom:5];
    mapView_ = [GMSMapView mapWithFrame:CGRectZero camera:cam];
    mapView_.camera = cam;
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    UIAlertView *errorAlert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"There was an error retrieving your location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [errorAlert show];
    NSLog(@"Error: %@",error.description);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)pinsOnMap{
    
    //--- Gute Nacht Wurst
    GMSMarker *gnw = [[GMSMarker alloc] init];
    gnw.position = CLLocationCoordinate2DMake(48.13103, 11.57480);
    gnw.title = @"Gute Nacht Wurst";
    gnw.icon = [UIImage imageNamed:@"pin_food"];
    gnw.map = mapView_;
    [self.marker insertObject:gnw atIndex:0];
    
    //--- Pinakothek
    GMSMarker *np = [[GMSMarker alloc] init];
    np.position = CLLocationCoordinate2DMake(48.14943, 11.57083);
    np.title = @"Neue Pinakothek";
    np.icon = [UIImage imageNamed:@"pin_culture"];
    np.map = mapView_;
    [self.marker insertObject:np atIndex:0];
}


@end
