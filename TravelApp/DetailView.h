//
//  DetailView.h
//  TravelApp
//
//  Created by Zenib Awan on 23.12.14.
//  Copyright (c) 2014 Eli. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "MapViewController.h"


@interface DetailView : UIViewController
@property (nonatomic, strong) NSString *objectID;
@property (nonatomic, strong) NSString *segueTag;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *placeIdString;
@property (nonatomic, strong) NSString *category;
@property (nonatomic, strong) NSString *adress;
@property (nonatomic, strong) PFFile *imageFile;
@property (nonatomic, strong) NSMutableArray *allImages;
@property (nonatomic, strong) NSMutableArray *getImage;

@property (nonatomic, strong) NSArray *test;

- (void)backToMap;

@end
