//
//  BuildDetailView.h
//  TravelApp
//
//  Created by Zenib Awan on 17.12.14.
//  Copyright (c) 2014 Eli. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>
#import "MapViewController.h"

@interface BuildDetailView: UIViewController <UITextFieldDelegate,UINavigationControllerDelegate,UITabBarControllerDelegate,CLLocationManagerDelegate,UIAlertViewDelegate>{
    NSString *_textfieldString;
    
}
@property (nonatomic, retain) UIImageView *imageView;
@property (nonatomic, strong) UIImage *myImage;
@property float longitude, latitude;
@property (nonatomic, strong) NSString *geoPlace;
@property (nonatomic) CLLocationCoordinate2D *longpressCoordinate;


- (void)setPlaceLocation_:(CLLocationCoordinate2D) __longpress;

@end
