//
//  MapViewVontroller.m
//  TravelApp
//
//  Created by Katrin Schauer on 15.12.14.
//  Copyright (c) 2014 Eli. All rights reserved.
//

#import "MapViewVontroller.h"
//#import <CoreLocation/CoreLocation.h>
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


//--- Marker für die aktuelle Position
GMSMarker *currentLocMarker;


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
    NSLog(@"initialised Location at: %@", self.locationManager.location);
    CLLocationCoordinate2D currentLocation = self.locationManager.location.coordinate;
    GMSCameraPosition *cam = [GMSCameraPosition cameraWithTarget:currentLocation zoom:16];
    mapView_ = [GMSMapView mapWithFrame:CGRectZero camera:cam];
    mapView_.camera = cam;
    //--- mapView settings
    mapView_.settings.zoomGestures = YES;
    mapView_.settings.compassButton = YES;
    mapView_.delegate = self;
    self.view = mapView_;
    NSLog(@"%@",mapView_.camera);
    
    
    
    //--- Marker für die aktuelle Position
    GMSGeocoder *geocoder = [GMSGeocoder geocoder];
    [geocoder reverseGeocodeCoordinate:currentLocation completionHandler:^(GMSReverseGeocodeResponse *response, NSError *error) {
        currentLocMarker = [GMSMarker markerWithPosition:currentLocation];
        currentLocMarker.title = @"Current Location";
        currentLocMarker.snippet = response.firstResult.addressLine1;
        currentLocMarker.icon = [UIImage imageNamed:@"current_location"];
        currentLocMarker.map = mapView_;
    }];
    
    
    //--- Abstand von unten und oben, um compassButton und myLocationButton sichtbar zu machen
    UIEdgeInsets mapInsets = UIEdgeInsetsMake(50.0, 0.0, 50.0, 0.0);
    mapView_.padding = mapInsets;
    
    
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

//--- updated regelmäßig die aktuelle Position
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    currentLocMarker.position = self.locationManager.location.coordinate;
}

//--- Fehlerbehandlung, wenn die aktuelle Position nicht bestimmt werden kann
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    UIAlertView *errorAlert = [[UIAlertView alloc]initWithTitle:@"Location Services is disabled." message:@"Place my Memories needs access to your location. Please turn on Location Services in your device settings." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [errorAlert show];
    NSLog(@"Error: %@",error.description);
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
    
    //--- Pinakothek
    GMSMarker *np = [[GMSMarker alloc] init];
    np.position = CLLocationCoordinate2DMake(48.14943, 11.57083);
    np.title = @"Neue Pinakothek";
    np.icon = [UIImage imageNamed:@"pin_culture"];
    np.map = mapView_;
    
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

- (void)mapView:(GMSMapView *)mapView didLongPressAtCoordinate:(CLLocationCoordinate2D)coordinate{
    
    //--- Hinzufügen eines Ortes !currentLocation
}

- (void)mapView:(GMSMapView *)mapView didTapInfoWindowOfMarker:(GMSMarker *)marker{
    
    //--- Tap auf Info Window -> Detail View
}


- (IBAction)touchDown:(id)sender {
    GMSCameraUpdate *cu = [GMSCameraUpdate setTarget:self.locationManager.location.coordinate zoom:16];
    [mapView_ animateWithCameraUpdate:cu];
    //    NSLog(@"touchedLocation %@", self.locationManager.location);
    //    NSLog(@"touchedLocation %@", mapView_.camera);
}
@end
