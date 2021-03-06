//
//  DetailViewAfterBuild.m
//  TravelApp
//
//  Created by Katrin Schauer on 11.01.15.
//  Copyright (c) 2015 Eli. All rights reserved.
//

#import "DetailViewAfterBuild.h"

//@interface DetailViewAfterBuild ()
//
//
//@end

@implementation DetailViewAfterBuild
@synthesize objectID, segueTag, name, category, adress, imageFile;
int buttonsize2 = 60;
int aPlaceLabelY2 = 445;
float buttonBorderwidth2 = 1.7f;
NSString  *geoName;
UIImageView *imageView;
PFFile *imageFile;
NSString *objectIDFromMapView;
NSString *objectIDFromTableView;


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSLog(@"detail");
    [self whichObjectToShowAfterBuild];
    
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    [super viewDidLoad];
    
    UINavigationBar *navBarLocation = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 70)];
    navBarLocation.backgroundColor = [UIColor grayColor];
    UINavigationItem *navItemLocation = [[UINavigationItem alloc] init];
    navItemLocation.title = name;
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(doneAfterBuild)];
    navItemLocation.rightBarButtonItem = doneButton;
    navBarLocation.items = @[navItemLocation];
    [[self view] addSubview: navBarLocation];
    
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(85, 90, 150, 150)];
    [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (!data) {
            return NSLog(@"%@", error);
        }
        
        // Do something with the image
        imageView.image = [UIImage imageWithData:data];
    }];
    [[self view] addSubview: imageView];
    
    UILabel *locationLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 265, self.view.frame.size.width, 40)];
    locationLabel.text = [@"     " stringByAppendingString: name];
    locationLabel.font = [UIFont systemFontOfSize:15];
    locationLabel.layer.borderColor = [UIColor grayColor].CGColor;
    locationLabel.layer.borderWidth = 1.0;
    [self.view addSubview:locationLabel];
    
    UILabel *locAdress = [[UILabel alloc] initWithFrame:CGRectMake(20, 325, 280, 40)];
    locAdress.text = adress;
    locAdress.lineBreakMode = UILineBreakModeWordWrap;
    locAdress.numberOfLines = 2;
    locAdress.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:locAdress];
    
    
    UIButton *locationButton = [UIButton buttonWithType:UIButtonTypeCustom];
    locationButton.frame = CGRectMake(125, 395, buttonsize2, buttonsize2);
    locationButton.clipsToBounds = YES;
    locationButton.layer.cornerRadius = buttonsize2/2.0f;
    locationButton.layer.borderWidth=buttonBorderwidth2;
    
    if([category isEqual: @"shopping"]){
        
        [locationButton setImage:[UIImage imageNamed:@"shopping.jpg"] forState:UIControlStateNormal];
        locationButton.layer.borderColor = [[UIColor colorWithRed:95/255.f green:180/255.f blue:228/255.f alpha:1.0f] CGColor];
        [locationButton setImageEdgeInsets:UIEdgeInsetsMake(12, 12, 12, 12)];
        [[self view] addSubview:locationButton];
        UILabel  *locationLabel = [[UILabel alloc] initWithFrame:CGRectMake(125, aPlaceLabelY2, 90, 50)];
        locationLabel.text = @"Shopping";
        locationLabel.font = [UIFont systemFontOfSize:14];
        [self.view addSubview:locationLabel];
    }
    
    if([category isEqual: @"activity"]){
        
        [locationButton setImage:[UIImage imageNamed:@"activity.jpg"] forState:UIControlStateNormal];
        locationButton.layer.borderColor = [[UIColor colorWithRed:236/255.f green:233/255.f blue:68/255.f alpha:1.0f] CGColor];
        [locationButton setImageEdgeInsets:UIEdgeInsetsMake(11, 11, 11, 11)];
        [[self view] addSubview:locationButton];
        UILabel  *locationLabel = [[UILabel alloc] initWithFrame:CGRectMake(132, aPlaceLabelY2, 90, 50)];
        locationLabel.text = @"Activity";
        locationLabel.font = [UIFont systemFontOfSize:14];
        [self.view addSubview:locationLabel];
    }
    
    if([category isEqual: @"cafe"]){
        
        [locationButton setImage:[UIImage imageNamed:@"cafe.jpg"] forState:UIControlStateNormal];
        locationButton.layer.borderColor = [[UIColor colorWithRed:109/255.f green:95/255.f blue:213/255.f alpha:1.0f] CGColor];
        [locationButton setImageEdgeInsets:UIEdgeInsetsMake(12, 13, 13, 12)];
        [[self view] addSubview:locationButton];
        UILabel  *locationLabel = [[UILabel alloc] initWithFrame:CGRectMake(139, aPlaceLabelY2, 90, 50)];
        locationLabel.text = @"Cafe";
        locationLabel.font = [UIFont systemFontOfSize:14];
        [self.view addSubview:locationLabel];
    }
    
    
    if([category isEqual: @"culture"]){
        
        [locationButton setImage:[UIImage imageNamed:@"culture.jpg"] forState:UIControlStateNormal];
        locationButton.layer.borderColor = [[UIColor colorWithRed:244/255.f green:93/255.f blue:191/255.f alpha:1.0f] CGColor];
        [locationButton setImageEdgeInsets:UIEdgeInsetsMake(13, 12, 12, 12)];
        [[self view] addSubview:locationButton];
        UILabel  *locationLabel = [[UILabel alloc] initWithFrame:CGRectMake(132, aPlaceLabelY2, 90, 50)];
        locationLabel.text = @"Culture";
        locationLabel.font = [UIFont systemFontOfSize:14];
        [self.view addSubview:locationLabel];
    }
    
    if([category isEqual: @"food"]){
        
        [locationButton setImage:[UIImage imageNamed:@"food"] forState:UIControlStateNormal];
        locationButton.layer.borderColor = [[UIColor colorWithRed:255/255.f green:0/255.f blue:0/255.f alpha:1.0f] CGColor];
        [locationButton setImageEdgeInsets:UIEdgeInsetsMake(12, 12, 12, 12)];
        [[self view] addSubview:locationButton];
        UILabel  *locationLabel = [[UILabel alloc] initWithFrame:CGRectMake(140, aPlaceLabelY2, 90, 50)];
        locationLabel.text = @"Food";
        locationLabel.font = [UIFont systemFontOfSize:14];
        [self.view addSubview:locationLabel];
    }
    
    if([category isEqual: @"hotel"]){
        
        [locationButton setImage:[UIImage imageNamed:@"hotel"] forState:UIControlStateNormal];
        locationButton.layer.borderColor = [[UIColor colorWithRed:0/255.f green:186/255.f blue:130/255.f alpha:1.0f] CGColor];
        [locationButton setImageEdgeInsets:UIEdgeInsetsMake(9, 9, 9, 9)];
        [[self view] addSubview:locationButton];
        UILabel  *locationLabel = [[UILabel alloc] initWithFrame:CGRectMake(138, aPlaceLabelY2, 90, 50)];
        locationLabel.text = @"Hotel";
        locationLabel.font = [UIFont systemFontOfSize:14];
        [self.view addSubview:locationLabel];
    }
    
    if([category isEqual: @"icons"]){
        
        [locationButton setImage:[UIImage imageNamed:@"icons"] forState:UIControlStateNormal];
        locationButton.layer.borderColor = [[UIColor colorWithRed:255/255.f green:130/255.f blue:0/255.f alpha:1.0f] CGColor];
        [locationButton setImageEdgeInsets:UIEdgeInsetsMake(11, 12, 11, 11)];
        [[self view] addSubview:locationButton];
        UILabel  *locationLabel = [[UILabel alloc] initWithFrame:CGRectMake(137, aPlaceLabelY2, 90, 50)];
        locationLabel.text = @"Icons";
        locationLabel.font = [UIFont systemFontOfSize:14];
        [self.view addSubview:locationLabel];
    }
    
    if([category isEqual: @"nightlife"]){
        
        [locationButton setImage:[UIImage imageNamed:@"nightlife"] forState:UIControlStateNormal];
        locationButton.layer.borderColor = [[UIColor colorWithRed:85/255.f green:85/255.f blue:85/255.f alpha:1.0f] CGColor];
        [locationButton setImageEdgeInsets:UIEdgeInsetsMake(13, 13, 13, 13)];
        [[self view] addSubview:locationButton];
        UILabel  *locationLabel = [[UILabel alloc] initWithFrame:CGRectMake(130, aPlaceLabelY2, 90, 50)];
        locationLabel.text = @"Nightlife";
        locationLabel.font = [UIFont systemFontOfSize:14];
        [self.view addSubview:locationLabel];
    }
    
    if([category isEqual: @"other"]){
        
        [locationButton setImage:[UIImage imageNamed:@"other"] forState:UIControlStateNormal];
        locationButton.layer.borderColor = [[UIColor colorWithRed:0/255.f green:0/255.f blue:0/255.f alpha:1.0f] CGColor];
        [locationButton setImageEdgeInsets:UIEdgeInsetsMake(11, 9, 9, 9)];
        [[self view] addSubview:locationButton];
        UILabel  *locationLabel = [[UILabel alloc] initWithFrame:CGRectMake(137, aPlaceLabelY2, 90, 50)];
        locationLabel.text = @"Other";
        locationLabel.font = [UIFont systemFontOfSize:14];
        [self.view addSubview:locationLabel];
    }
}

-(void)doneAfterBuild{
    NSLog(@"Done Button is clicked");
    if ([segueTag isEqualToString:@"buildDetailView"]) {
        NSLog(@"COMING FROM BDV");
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"DetailViewToMapView"]) {
        NSLog(@"segue detail view to map view prepared");
        [self dismissViewControllerAnimated:YES completion:nil];
        [segue.destinationViewController fetchPlaces];
        [segue.destinationViewController loadCurrentLocationWithImage];
    }
}

-(void) whichObjectToShowAfterBuild{
    
    if ([segueTag isEqualToString:@"buildDetailView"]) {
        NSLog(@"tableView");
        PFQuery *query = [PFQuery queryWithClassName:@"Place"];
        [query whereKey:@"objectId" equalTo:self.objectID];
        PFObject *object = [query getFirstObject];
        name = [object objectForKey:@"name"];
        category = [object objectForKey:@"category"];
        adress = [object objectForKey:@"adress"];
        imageFile = object[@"imageFile"];
    }

    
}
@end