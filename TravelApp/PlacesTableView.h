//
//  PlacessTableView.h
//  TravelApp
//
//  Created by Zenib Awan on 09.01.15.
//  Copyright (c) 2015 Eli. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

#import <UIKit/UIKit.h>

@interface PlacesTableView : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) NSArray *theArray;
@property (nonatomic, retain) UITableView *theTableView;
@property (nonatomic, strong) NSArray *arrayName;
@property (nonatomic, strong) NSArray *arrayAdress;
@property (nonatomic, strong) NSArray *arrayImage;
@property (nonatomic, strong) NSString *clickedObjectID;

@end
