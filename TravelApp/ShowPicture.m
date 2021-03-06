//
//  OrtHinzuefugen.m
//  TravelApp
//
//  Created by Zenib Awan on 15.12.14.
//  Copyright (c) 2014 Eli. All rights reserved.
//

#import "ShowPicture.h"
#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <QuartzCore/QuartzCore.h>


@implementation ShowPicture
int buttonsize1_ = 60;
int aPlaceLabelY_ = 455;
float buttonBorderwidth1_ = 1.7f;
NSString *name, *category, *geoName, *adress;

-(void)viewDidLoad{
    
    PFQuery *query = [PFQuery queryWithClassName:@"Place"];
    [query orderByDescending:@"updatedAt"];
    PFObject *aPlace = [query getFirstObject];
    name = [aPlace objectForKey:@"name"];
    category = [aPlace objectForKey:@"category"];
    //geoName = [aPlace objectForKey:@"geoName"];
    adress = [aPlace objectForKey:@"adress"];
    
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    [super viewDidLoad];
    
    UINavigationBar *navBarLocation = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 70)];
    navBarLocation.backgroundColor = [UIColor grayColor];
    UINavigationItem *navItemLocation = [[UINavigationItem alloc] init];
    navItemLocation.title = name;
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(done)];
    navItemLocation.rightBarButtonItem = doneButton;
    navBarLocation.items = @[navItemLocation];
    [[self view] addSubview: navBarLocation];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(85, 90, 150, 150)];
    [imageView setImage:[UIImage imageNamed: @"test.jpg"]];
    [[self view] addSubview: imageView];
    
    UILabel *locationLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 265, self.view.frame.size.width, 40)];
    locationLabel.text = [@"     " stringByAppendingString: name];
    locationLabel.font = [UIFont systemFontOfSize:15];
    locationLabel.layer.borderColor = [UIColor grayColor].CGColor;
    locationLabel.layer.borderWidth = 1.0;
    [self.view addSubview:locationLabel];
    
    /*UILabel *locGeoName = [[UILabel alloc] initWithFrame:CGRectMake(20, 320, 280, 40)];
     locGeoName.text = geoName;
     locGeoName.font = [UIFont systemFontOfSize:13];
     [self.view addSubview:locGeoName];*/
    
    UILabel *locAdress = [[UILabel alloc] initWithFrame:CGRectMake(20, 325, 280, 40)];
    locAdress.text = adress;
    locAdress.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:locAdress];
    
    
    UIButton *locationButton = [UIButton buttonWithType:UIButtonTypeCustom];
    locationButton.frame = CGRectMake(125, 405, buttonsize1_, buttonsize1_);
    locationButton.clipsToBounds = YES;
    locationButton.layer.cornerRadius = buttonsize1_/2.0f;
    locationButton.layer.borderWidth=buttonBorderwidth1_;
    
    if([category isEqual: @"shopping"]){
        
        [locationButton setImage:[UIImage imageNamed:@"shopping.jpg"] forState:UIControlStateNormal];
        locationButton.layer.borderColor = [[UIColor colorWithRed:95/255.f green:180/255.f blue:228/255.f alpha:1.0f] CGColor];
        [locationButton setImageEdgeInsets:UIEdgeInsetsMake(12, 12, 12, 12)];
        [[self view] addSubview:locationButton];
        UILabel  *locationLabel = [[UILabel alloc] initWithFrame:CGRectMake(125, aPlaceLabelY_, 90, 50)];
        locationLabel.text = @"Shopping";
        locationLabel.font = [UIFont systemFontOfSize:14];
        [self.view addSubview:locationLabel];
    }
    
    if([category isEqual: @"activity"]){
        
        [locationButton setImage:[UIImage imageNamed:@"activity.jpg"] forState:UIControlStateNormal];
        locationButton.layer.borderColor = [[UIColor colorWithRed:236/255.f green:233/255.f blue:68/255.f alpha:1.0f] CGColor];
        [locationButton setImageEdgeInsets:UIEdgeInsetsMake(11, 11, 11, 11)];
        [[self view] addSubview:locationButton];
        UILabel  *locationLabel = [[UILabel alloc] initWithFrame:CGRectMake(132, aPlaceLabelY_, 90, 50)];
        locationLabel.text = @"Activity";
        locationLabel.font = [UIFont systemFontOfSize:14];
        [self.view addSubview:locationLabel];
    }
    
    if([category isEqual: @"cafe"]){
        
        [locationButton setImage:[UIImage imageNamed:@"cafe.jpg"] forState:UIControlStateNormal];
        locationButton.layer.borderColor = [[UIColor colorWithRed:109/255.f green:95/255.f blue:213/255.f alpha:1.0f] CGColor];
        [locationButton setImageEdgeInsets:UIEdgeInsetsMake(12, 13, 13, 12)];
        [[self view] addSubview:locationButton];
        UILabel  *locationLabel = [[UILabel alloc] initWithFrame:CGRectMake(139, aPlaceLabelY_, 90, 50)];
        locationLabel.text = @"Cafe";
        locationLabel.font = [UIFont systemFontOfSize:14];
        [self.view addSubview:locationLabel];
    }
    
    
    if([category isEqual: @"culture"]){
        
        [locationButton setImage:[UIImage imageNamed:@"culture.jpg"] forState:UIControlStateNormal];
        locationButton.layer.borderColor = [[UIColor colorWithRed:244/255.f green:93/255.f blue:191/255.f alpha:1.0f] CGColor];
        [locationButton setImageEdgeInsets:UIEdgeInsetsMake(13, 12, 12, 12)];
        [[self view] addSubview:locationButton];
        UILabel  *locationLabel = [[UILabel alloc] initWithFrame:CGRectMake(132, aPlaceLabelY_, 90, 50)];
        locationLabel.text = @"Culture";
        locationLabel.font = [UIFont systemFontOfSize:14];
        [self.view addSubview:locationLabel];
    }
    
    if([category isEqual: @"food"]){
        
        [locationButton setImage:[UIImage imageNamed:@"food"] forState:UIControlStateNormal];
        locationButton.layer.borderColor = [[UIColor colorWithRed:255/255.f green:0/255.f blue:0/255.f alpha:1.0f] CGColor];
        [locationButton setImageEdgeInsets:UIEdgeInsetsMake(12, 12, 12, 12)];
        [[self view] addSubview:locationButton];
        UILabel  *locationLabel = [[UILabel alloc] initWithFrame:CGRectMake(140, aPlaceLabelY_, 90, 50)];
        locationLabel.text = @"Food";
        locationLabel.font = [UIFont systemFontOfSize:14];
        [self.view addSubview:locationLabel];
    }
    
    if([category isEqual: @"hotel"]){
        
        [locationButton setImage:[UIImage imageNamed:@"hotel"] forState:UIControlStateNormal];
        locationButton.layer.borderColor = [[UIColor colorWithRed:0/255.f green:186/255.f blue:130/255.f alpha:1.0f] CGColor];
        [locationButton setImageEdgeInsets:UIEdgeInsetsMake(9, 9, 9, 9)];
        [[self view] addSubview:locationButton];
        UILabel  *locationLabel = [[UILabel alloc] initWithFrame:CGRectMake(138, aPlaceLabelY_, 90, 50)];
        locationLabel.text = @"Hotel";
        locationLabel.font = [UIFont systemFontOfSize:14];
        [self.view addSubview:locationLabel];
    }
    
    if([category isEqual: @"icons"]){
        
        [locationButton setImage:[UIImage imageNamed:@"icons"] forState:UIControlStateNormal];
        locationButton.layer.borderColor = [[UIColor colorWithRed:255/255.f green:130/255.f blue:0/255.f alpha:1.0f] CGColor];
        [locationButton setImageEdgeInsets:UIEdgeInsetsMake(11, 12, 11, 11)];
        [[self view] addSubview:locationButton];
        UILabel  *locationLabel = [[UILabel alloc] initWithFrame:CGRectMake(137, aPlaceLabelY_, 90, 50)];
        locationLabel.text = @"Icons";
        locationLabel.font = [UIFont systemFontOfSize:14];
        [self.view addSubview:locationLabel];
    }
    
    if([category isEqual: @"nightlife"]){
        
        [locationButton setImage:[UIImage imageNamed:@"nightlife"] forState:UIControlStateNormal];
        locationButton.layer.borderColor = [[UIColor colorWithRed:85/255.f green:85/255.f blue:85/255.f alpha:1.0f] CGColor];
        [locationButton setImageEdgeInsets:UIEdgeInsetsMake(13, 13, 13, 13)];
        [[self view] addSubview:locationButton];
        UILabel  *locationLabel = [[UILabel alloc] initWithFrame:CGRectMake(130, aPlaceLabelY_, 90, 50)];
        locationLabel.text = @"Nightlife";
        locationLabel.font = [UIFont systemFontOfSize:14];
        [self.view addSubview:locationLabel];
    }
    
    if([category isEqual: @"other"]){
        
        [locationButton setImage:[UIImage imageNamed:@"other"] forState:UIControlStateNormal];
        locationButton.layer.borderColor = [[UIColor colorWithRed:0/255.f green:0/255.f blue:0/255.f alpha:1.0f] CGColor];
        [locationButton setImageEdgeInsets:UIEdgeInsetsMake(11, 9, 9, 9)];
        [[self view] addSubview:locationButton];
        UILabel  *locationLabel = [[UILabel alloc] initWithFrame:CGRectMake(137, aPlaceLabelY_, 90, 50)];
        locationLabel.text = @"Other";
        locationLabel.font = [UIFont systemFontOfSize:14];
        [self.view addSubview:locationLabel];
    }
}

-(void)done{
    [self performSegueWithIdentifier:@"DetailViewUnwindToList" sender:self];
}

@end
