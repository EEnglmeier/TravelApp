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
@synthesize theArray, theTableView, arrayName, arrayAdress, arrayImage, clickedObjectID;
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
    //cell.imageView.file = [arrayImage objectAtIndex:indexPath.row];
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
    NSMutableArray *images = [[NSMutableArray alloc]init];
    
    PFQuery *event_query = [PFQuery queryWithClassName:@"Place"];
    [event_query orderByDescending:@"updatedAt"];
    [event_query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        if (!error) {
            for (PFObject *object in objects) {
                [places addObject:[object objectForKey:@"name"]];
                [address addObject:[object objectForKey:@"adress"]];
                [images addObject:[object objectForKey:@"imageFile"]];
            }
            arrayName = places;
            arrayAdress = address;
            arrayImage = images;
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

