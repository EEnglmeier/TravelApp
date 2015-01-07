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
@property (strong, nonatomic) NSMutableArray *allPlaces;

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

////--- lädt alle bisher gespeicherten Orte in *places
//- (void)fetchPlaces{
//
//    NSMutableArray *allPlaces = [NSMutableArray array];
//
//    PFQuery *query = [PFQuery queryWithClassName:@"Place"];
//    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
//        if (!error) {
//            //--- erfolgreich %lu Places geladen
//            NSLog(@"Successfully retrieved %lu places.", (unsigned long)objects.count);
//            //--- Speichert die gefundenen Orte in einem Array *allPlaces
//            for (PFObject *object in objects) {
//                NSLog(@"%@", object.objectId);
//                GMSMarker *pin = [[GMSMarker alloc] init];
//                pin.position = [query whereKey:@"geoData" containedIn:objects];
//                pin.title = [query whereKey:@"name" containedIn:objects];
//
//
//            }
//        } else {
//            //--- Details zu Fehlern
//            NSLog(@"Error: %@ %@", error, [error userInfo]);
//        }
//    }];
//
//
//}

//- (GMSMarker *)createMarkerForPlace:(PFObject *)Place onMap:(GMSMapView *)mapView
//{
//    PFObject *allPlaces = [
//    GMSMarker *marker = [[GMSMarker alloc] init];
//    marker.position = [aObject ]
//    marker.position = Place.location;
//    marker.title = Place.name;
//    marker.snippet = Place.address;
//    marker.map = mapView;
//
//    return marker;
//}

//--- lädt gespeicherte Pins
- (void)pinsOnMap{
    
    
    
    //--- Gute Nacht Wurst
    GMSMarker *gnw = [[GMSMarker alloc] init];
    gnw.position = CLLocationCoordinate2DMake(48.13103, 11.57480);
    gnw.title = @"Gute Nacht Wurst";
    gnw.icon = [UIImage imageNamed:@"pin_food"];
    gnw.appearAnimation = kGMSMarkerAnimationPop;
    gnw.map = mapView_;
    
    //--- Pinakothek
    GMSMarker *np = [[GMSMarker alloc] init];
    np.position = CLLocationCoordinate2DMake(48.14943, 11.57083);
    np.title = @"Neue Pinakothek";
    np.icon = [UIImage imageNamed:@"pin_culture"];
    np.map = mapView_;
    
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
        //        currentLocMarker.title = @"Current Location";
        //        currentLocMarker.snippet = response.firstResult.addressLine1;
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
    locationButton.frame = CGRectMake(10.0, 430.0, 60.0, 60.0);
    [mapView_ addSubview:locationButton];
    
    //--- lädt alle gespeicherten Orte
    //[self fetchPlaces];
    
    //--- zeigt gespeicherte Pins an
    [self pinsOnMap];
    
    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(mapLongPress:)];
    longPressGesture.minimumPressDuration = 1.5;
    [mapView_ addGestureRecognizer:longPressGesture];
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
    
    CustomInfoWindow *infoWindow = [[[NSBundle mainBundle] loadNibNamed:@"InfoWindow" owner:self options:nil] objectAtIndex:0];
    //    //PFQuery *query = [PFQuery queryWithClassName:@"Place"];
    //    //    infoWindow.nameLocation.text = ...
    //    //    infoWindow.address.text = ...
    infoWindow.name.text = @"bla";
    infoWindow.address.text = @"blabla";
    infoWindow.photo.image = [UIImage imageNamed:@"Beispiel"];
    infoWindow.category.image = [UIImage imageNamed:@"food"];
    
    
    //    UIView *infoWindow = [[UIView alloc] init];
    //    infoWindow.frame = CGRectMake(0, 0, 250, 60);
    //    infoWindow.backgroundColor = [UIColor whiteColor];
    //
    //    UILabel *titleLabel = [[UILabel alloc] init];
    //    titleLabel.frame = CGRectMake(65, 11, 175, 16);
    //    [infoWindow addSubview:titleLabel];
    //    titleLabel.text = marker.title;
    //
    //    UILabel *snippetLabel = [[UILabel alloc] init];
    //    snippetLabel.frame = CGRectMake(65, 32, 175, 14);
    //    [infoWindow addSubview:snippetLabel];
    //    snippetLabel.text = marker.snippet;
    //    snippetLabel.textColor = [UIColor grayColor];
    //    snippetLabel.font = [snippetLabel.font fontWithSize:12];
    //
    //
    //    //--- Image tbd
    //    UILabel *imageLabel = [[UILabel alloc] init];
    //    imageLabel.frame = CGRectMake(5, 5, 50.0, 50.0);
    //    [infoWindow addSubview:imageLabel];
    //    imageLabel.backgroundColor = [UIColor grayColor];
    
    
    //    UILabel *arrow = [[UILabel alloc] initWithFrame:CGRectMake(100, 20, 20, 20)];
    //    UIImageView *arrowImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Arrow"]];
    //    arrowImage.frame = CGRectMake(100, 20, 20, 20);
    //    [arrow addSubview:arrowImage];
    
    
    //--- address tbd
    
    return infoWindow;
}

- (void)mapLongPress:(UILongPressGestureRecognizer *)gestureRecognizer{
    if(gestureRecognizer.state == UIGestureRecognizerStateBegan){
        
        
        CGPoint touchLocation = [gestureRecognizer locationInView:mapView_];
        CLLocationCoordinate2D coordinate;
        touchLocation.x = coordinate.latitude;
        touchLocation.y = coordinate.latitude;
        
        NSLog(@"You tapped at %f,%f", coordinate.latitude, coordinate.longitude);
        NSLog(@"Longpress");
    }
}

- (void)mapView_:(GMSMapView *)mapView didLongPressAtCoordinate:(CLLocationCoordinate2D)coordinate{
    
    float pinLatitude = coordinate.latitude;
    float pinLongitude = coordinate.longitude;
    
    NSLog(@"You tapped at %f,%f", coordinate.latitude, coordinate.longitude);
    
    //--- Segue zu BuildDetailView
    GMSMarker *newPin = [[GMSMarker alloc] init];
    newPin.position = coordinate;
    newPin.icon = [UIImage imageNamed:@"newPin"];
    newPin.appearAnimation = kGMSMarkerAnimationPop;
    newPin.map = mapView_;
    mapView_.selectedMarker = newPin;
    
    
    [self performSegueWithIdentifier:@"MapViewToBuildDetailView" sender:self];
    
}


- (void)mapView:(GMSMapView *)mapView didTapInfoWindowOfMarker:(GMSMarker *)marker{
    
    //--- Tap auf Info Window -> Unwind Segue zu DetailView
    [self performSegueWithIdentifier:@"MapViewToDetailView" sender:self];
    //NSLog(@"YES");
}


- (IBAction)touchDown:(id)sender {
    GMSCameraUpdate *cu = [GMSCameraUpdate setTarget:self.locationManager.location.coordinate zoom:16];
    [mapView_ animateWithCameraUpdate:cu];
    //    NSLog(@"touchedLocation %@", self.locationManager.location);
    //    NSLog(@"touchedLocation %@", mapView_.camera);
}
@end