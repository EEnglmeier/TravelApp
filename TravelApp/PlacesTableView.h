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
@property (nonatomic, strong) NSMutableArray *arrayName;
@property (nonatomic, strong) NSMutableArray *arrayAdress;
@property (nonatomic, strong) NSMutableArray *arrayCategory;
@property (nonatomic, strong) NSMutableArray *arrayImages;
@property (nonatomic, strong) NSString *clickedObjectID;


@end
