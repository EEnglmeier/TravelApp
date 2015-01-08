//
//  BuildDetailView.m
//  TravelApp
//
//  Created by Zenib Awan on 15.12.14.
//  Copyright (c) 2014 Eli. All rights reserved.
//

#import "BuildDetailView.h"
#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>
#import <QuartzCore/QuartzCore.h>
#import <Parse/Parse.h>
#import <CoreLocation/CoreLocation.h>
#import "MBProgressHUD.h"
#import "MapViewController.h"

@interface BuildDetailView ()
@property (strong, nonatomic) CLLocationManager *locationManager;
@end

@implementation BuildDetailView {
    NSString *_address;
    double _returnLongitude;
    double _returnLatitude;
}
int buttonsize = 44;
float buttonBorderwidth = 1.2f;
int dist2Button = 60;
int buttonrowX1 = 45;
int buttonrowX2 = 15;
int buttonrowY1 = 340;
int buttonrowY2 = 425;
int labelY = 372;
int labelY1 = 455;
UITextField *textField, *otherAddressField;
NSString *locationCategory, *addressString;
UIButton *buttonHotel, *buttonFood, *buttonCafe, *buttonNightlife, *buttonShopping, *buttonActivity, *buttonIcons, *buttonCulture, *buttonOther;
NSString *locationCategory = @"";
float longitude, latitude;

CLLocationCoordinate2D longpressed;

//--- initialisieren des location manager
- (CLLocationManager *)locationManager{
    if (! _locationManager) _locationManager = [[CLLocationManager alloc] init];
    return _locationManager;
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    locationCategory = @"";
    
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    //*****Get User Location******
    //iOS8 required, um location services nutzen zu können
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    [self.locationManager requestWhenInUseAuthorization];
    [self.locationManager startMonitoringSignificantLocationChanges];
    [self.locationManager startUpdatingLocation];
    
    double latitude = _locationManager.location.coordinate.latitude;
    double longitude = _locationManager.location.coordinate.longitude;
    [self getGeoInformations:latitude :longitude];
    
    longpressed.latitude = -1;
    longpressed.longitude = -1;
    
    
    // NavBar
    UINavigationBar *navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 70)];
    navBar.backgroundColor = [UIColor grayColor];
    UINavigationItem *navItem = [[UINavigationItem alloc] init];
    navItem.title = @"Edit Mode";
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];
    navItem.leftBarButtonItem = cancelButton;
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(saveLocation)];
    navItem.rightBarButtonItem = saveButton;
    navBar.items = @[navItem];
    [[self view] addSubview: navBar];
    
    
    //ImageView
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(85, 90, 150, 150)];
    //self.imageView.image = _myImage;
    [imageView setImage:_myImage];
    [[self view] addSubview: imageView];
    
    
    //Textfield
    textField = [[UITextField alloc] initWithFrame: CGRectMake(0, 265, self.view.frame.size.width, 40)];
    textField.borderStyle = UITextBorderStyleRoundedRect;
    textField.font = [UIFont systemFontOfSize:15];
    textField.placeholder = @"Enter a name..";
    textField.autocorrectionType = UITextAutocorrectionTypeNo;
    textField.keyboardType = UIKeyboardAppearanceDefault;
    textField.returnKeyType = UIReturnKeyDone;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    textField.delegate = self;
    [[self view] addSubview: textField];
    
    
    
    //*****Buttons*****
    //Hotel
    buttonHotel = [UIButton buttonWithType:UIButtonTypeCustom];
    [buttonHotel setImage:[UIImage imageNamed:@"hotel.jpg"] forState:UIControlStateNormal];
    [buttonHotel setImageEdgeInsets:UIEdgeInsetsMake(6, 6, 6, 6)];
    [buttonHotel addTarget:self action:@selector(whichButtonIsClicked:) forControlEvents:UIControlEventTouchUpInside];
    buttonHotel.frame = CGRectMake(buttonrowX1, buttonrowY1, buttonsize, buttonsize);
    buttonHotel.clipsToBounds = YES;
    buttonHotel.layer.cornerRadius = buttonsize/2.0f;
    buttonHotel.layer.borderColor=[UIColor blackColor].CGColor;
    buttonHotel.layer.borderWidth=buttonBorderwidth;
    [[self view] addSubview:buttonHotel];
    
    UILabel  *labelhotel = [[UILabel alloc] initWithFrame:CGRectMake(52, labelY, 50, 50)];
    labelhotel.text = @"Hotel";
    labelhotel.font = [UIFont systemFontOfSize:12];
    [self.view addSubview:labelhotel];
    
    
    
    //Food
    buttonFood = [UIButton buttonWithType:UIButtonTypeCustom];
    [buttonFood setTitle:@"Your text" forState:UIControlStateNormal];
    [buttonFood setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [buttonFood setImage:[UIImage imageNamed:@"food.jpg"] forState:UIControlStateNormal];
    [buttonFood setImageEdgeInsets:UIEdgeInsetsMake(8, 8, 8, 8)];
    [buttonFood addTarget:self action:@selector(whichButtonIsClicked:) forControlEvents:UIControlEventTouchUpInside];
    buttonFood.frame = CGRectMake(buttonrowX1 + dist2Button, buttonrowY1, buttonsize, buttonsize);
    buttonFood.clipsToBounds = YES;
    buttonFood.layer.cornerRadius = buttonsize/2.0f;
    buttonFood.layer.borderColor=[UIColor blackColor].CGColor;
    buttonFood.layer.borderWidth=buttonBorderwidth;
    [[self view] addSubview:buttonFood];
    
    UILabel  *labelRestaurant = [[UILabel alloc] initWithFrame:CGRectMake(53+dist2Button, labelY, 50, 50)];
    labelRestaurant.text = @"Food";
    labelRestaurant.font = [UIFont systemFontOfSize:12];
    [self.view addSubview:labelRestaurant];
    
    
    //Cafe
    buttonCafe = [UIButton buttonWithType:UIButtonTypeCustom];
    [buttonCafe setImage:[UIImage imageNamed:@"cafe.jpg"] forState:UIControlStateNormal];
    [buttonCafe setImageEdgeInsets:UIEdgeInsetsMake(9, 9, 9, 9)];
    [buttonCafe addTarget:self action:@selector(whichButtonIsClicked:) forControlEvents:UIControlEventTouchUpInside];
    buttonCafe.frame = CGRectMake(buttonrowX1 + 2*dist2Button, buttonrowY1, buttonsize, buttonsize);
    buttonCafe.clipsToBounds = YES;
    buttonCafe.layer.cornerRadius = buttonsize/2.0f;
    buttonCafe.layer.borderColor=[UIColor blackColor].CGColor;
    buttonCafe.layer.borderWidth=buttonBorderwidth;
    [[self view] addSubview:buttonCafe];
    
    UILabel  *labelCafe = [[UILabel alloc] initWithFrame:CGRectMake(54+2*dist2Button, labelY, 50, 50)];
    labelCafe.text = @"Cafe";
    labelCafe.font = [UIFont systemFontOfSize:12];
    [self.view addSubview:labelCafe];
    
    
    //Nightlife
    buttonNightlife = [UIButton buttonWithType:UIButtonTypeCustom];
    [buttonNightlife setImage:[UIImage imageNamed:@"nightlife.jpg"] forState:UIControlStateNormal];
    [buttonNightlife setImageEdgeInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    [buttonNightlife addTarget:self action:@selector(whichButtonIsClicked:) forControlEvents:UIControlEventTouchUpInside];
    buttonNightlife.frame = CGRectMake(buttonrowX1 + 3*dist2Button, buttonrowY1, buttonsize, buttonsize);
    buttonNightlife.clipsToBounds = YES;
    buttonNightlife.layer.cornerRadius = buttonsize/2.0f;
    buttonNightlife.layer.borderColor=[UIColor blackColor].CGColor;
    buttonNightlife.layer.borderWidth=buttonBorderwidth;
    [[self view] addSubview:buttonNightlife];
    
    UILabel  *labelNightlife = [[UILabel alloc] initWithFrame:CGRectMake(45+3*dist2Button, labelY, 50, 50)];
    labelNightlife.text = @"Nightlife";
    labelNightlife.font = [UIFont systemFontOfSize:12];
    [self.view addSubview:labelNightlife];
    
    
    //Shopping
    buttonShopping = [UIButton buttonWithType:UIButtonTypeCustom];
    [buttonShopping setImage:[UIImage imageNamed:@"shopping.jpg"] forState:UIControlStateNormal];
    [buttonShopping setImageEdgeInsets:UIEdgeInsetsMake(8, 8, 8, 8)];
    [buttonShopping addTarget:self action:@selector(whichButtonIsClicked:) forControlEvents:UIControlEventTouchUpInside];
    buttonShopping.frame = CGRectMake(buttonrowX2, buttonrowY2, buttonsize, buttonsize);
    buttonShopping.clipsToBounds = YES;
    buttonShopping.layer.cornerRadius = buttonsize/2.0f;
    buttonShopping.layer.borderColor=[UIColor blackColor].CGColor;
    buttonShopping.layer.borderWidth=buttonBorderwidth;
    [self.view addSubview:buttonShopping];
    
    UILabel  *labelShopping = [[UILabel alloc] initWithFrame:CGRectMake(10, labelY1, 90, 50)];
    labelShopping.text = @"Shopping";
    labelShopping.font = [UIFont systemFontOfSize:12];
    [self.view addSubview:labelShopping];
    
    
    //Activity
    buttonActivity = [UIButton buttonWithType:UIButtonTypeCustom];
    [buttonActivity setImage:[UIImage imageNamed:@"avtivity.jpg"] forState:UIControlStateNormal];
    [buttonActivity setImageEdgeInsets:UIEdgeInsetsMake(7, 7, 7, 7)];
    [buttonActivity addTarget:self action:@selector(whichButtonIsClicked:) forControlEvents:UIControlEventTouchUpInside];
    buttonActivity.frame = CGRectMake(buttonrowX2 + dist2Button, buttonrowY2, buttonsize, buttonsize);
    buttonActivity.clipsToBounds = YES;
    buttonActivity.layer.cornerRadius = buttonsize/2.0f;
    buttonActivity.layer.borderColor=[UIColor blackColor].CGColor;
    buttonActivity.layer.borderWidth=buttonBorderwidth;
    [[self view] addSubview:buttonActivity];
    
    UILabel  *labelActivity = [[UILabel alloc] initWithFrame:CGRectMake(10+8+dist2Button, labelY1, 90, 50)];
    labelActivity.text = @"Activity";
    labelActivity.font = [UIFont systemFontOfSize:12];
    [self.view addSubview:labelActivity];
    
    
    //Icons
    buttonIcons = [UIButton buttonWithType:UIButtonTypeCustom];
    [buttonIcons setImage:[UIImage imageNamed:@"icons.jpg"] forState:UIControlStateNormal];
    [buttonIcons setImageEdgeInsets:UIEdgeInsetsMake(6, 6, 6, 6)];
    [buttonIcons addTarget:self action:@selector(whichButtonIsClicked:) forControlEvents:UIControlEventTouchUpInside];
    buttonIcons.frame = CGRectMake(buttonrowX2 + 2*dist2Button, buttonrowY2, buttonsize, buttonsize);
    buttonIcons.clipsToBounds = YES;
    buttonIcons.layer.cornerRadius = buttonsize/2.0f;
    buttonIcons.layer.borderColor=[UIColor blackColor].CGColor;
    buttonIcons.layer.borderWidth=buttonBorderwidth;
    [[self view] addSubview:buttonIcons];
    
    UILabel  *labelIcon = [[UILabel alloc] initWithFrame:CGRectMake(10+13+2*dist2Button, labelY1, 90, 50)];
    labelIcon.text = @"Icons";
    labelIcon.font = [UIFont systemFontOfSize:12];
    [self.view addSubview:labelIcon];
    
    
    //Culture
    buttonCulture = [UIButton buttonWithType:UIButtonTypeCustom];
    [buttonCulture setImage:[UIImage imageNamed:@"culture.jpg"] forState:UIControlStateNormal];
    [buttonCulture setImageEdgeInsets:UIEdgeInsetsMake(9, 8, 8, 8)];
    [buttonCulture addTarget:self action:@selector(whichButtonIsClicked:) forControlEvents:UIControlEventTouchUpInside];
    buttonCulture.frame = CGRectMake(buttonrowX2 + 3*dist2Button, buttonrowY2, buttonsize, buttonsize);
    buttonCulture.clipsToBounds = YES;
    buttonCulture.layer.cornerRadius = buttonsize/2.0f;
    buttonCulture.layer.borderColor=[UIColor blackColor].CGColor;
    buttonCulture.layer.borderWidth=buttonBorderwidth;
    [[self view] addSubview:buttonCulture];
    
    UILabel  *labelCulture = [[UILabel alloc] initWithFrame:CGRectMake(10+7+3*dist2Button, labelY1, 90, 50)];
    labelCulture.text = @"Culture";
    labelCulture.font = [UIFont systemFontOfSize:12];
    [self.view addSubview:labelCulture];
    
    
    //Other
    buttonOther = [UIButton buttonWithType:UIButtonTypeCustom];
    [buttonOther setImage:[UIImage imageNamed:@"other.jpg"] forState:UIControlStateNormal];
    [buttonOther setImageEdgeInsets:UIEdgeInsetsMake(9, 7, 7, 7)];
    [buttonOther addTarget:self action:@selector(whichButtonIsClicked:) forControlEvents:UIControlEventTouchUpInside];
    buttonOther.frame = CGRectMake(buttonrowX2 + 4*dist2Button, buttonrowY2, buttonsize, buttonsize);
    buttonOther.clipsToBounds = YES;
    buttonOther.layer.cornerRadius = buttonsize/2.0f;
    buttonOther.layer.borderColor=[UIColor blackColor].CGColor;
    buttonOther.layer.borderWidth=buttonBorderwidth;
    [[self view] addSubview:buttonOther];
    
    UILabel  *labelOther = [[UILabel alloc] initWithFrame:CGRectMake(10+13+4*dist2Button, labelY1, 90, 50)];
    labelOther.text = @"Other";
    labelOther.font = [UIFont systemFontOfSize:12];
    [self.view addSubview:labelOther];
    
    NSArray *buttonArray = [[NSArray alloc] initWithObjects:buttonHotel,buttonFood,buttonCafe,buttonNightlife,buttonShopping,buttonActivity,buttonIcons,buttonCulture,buttonOther,nil];
}

-(void)whichButtonIsClicked:(id)sender{
    if (sender == buttonHotel) {
        buttonHotel.layer.borderColor = [[UIColor colorWithRed:0/255.f green:186/255.f blue:130/255.f alpha:1.0f] CGColor];
        locationCategory = @"hotel";
        //buttonHotel.layer.borderColor=[UIColor blackColor].CGColor;
        buttonFood.layer.borderColor=[UIColor blackColor].CGColor;
        buttonCafe.layer.borderColor=[UIColor blackColor].CGColor;
        buttonNightlife.layer.borderColor=[UIColor blackColor].CGColor;
        buttonShopping.layer.borderColor=[UIColor blackColor].CGColor;
        buttonActivity.layer.borderColor=[UIColor blackColor].CGColor;
        buttonIcons.layer.borderColor=[UIColor blackColor].CGColor;
        buttonCulture.layer.borderColor=[UIColor blackColor].CGColor;
        buttonOther.layer.borderColor=[UIColor blackColor].CGColor;
    }
    
    if (sender == buttonFood) {
        buttonFood.layer.borderColor = [[UIColor colorWithRed:255/255.f green:0/255.f blue:0/255.f alpha:1.0f] CGColor];
        locationCategory = @"food";
        buttonHotel.layer.borderColor=[UIColor blackColor].CGColor;
        //buttonFood.layer.borderColor=[UIColor blackColor].CGColor;
        buttonCafe.layer.borderColor=[UIColor blackColor].CGColor;
        buttonNightlife.layer.borderColor=[UIColor blackColor].CGColor;
        buttonShopping.layer.borderColor=[UIColor blackColor].CGColor;
        buttonActivity.layer.borderColor=[UIColor blackColor].CGColor;
        buttonIcons.layer.borderColor=[UIColor blackColor].CGColor;
        buttonCulture.layer.borderColor=[UIColor blackColor].CGColor;
        buttonOther.layer.borderColor=[UIColor blackColor].CGColor;
    }
    
    if (sender == buttonCafe) {
        buttonCafe.layer.borderColor = [[UIColor colorWithRed:109/255.f green:95/255.f blue:213/255.f alpha:1.0f] CGColor];
        locationCategory = @"cafe";
        buttonHotel.layer.borderColor=[UIColor blackColor].CGColor;
        buttonFood.layer.borderColor=[UIColor blackColor].CGColor;
        //buttonCafe.layer.borderColor=[UIColor blackColor].CGColor;
        buttonNightlife.layer.borderColor=[UIColor blackColor].CGColor;
        buttonShopping.layer.borderColor=[UIColor blackColor].CGColor;
        buttonActivity.layer.borderColor=[UIColor blackColor].CGColor;
        buttonIcons.layer.borderColor=[UIColor blackColor].CGColor;
        buttonCulture.layer.borderColor=[UIColor blackColor].CGColor;
        buttonOther.layer.borderColor=[UIColor blackColor].CGColor;
    }
    
    if (sender == buttonNightlife) {
        buttonNightlife.layer.borderColor = [[UIColor colorWithRed:85/255.f green:85/255.f blue:85/255.f alpha:1.0f] CGColor];
        locationCategory = @"nightlife";
        buttonHotel.layer.borderColor=[UIColor blackColor].CGColor;
        buttonFood.layer.borderColor=[UIColor blackColor].CGColor;
        buttonCafe.layer.borderColor=[UIColor blackColor].CGColor;
        //buttonNightlife.layer.borderColor=[UIColor blackColor].CGColor;
        buttonShopping.layer.borderColor=[UIColor blackColor].CGColor;
        buttonActivity.layer.borderColor=[UIColor blackColor].CGColor;
        buttonIcons.layer.borderColor=[UIColor blackColor].CGColor;
        buttonCulture.layer.borderColor=[UIColor blackColor].CGColor;
        buttonOther.layer.borderColor=[UIColor blackColor].CGColor;
    }
    
    if (sender == buttonShopping) {
        buttonShopping.layer.borderColor = [[UIColor colorWithRed:95/255.f green:180/255.f blue:228/255.f alpha:1.0f] CGColor];
        locationCategory = @"shopping";
        buttonHotel.layer.borderColor=[UIColor blackColor].CGColor;
        buttonFood.layer.borderColor=[UIColor blackColor].CGColor;
        buttonCafe.layer.borderColor=[UIColor blackColor].CGColor;
        buttonNightlife.layer.borderColor=[UIColor blackColor].CGColor;
        //buttonShopping.layer.borderColor=[UIColor blackColor].CGColor;
        buttonActivity.layer.borderColor=[UIColor blackColor].CGColor;
        buttonIcons.layer.borderColor=[UIColor blackColor].CGColor;
        buttonCulture.layer.borderColor=[UIColor blackColor].CGColor;
        buttonOther.layer.borderColor=[UIColor blackColor].CGColor;
    }
    
    if (sender == buttonActivity) {
        buttonActivity.layer.borderColor = [[UIColor colorWithRed:236/255.f green:233/255.f blue:68/255.f alpha:1.0f] CGColor];
        locationCategory = @"activity";
        buttonHotel.layer.borderColor=[UIColor blackColor].CGColor;
        buttonFood.layer.borderColor=[UIColor blackColor].CGColor;
        buttonCafe.layer.borderColor=[UIColor blackColor].CGColor;
        buttonNightlife.layer.borderColor=[UIColor blackColor].CGColor;
        buttonShopping.layer.borderColor=[UIColor blackColor].CGColor;
        //buttonActivity.layer.borderColor=[UIColor blackColor].CGColor;
        buttonIcons.layer.borderColor=[UIColor blackColor].CGColor;
        buttonCulture.layer.borderColor=[UIColor blackColor].CGColor;
        buttonOther.layer.borderColor=[UIColor blackColor].CGColor;
    }
    
    if (sender == buttonIcons) {
        buttonIcons.layer.borderColor = [[UIColor colorWithRed:255/255.f green:130/255.f blue:0/255.f alpha:1.0f] CGColor];
        locationCategory = @"icons";
        buttonHotel.layer.borderColor=[UIColor blackColor].CGColor;
        buttonFood.layer.borderColor=[UIColor blackColor].CGColor;
        buttonCafe.layer.borderColor=[UIColor blackColor].CGColor;
        buttonNightlife.layer.borderColor=[UIColor blackColor].CGColor;
        buttonShopping.layer.borderColor=[UIColor blackColor].CGColor;
        buttonActivity.layer.borderColor=[UIColor blackColor].CGColor;
        //buttonIcons.layer.borderColor=[UIColor blackColor].CGColor;
        buttonCulture.layer.borderColor=[UIColor blackColor].CGColor;
        buttonOther.layer.borderColor=[UIColor blackColor].CGColor;
    }
    
    if (sender == buttonCulture) {
        buttonCulture.layer.borderColor = [[UIColor colorWithRed:244/255.f green:93/255.f blue:191/255.f alpha:1.0f] CGColor];
        locationCategory = @"culture";
        buttonHotel.layer.borderColor=[UIColor blackColor].CGColor;
        buttonFood.layer.borderColor=[UIColor blackColor].CGColor;
        buttonCafe.layer.borderColor=[UIColor blackColor].CGColor;
        buttonNightlife.layer.borderColor=[UIColor blackColor].CGColor;
        buttonShopping.layer.borderColor=[UIColor blackColor].CGColor;
        buttonActivity.layer.borderColor=[UIColor blackColor].CGColor;
        buttonIcons.layer.borderColor=[UIColor blackColor].CGColor;
        //buttonCulture.layer.borderColor=[UIColor blackColor].CGColor;
        buttonOther.layer.borderColor=[UIColor blackColor].CGColor;
    }
    
    if (sender == buttonOther) {
        buttonOther.layer.borderColor = [[UIColor colorWithRed:0/255.f green:0/255.f blue:0/255.f alpha:1.0f] CGColor];
        locationCategory = @"other";
        buttonHotel.layer.borderColor=[UIColor blackColor].CGColor;
        buttonFood.layer.borderColor=[UIColor blackColor].CGColor;
        buttonCafe.layer.borderColor=[UIColor blackColor].CGColor;
        buttonNightlife.layer.borderColor=[UIColor blackColor].CGColor;
        buttonShopping.layer.borderColor=[UIColor blackColor].CGColor;
        buttonActivity.layer.borderColor=[UIColor blackColor].CGColor;
        buttonIcons.layer.borderColor=[UIColor blackColor].CGColor;
        buttonCulture.layer.borderColor=[UIColor blackColor].CGColor;
        //buttonOther.layer.borderColor=[UIColor blackColor].CGColor;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

-(void)saveLocation{
    PFObject *object = [PFObject objectWithClassName:@"Place"];
    
    if ([locationCategory isEqualToString:@""]) {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Attention:"
                                                          message:@"Please select a category for your location!"
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        [message show];
    }
    
    else if ([textField.text isEqualToString:@""]) {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Attention:"
                                                          message:@"Please type in a name for your location!"
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        [message show];
    }
    
    
    else {
        
        NSData *imageData = UIImageJPEGRepresentation(_myImage, 0.8);
        NSString *filename = [NSString stringWithFormat:@"%@.png", textField.text];
        PFFile *imageFile = [PFFile fileWithName:filename data:imageData];
        [object setObject:imageFile forKey:@"imageFile"];
        
        // Show progress
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeIndeterminate;
        hud.labelText = @"Uploading";
        [hud show:YES];
        
        [object setObject:textField.text forKey:@"name"];
        PFGeoPoint *geoPoint;
        if(longpressed.longitude == -1 && longpressed.latitude == -1){
             geoPoint = [PFGeoPoint geoPointWithLatitude:_returnLatitude longitude:_returnLongitude];
        }else{
            geoPoint = [PFGeoPoint geoPointWithLatitude:longpressed.latitude longitude:longpressed.longitude];
        }
        [object setObject:locationCategory forKey:@"category"];
        [object setObject:_address forKey:@"adress"];
        [object setObject:geoPoint forKey:@"geoData"];
        
        [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            [hud hide:YES];
            
            if (!error) {
                // Show success message
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Upload Complete" message:@"Successfully saved the location" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                alert.tag = 1;
                [alert show];
                
                // Notify table view to reload the recipes from Parse cloud
                [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshTable" object:self];
            
                
                // Dismiss the controller
                //[self dismissViewControllerAnimated:YES completion:nil];
            } else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Upload Failure" message:[error localizedDescription] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
            }
        }];
    }
}

-(void)cancel{
    [self performSegueWithIdentifier:@"BuildDetailViewUnwindToList" sender:self];
}


//--- Fehlerbehandlung, wenn die aktuelle Position nicht bestimmt werden kann
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    UIAlertView *errorAlert = [[UIAlertView alloc]initWithTitle:@"Fehler" message:@"Die aktuelle Position konnte nicht bestimmt werden. \nMobile Daten oder WLAN aktivieren." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [errorAlert show];
    NSLog(@"Fehler: %@",error.description);
}

- (void)setPlaceLocation:(CLLocationCoordinate2D) _longpress{
    longpressed= _longpress;
}

- (void)getGeoInformations:(double)placeLatitude:(double)placeLongitude {
    _returnLatitude = placeLatitude;
    _returnLongitude = placeLongitude;
    //NSLog([NSString stringWithFormat:@"%f", _returnLatitude]);
    //NSLog([NSString stringWithFormat:@"%f", _returnLongitude]);
    __block NSString *adr1, *adr2;
    GMSGeocoder *geocoder = [GMSGeocoder geocoder];
    [geocoder reverseGeocodeCoordinate:CLLocationCoordinate2DMake(placeLatitude, placeLongitude) completionHandler:^(GMSReverseGeocodeResponse *response, NSError *error) {
        GMSReverseGeocodeResult *result = response.firstResult;
        adr1 = result.addressLine1;
        adr2 = result.addressLine2;
        [self loadGeoInformations:adr1:adr2];
    }];
}

- (void)loadGeoInformations:(NSString*)address1:(NSString*)address2{
    _address = [NSString stringWithFormat:@"%@\r%@", address1,address2];
    //NSLog(_address);
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Your location found:"
                                                      message:[NSString stringWithFormat:@"%@", _address]
                                                     delegate:nil
                                            cancelButtonTitle:@"OK"
                                            otherButtonTitles:nil];
    [message show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 1){
        if (buttonIndex == [alertView cancelButtonIndex]){
            [self performSegueWithIdentifier:@"BuildDetailViewToDetailView" sender:self];
        }
    }
}


@end
