//
//  OrtHinzuefugen.h
//  TravelApp
//
//  Created by Zenib Awan on 20.12.14.
//  Copyright (c) 2014 Eli. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShowPicture.h"
#import <GoogleMaps/GoogleMaps.h>
#import "BuildDetailView.h"
#import "MapViewController.h"

@interface OrtHinzuefugen : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITabBarControllerDelegate>

//@property (strong, nonatomic) IBOutlet UIImageView *imageView;
//@property (nonatomic, strong) UIImage *takenImage;

//- (void)setPlaceLocation:(CLLocationCoordinate2D) longpress;
- (void)takePhoto;


@end
