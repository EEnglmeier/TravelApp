//
//  PlacessTableView.m
//  TravelApp
//
//  Created by Zenib Awan on 09.01.15.
//  Copyright (c) 2015 Eli. All rights reserved.
//


#import "PlacesTableView.h"
#import <Parse/Parse.h>
#import "DetailView.h"


@implementation PlacesTableView
@synthesize theArray, theTableView, arrayName, arrayAdress, arrayCategory, clickedObjectID;
NSString *string;

- (void)viewDidLoad
{
    [super viewDidLoad];
    theTableView = [[UITableView alloc] initWithFrame:CGRectMake(10, 80, 300, 400) style:UITableViewStylePlain];
    theTableView.delegate = self;
    theTableView.dataSource = self;
    [theTableView reloadData];
    [self.view addSubview:theTableView];
    
    UINavigationBar *navBarLocation = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 70)];
    navBarLocation.backgroundColor = [UIColor grayColor];
    UINavigationItem *navItemLocation = [[UINavigationItem alloc] init];
    navItemLocation.title = @"Places";
    navBarLocation.items = @[navItemLocation];
    [[self view] addSubview: navBarLocation];
    
    [self gettingAllSearchResults];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [arrayName count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text = [arrayName objectAtIndex:indexPath.row];
    cell.detailTextLabel.text = [arrayAdress objectAtIndex:indexPath.row];
    if([[arrayCategory objectAtIndex:indexPath.row] isEqual: @"shopping"]){
        cell.imageView.image = [UIImage imageNamed:@"pin_shopping"];
        //cell.imageView.frame = CGRectMake(0, 0, 10, 10);
    }
    
    if([[arrayCategory objectAtIndex:indexPath.row] isEqual: @"food"]){
        cell.imageView.image = [UIImage imageNamed:@"pin_food"];
    }
    
    if([[arrayCategory objectAtIndex:indexPath.row] isEqual: @"nightlife"]){
        cell.imageView.image = [UIImage imageNamed:@"pin_nightlife"];
    }
    
    if([[arrayCategory objectAtIndex:indexPath.row] isEqual: @"cafe"]){
        cell.imageView.image = [UIImage imageNamed:@"pin_cafe"];
    }
    
    if([[arrayCategory objectAtIndex:indexPath.row] isEqual: @"activity"]){
        cell.imageView.image = [UIImage imageNamed:@"pin_activity"];
    }
    
    if([[arrayCategory objectAtIndex:indexPath.row] isEqual: @"culture"]){
        cell.imageView.image = [UIImage imageNamed:@"pin_culture"];
    }
    
    if([[arrayCategory objectAtIndex:indexPath.row] isEqual: @"hotel"]){
        cell.imageView.image = [UIImage imageNamed:@"pin_hotel"];
    }
    
    if([[arrayCategory objectAtIndex:indexPath.row] isEqual: @"icons"]){
        cell.imageView.image = [UIImage imageNamed:@"pin_icons"];
    }
    
    if([[arrayCategory objectAtIndex:indexPath.row] isEqual: @"other"]){
        cell.imageView.image = [UIImage imageNamed:@"pin_other"];
    }
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    string = [tableView cellForRowAtIndexPath:indexPath].textLabel.text;
    NSLog(@"%@",string);
    [self goToDetailView];
}


- (void) gettingAllSearchResults{
    NSMutableArray *places = [[NSMutableArray alloc]init];
    NSMutableArray *address = [[NSMutableArray alloc]init];
    NSMutableArray *categories = [[NSMutableArray alloc]init];
    
    PFQuery *event_query = [PFQuery queryWithClassName:@"Place"];
    [event_query orderByDescending:@"updatedAt"];
    [event_query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        if (!error) {
            for (PFObject *object in objects) {
                [places addObject:[object objectForKey:@"name"]];
                [address addObject:[object objectForKey:@"adress"]];
                [categories addObject:[object objectForKey:@"category"]];
            }
            arrayName = places;
            arrayAdress = address;
            arrayCategory = categories;
            [theTableView reloadData];
        }
    }];
}

-(void)goToDetailView{
    [self performSegueWithIdentifier:@"ListeToDetailView" sender:self];
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    PFQuery *query = [PFQuery queryWithClassName:@"Place"];
    [query whereKey:@"name" equalTo:string];
    
    PFObject *object = [query getFirstObject];
    clickedObjectID = object.objectId;
    
    if ([segue.identifier isEqualToString:@"ListeToDetailView"]){
        DetailView *editViewController = (DetailView *)segue.destinationViewController;
        editViewController.objectID = clickedObjectID;
        editViewController.segueTag = @"clickedObject";
    }
}


@end

