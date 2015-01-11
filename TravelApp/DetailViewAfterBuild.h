//
//  DetailViewAfterBuild.h
//  TravelApp
//
//  Created by Katrin Schauer on 11.01.15.
//  Copyright (c) 2015 Eli. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "MapViewController.h"

@interface DetailViewAfterBuild : UIViewController

@property (nonatomic, strong) NSString *objectID;
@property (nonatomic, strong) NSString *segueTag;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *category;
@property (nonatomic, strong) NSString *adress;
@property (nonatomic, strong) PFFile *imageFile;
@end
