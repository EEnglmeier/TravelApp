//
//  DetailView.h
//  TravelApp
//
//  Created by Zenib Awan on 23.12.14.
//  Copyright (c) 2014 Eli. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface DetailView : UIViewController
@property (nonatomic, strong) NSString *objectID;
@property (nonatomic, strong) NSString *segueTag;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *category;
@property (nonatomic, strong) NSString *adress;
@property (nonatomic, strong) PFFile *imageFile;

@end
