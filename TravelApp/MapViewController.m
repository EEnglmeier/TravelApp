//
//  MapViewController.m
//  TravelApp
//
//  Created by Katrin Schauer on 15.12.14.
//  Copyright (c) 2014 Eli. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MapViewController.h"
//#import <CoreLocation/CoreLocation.h>
@import CoreLocation;



@interface MapViewController ()

//@property (strong, nonatomic) NSMutableArray *marker;
//@property (strong, nonatomic) NSMutableArray *places;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) UIButton *currentLocationButton;
@property (strong, nonatomic) IBOutlet UIButton *locationButton;
//@property (strong, nonatomic) NSMutableArray *allPlaces;

- (IBAction)touchDown:(id)sender;


@end

@implementation MapViewController

//--- Map
GMSMapView *mapView_;

CLLocationCoordinate2D longpressCoordinate;

CLLocationCoordinate2D currentLocation;

//--- Marker für die aktuelle Position
GMSMarker *currentLocMarker;
GMSMarker *pin;

//--- Variablen für Parse
NSString *name, *category, *geoName, *adress;
PFGeoPoint *geoPoint;

//--- initialisieren des location manager
- (CLLocationManager *)locationManager{
    if (! _locationManager) _locationManager = [[CLLocationManager alloc] init];
    return _locationManager;
}


//--- Marker für die aktuelle Position
- (void)loadCurrentLocationWithImage{
    GMSGeocoder *geocoder = [GMSGeocoder geocoder];
    [geocoder reverseGeocodeCoordinate:currentLocation completionHandler:^(GMSReverseGeocodeResponse *response, NSError *error) {
        currentLocMarker = [GMSMarker markerWithPosition:currentLocation];
        currentLocMarker.title = @"Current Location";
        currentLocMarker.snippet = response.firstResult.addressLine1;
        currentLocMarker.icon = [UIImage imageNamed:@"current_location"];
        currentLocMarker.map = mapView_;
    }];
}


//--- lädt alle bisher gespeicherten Orte in *allPlaces
- (void)fetchPlaces{
    
    [mapView_ clear];
    PFQuery *query = [PFQuery queryWithClassName:@"Place"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *allPlaces, NSError *error) {
        if (!error) {
            //--- erfolgreich %lu Places geladen
            NSLog(@"Successfully retrieved %lu places.", (unsigned long)allPlaces.count);
            [self pinsOnMap:allPlaces];
        } else {
            //--- Details zu Fehlern
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}


//--- erzeugt einen Pin für jeden gespeicherten Ort
- (void)pinsOnMap : (NSArray*) places{
    
    for (PFObject *place in places) {
        //NSLog(@"%@", place.objectId);
        pin = [[GMSMarker alloc] init];
        pin.userData = place;
        PFGeoPoint *geo = place[@"geoData"];
        CLLocationCoordinate2D loc = CLLocationCoordinate2DMake(geo.latitude, geo.longitude);
        
        if([place[@"category"] isEqual: @"shopping"]){
            pin.icon = [UIImage imageNamed:@"pin_shopping"];
        }
        
        if([place[@"category"] isEqual: @"food"]){
            pin.icon = [UIImage imageNamed:@"pin_food"];
        }
        
        if([place[@"category"] isEqual: @"nightlife"]){
            pin.icon = [UIImage imageNamed:@"pin_nightlife"];
        }
        
        if([place[@"category"] isEqual: @"cafe"]){
            pin.icon = [UIImage imageNamed:@"pin_cafe"];
        }
        
        if([place[@"category"] isEqual: @"activity"]){
            pin.icon = [UIImage imageNamed:@"pin_activity"];
        }
        
        if([place[@"category"] isEqual: @"culture"]){
            pin.icon = [UIImage imageNamed:@"pin_culture"];
        }
        
        if([place[@"category"] isEqual: @"hotel"]){
            pin.icon = [UIImage imageNamed:@"pin_hotel"];
        }
        
        if([place[@"category"] isEqual: @"icons"]){
            pin.icon = [UIImage imageNamed:@"pin_icons"];
        }
        
        if([place[@"category"] isEqual: @"other"]){
            pin.icon = [UIImage imageNamed:@"pin_other"];
        }
        
        pin.position = loc;
        pin.appearAnimation = kGMSMarkerAnimationPop;
        pin.map = mapView_;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
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
    currentLocation = self.locationManager.location.coordinate;
    GMSCameraPosition *cam = [GMSCameraPosition cameraWithTarget:currentLocation zoom:18];
    mapView_ = [GMSMapView mapWithFrame:CGRectZero camera:cam];
    mapView_.camera = cam;
    //--- mapView settings
    mapView_.settings.zoomGestures = YES;
    mapView_.settings.compassButton = YES;
    mapView_.settings.consumesGesturesInView = YES;
    [mapView_.settings setAllGesturesEnabled:YES];
    mapView_.delegate = self;
    self.view = mapView_;
    NSLog(@"%@",mapView_.camera);

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
    locationButton.frame = CGRectMake(10.0, 430.0, 60.0, 60.0);
    [mapView_ addSubview:locationButton];
    
    //--- lädt den aktuellen Ort inkl. Marker
    [self loadCurrentLocationWithImage];
    //--- lädt alle gespeicherten Orte inkl. Marker
    [self fetchPlaces];
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

//--- InfoWindow der Pins
- (UIView *)mapView:(GMSMapView *)mapView markerInfoWindow:(GMSMarker *)marker{

    if (marker == currentLocMarker) {
        CustomInfoWindow *infoWindowCurrentLoc = [[[NSBundle mainBundle] loadNibNamed:@"InfoWindowCurrentLoc" owner:self options:nil] objectAtIndex:0];
        infoWindowCurrentLoc.nameCurrentLoc.text = currentLocMarker.title;
        infoWindowCurrentLoc.addressCurrentLoc.text = currentLocMarker.snippet;
        return infoWindowCurrentLoc;
    } else {
        CustomInfoWindow *infoWindow = [[[NSBundle mainBundle] loadNibNamed:@"InfoWindow" owner:self options:nil] objectAtIndex:0];
        NSLog(@"%@",marker.userData);
        infoWindow.name.text = marker.userData[@"name"];
        infoWindow.address.text = marker.userData[@"adress"];
        infoWindow.photo.image = [[UIImage alloc] initWithData:[marker.userData[@"imageFile"] getData]];
        infoWindow.category.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@", marker.userData[@"category"]]];
        return infoWindow;
    }
}

//--- Save Location via Longpress
- (void)mapView:(GMSMapView *)mapView didLongPressAtCoordinate:(CLLocationCoordinate2D)coordinate{
    longpressCoordinate = coordinate;
    NSLog(@"You tapped at %f,%f", longpressCoordinate.latitude, longpressCoordinate.longitude);
    [self performSegueWithIdentifier:@"MapViewToBuildDetailView" sender:self];
}


- (void)mapView:(GMSMapView *)mapView didTapInfoWindowOfMarker:(GMSMarker *)marker{
    
    if (marker == currentLocMarker) return;
    //--- Tap auf Info Window -> Unwind Segue zu DetailView
    [self performSegueWithIdentifier:@"MapViewToDetailView" sender:marker.userData];
    //NSLog(@"YES");
}

- (IBAction)unwindToMapView:(UIStoryboardSegue *)unwindSegue{
    NSLog(@"%@",unwindSegue.sourceViewController);
    [self fetchPlaces];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"MapViewToBuildDetailView"]){
        BuildDetailView *bdv = segue.destinationViewController;
        NSString *lat = [[NSString alloc] initWithFormat:@"%g", longpressCoordinate.latitude];
        NSString *lon = [[NSString alloc] initWithFormat:@"%g", longpressCoordinate.longitude];
        NSLog(@"Latitude is: %@", lat);
        NSLog(@"Longitude is: %@", lon);
        //NSLog(@"%@",longpressCoordinate);
        [bdv setPlaceLocation:longpressCoordinate];
    }
    else if([segue.identifier isEqualToString:@"MapViewToDetailView"]){
        DetailView *dv = segue.destinationViewController;
        PFObject *place = sender;
        dv.objectID = place.objectId;
        dv.segueTag = @"clickedPin";
    }
}


- (IBAction)touchDown:(id)sender {
    GMSCameraUpdate *cu = [GMSCameraUpdate setTarget:self.locationManager.location.coordinate zoom:16];
    [mapView_ animateWithCameraUpdate:cu];
    //    NSLog(@"touchedLocation %@", self.locationManager.location);
    //    NSLog(@"touchedLocation %@", mapView_.camera);
}


@end