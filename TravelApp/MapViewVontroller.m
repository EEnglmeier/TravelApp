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
    
    
    //--- pinArray: um Duplikate zu löschen (pin für currentLocation wird 3-4 mal angezeigt
    pinArray = [[NSMutableArray alloc] init];
    
    //--- delegate Methoden
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
 
    //iOS8 required, um location services nutzen zu können
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    [self.locationManager requestWhenInUseAuthorization];
    [self.locationManager startMonitoringSignificantLocationChanges];
    [self.locationManager startUpdatingLocation];
    
    //--- Variable für die aktuelle Position
    CLLocationCoordinate2D currentLocation = mapView_.myLocation.coordinate;
    
    //--- Cameraposition auf aktuelle Position
    GMSCameraPosition *cam = [GMSCameraPosition cameraWithTarget:currentLocation zoom:14];
    mapView_ = [GMSMapView mapWithFrame:CGRectZero camera:cam];
    mapView_.camera = cam;
  
    
    //--- Abstand von unten und oben, um compassButton und myLocationButton sichtbar zu machen
    UIEdgeInsets mapInsets = UIEdgeInsetsMake(50.0, 0.0, 50.0, 0.0);
    mapView_.padding = mapInsets;
    
    //--- mapView settings
    mapView_.settings.zoomGestures = YES;
    mapView_.settings.myLocationButton = YES;
    mapView_.settings.compassButton = YES;
    self.view = mapView_;
    mapView_.delegate = self;
    
    //--- zeigt gespeicherte Pins an
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
    GMSCameraUpdate *currentcam = [GMSCameraUpdate setTarget:currentLocation];
    [mapView_ animateWithCameraUpdate:currentcam];

    
    GMSMarker *currentPosition = [GMSMarker markerWithPosition:currentLocation];
    currentPosition.title = @"Aktueller Ort";
    currentPosition.icon = [UIImage imageNamed:@"current_location"];
    currentPosition.map = mapView_;
    [pinArray addObject:currentPosition];
    
    while (pinArray.count > 1) {
        GMSMarker *lastPos = (GMSMarker *)[pinArray objectAtIndex:0];
        lastPos.map = nil;
        [pinArray removeObject:lastPos];
    }
  
}

//--- Fehlerbehandlung, wenn die aktuelle Position nicht bestimmt werden kann
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    UIAlertView *errorAlert = [[UIAlertView alloc]initWithTitle:@"Fehler" message:@"Die aktuelle Position konnte nicht bestimmt werden. \nMobile Daten oder WLAN aktivieren." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [errorAlert show];
    NSLog(@"Fehler: %@",error.description);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (BOOL)didTapMyLocationButtonForMapView:(GMSMapView *)mapView{
//    return YES;
//}

//--- lädt gespeicherte Pins
- (void)pinsOnMap{
    
    //--- Gute Nacht Wurst
    GMSMarker *gnw = [[GMSMarker alloc] init];
    gnw.position = CLLocationCoordinate2DMake(48.13103, 11.57480);
    gnw.title = @"Gute Nacht Wurst";
    gnw.snippet = @"Klenzestr. 12";
    //gnw.appearAnimation = kGMSMarkerAnimationPop;
    gnw.icon = [UIImage imageNamed:@"pin_food"];
    gnw.map = mapView_;
    //[self.marker insertObject:gnw atIndex:0];
    
    //--- Pinakothek
    GMSMarker *np = [[GMSMarker alloc] init];
    np.position = CLLocationCoordinate2DMake(48.14943, 11.57083);
    np.title = @"Neue Pinakothek";
    np.icon = [UIImage imageNamed:@"pin_culture"];
    np.map = mapView_;
    //[self.marker insertObject:np atIndex:0];
}

//--- InfoWindow der Pins
- (UIView *)mapView:(GMSMapView *)mapView markerInfoWindow:(GMSMarker *)marker{
    
    
    
    UIView *infoWindow = [[UIView alloc] init];
    infoWindow.frame = CGRectMake(0, 0, 300, 70);
    infoWindow.backgroundColor = [UIColor whiteColor];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.frame = CGRectMake(64, 11, 175, 16);
    [infoWindow addSubview:titleLabel];
    titleLabel.text = marker.title;
    
    UILabel *snippetLabel = [[UILabel alloc] init];
    snippetLabel.frame = CGRectMake(64, 42, 175, 12);
    [infoWindow addSubview:snippetLabel];
    snippetLabel.text = marker.snippet;
    
    //--- Image tbd
    UIImageView *locationImage = [[UIImageView alloc] init];
    locationImage.frame = CGRectMake(14, 11, 20, 20);
    
    [infoWindow addSubview:locationImage];
    //--- address tbd
    
    return infoWindow;
}


////--- Navigation zum locationProfile, wenn das infoWindow getouched wurde
//- (void)mapView:(GMSMapView *)mapView didTapInfoWindowOfMarker:(GMSMarker *)marker{
//    
//    NSString *message = [NSString stringWithFormat:@"You tabbed the info window for the %@ marker", marker.title];
//    
//    //--- View des locationProfiles statt UIAlertView
//    UIAlertView *windowTapped = [[UIAlertView alloc]
//                                 initWithTitle:@"Info Window Tapped!"
//                                 message:message delegate:nil
//                                 cancelButtonTitle:@"Alright!"
//                                 otherButtonTitles:nil];
//    [windowTapped show];
//}


@end
