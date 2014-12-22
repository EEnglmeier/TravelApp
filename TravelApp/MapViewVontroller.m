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
@property (strong, nonatomic) NSString *firstAddressLine;
@property (strong, nonatomic) UIButton *currentLocationButton;
@property (strong, nonatomic) IBOutlet UIButton *locationButton;


- (IBAction)touchDown:(id)sender;

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
    
    
//    //--- pinArray: um Duplikate zu löschen (pin für currentLocation wird 3-4 mal angezeigt
//    pinArray = [[NSMutableArray alloc] init];
    
    //--- delegate Methoden
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
 
    //iOS8 required, um location services nutzen zu können
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    [self.locationManager requestWhenInUseAuthorization];
    [self.locationManager startMonitoringSignificantLocationChanges];
    [self.locationManager startUpdatingLocation];
    
    //--- einmaliges Laden der aktuellen Position
    NSLog(@"updatedLocation%@", self.locationManager.location);
    CLLocation *location = (CLLocation *) self.locationManager.location;
    CLLocationCoordinate2D currentLocation = [location coordinate];
    GMSCameraPosition *cam = [GMSCameraPosition cameraWithTarget:currentLocation zoom:16];
    mapView_ = [GMSMapView mapWithFrame:CGRectZero camera:cam];
    mapView_.camera = cam;
    
    //--- Marker für die aktuelle Position
    GMSGeocoder *geocoder = [GMSGeocoder geocoder];
    [geocoder reverseGeocodeCoordinate:currentLocation completionHandler:^(GMSReverseGeocodeResponse *response, NSError *error) {
        GMSMarker *currentPosition = [GMSMarker markerWithPosition:currentLocation];
        currentPosition.title = @"Current Location";
        currentPosition.snippet = response.firstResult.addressLine1;
        currentPosition.icon = [UIImage imageNamed:@"current_location"];
        currentPosition.map = mapView_;
    }];
    
    
    //--- Abstand von unten und oben, um compassButton und myLocationButton sichtbar zu machen
    UIEdgeInsets mapInsets = UIEdgeInsetsMake(50.0, 0.0, 50.0, 0.0);
    mapView_.padding = mapInsets;
    
    //--- mapView settings
    mapView_.settings.zoomGestures = YES;
    mapView_.settings.compassButton = YES;
    self.view = mapView_;
    mapView_.delegate = self;
    
    
    //--- Bild für locationButton
    UIImage *buttonImage = [UIImage imageNamed:@"locationButton"];
    
    //--- locationButton
    UIButton *locationButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [locationButton addTarget:self
               action:@selector(touchDown:)
     forControlEvents:UIControlEventTouchUpInside];
    [locationButton setImage:buttonImage forState:UIControlStateNormal];
    locationButton.frame = CGRectMake(250.0, 440.0, 60.0, 60.0);
    [mapView_ addSubview:locationButton];
    
    
    //--- zeigt gespeicherte Pins an
    [self pinsOnMap];
}

- (void)showCurrentLocation{
    mapView_.myLocationEnabled = YES;
    [self.locationManager startUpdatingLocation];
}

//- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
//    NSLog(@"updatedLocation%@", [locations lastObject]);
//    CLLocation *location =  (CLLocation *)[locations lastObject];
//    CLLocationCoordinate2D currentLocation = [location coordinate];
//    
//
//    GMSCameraUpdate *currentcam = [GMSCameraUpdate setTarget:currentLocation];
//    [mapView_ animateWithCameraUpdate:currentcam];
//
//    GMSMarker *currentPosition = [GMSMarker markerWithPosition:currentLocation];
//    currentPosition.title = @"Aktueller Ort";
//    //currentPosition.snippet = response.firstResult.locality;
//    currentPosition.icon = [UIImage imageNamed:@"current_location"];
//    currentPosition.map = mapView_;
//
//    [pinArray addObject:currentPosition];
//    
//    while (pinArray.count > 1) {
//        GMSMarker *lastPos = (GMSMarker *)[pinArray objectAtIndex:0];
//        lastPos.map = nil;
//        [pinArray removeObject:lastPos];
//    }
//
//}

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


//--- lädt gespeicherte Pins
- (void)pinsOnMap{
    
    //--- Gute Nacht Wurst
    GMSMarker *gnw = [[GMSMarker alloc] init];
    gnw.position = CLLocationCoordinate2DMake(48.13103, 11.57480);
    gnw.title = @"Gute Nacht Wurst";
    //gnw.snippet = @"Klenzestr. 12";
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
    infoWindow.frame = CGRectMake(0, 0, 250, 60);
    infoWindow.backgroundColor = [UIColor whiteColor];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.frame = CGRectMake(65, 11, 175, 16);
    [infoWindow addSubview:titleLabel];
    titleLabel.text = marker.title;
    
    UILabel *snippetLabel = [[UILabel alloc] init];
    snippetLabel.frame = CGRectMake(65, 32, 175, 14);
    [infoWindow addSubview:snippetLabel];
    snippetLabel.text = marker.snippet;
    snippetLabel.textColor = [UIColor grayColor];
    snippetLabel.font = [snippetLabel.font fontWithSize:12];

    
    //--- Image tbd
    UILabel *imageLabel = [[UILabel alloc] init];
    imageLabel.frame = CGRectMake(5, 5, 50.0, 50.0);
    [infoWindow addSubview:imageLabel];
    imageLabel.backgroundColor = [UIColor grayColor];
    

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


- (IBAction)touchDown:(id)sender {
    NSLog(@"updatedLocation%@", self.locationManager.location);
    CLLocation *location = (CLLocation *) self.locationManager.location;
    CLLocationCoordinate2D currentLocation = [location coordinate];
    GMSCameraUpdate *currentcam = [GMSCameraUpdate setTarget:currentLocation zoom:16];
    [mapView_ animateWithCameraUpdate:currentcam];

}
@end
