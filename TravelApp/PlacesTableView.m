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
#import "TravelApp-Swift.h"

///*********************************************************************************
//
// variables
//
//**********************************************************************************/

@implementation PlacesTableView
@synthesize theArray, theTableView, arrayName, arrayAdress, arrayImages, arrayCategory, clickedObjectID;
NSString *string, *string_ObjectToDelete;
NSString *arrayName;
NSString *arrayAdress;
NSString *arrayCategory;

///*********************************************************************************
//
// viewDidLoad
//
//**********************************************************************************/

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initDisplay];
    [self gettingAllSearchResults];
}

- (void)viewDidUnload{
    [super viewDidUnload];
}

///*********************************************************************************
//
// delegate methods
//
//**********************************************************************************/

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    // Return the number of rows in the section.
    return [arrayName count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text = [arrayName objectAtIndex:indexPath.row];
    cell.detailTextLabel.text = [arrayAdress objectAtIndex:indexPath.row];
    
    if([[arrayCategory objectAtIndex:indexPath.row] isEqual: @"shopping"]){
        cell.imageView.image = [UIImage imageNamed:@"shopping"];
        //cell.imageView.frame = CGRectMake(0, 0, 10, 10);
    }
    
    if([[arrayCategory objectAtIndex:indexPath.row] isEqual: @"food"]){
        cell.imageView.image = [UIImage imageNamed:@"food"];
    }
    
    if([[arrayCategory objectAtIndex:indexPath.row] isEqual: @"nightlife"]){
        cell.imageView.image = [UIImage imageNamed:@"nightlife"];
    }
    
    if([[arrayCategory objectAtIndex:indexPath.row] isEqual: @"cafe"]){
        cell.imageView.image = [UIImage imageNamed:@"cafe"];
    }
    
    if([[arrayCategory objectAtIndex:indexPath.row] isEqual: @"activity"]){
        cell.imageView.image = [UIImage imageNamed:@"activity"];
    }
    
    if([[arrayCategory objectAtIndex:indexPath.row] isEqual: @"culture"]){
        cell.imageView.image = [UIImage imageNamed:@"culture"];
    }
    
    if([[arrayCategory objectAtIndex:indexPath.row] isEqual: @"hotel"]){
        cell.imageView.image = [UIImage imageNamed:@"hotel"];
    }
    
    if([[arrayCategory objectAtIndex:indexPath.row] isEqual: @"icons"]){
        cell.imageView.image = [UIImage imageNamed:@"icons"];
    }
    
    if([[arrayCategory objectAtIndex:indexPath.row] isEqual: @"other"]){
        cell.imageView.image = [UIImage imageNamed:@"other"];
    }
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    string = [tableView cellForRowAtIndexPath:indexPath].textLabel.text;
    NSLog(@"%@",string);
    [self goToDetailView];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //add code here for when you hit delete
        NSMutableArray* arrayNameDelete = arrayName;
        NSMutableArray* arrayAdressDelete = arrayAdress;
        NSMutableArray* arrayCategoryDelete = arrayCategory;
        [[RouteModel sharedInstance] removeAssociatedRoutes:arrayName[indexPath.row]];
        [[RouteModel sharedInstance] removeMarkerByName:arrayName[indexPath.row]];
        [self deleteFromParseTable:indexPath];
        [arrayNameDelete  removeObjectAtIndex:indexPath.row];
        [arrayAdressDelete removeObjectAtIndex:indexPath.row];
        [arrayCategoryDelete removeObjectAtIndex:indexPath.row];
        [theTableView reloadData];
        
    }
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated{
    self.theTableView.allowsMultipleSelectionDuringEditing = editing;
    [super setEditing:editing animated:animated];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    return YES;
}

///*********************************************************************************
//
// load all places in arrays
//
//**********************************************************************************/

- (void) gettingAllSearchResults{
    NSMutableArray *places = [[NSMutableArray alloc]init];
    NSMutableArray *address = [[NSMutableArray alloc]init];
    NSMutableArray *categories = [[NSMutableArray alloc]init];
    NSMutableArray *images = [[NSMutableArray alloc]init];
    
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
    
    
    PFQuery *event_query1 = [PFQuery queryWithClassName:@"Pics"];
    [event_query1 orderByDescending:@"updatedAt"];
    [event_query1 findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
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

///*********************************************************************************
//
// delete the selected cell
//
//**********************************************************************************/

- (void)deleteFromParseTable:(NSIndexPath *)indexToDelete {
    string_ObjectToDelete = [theTableView cellForRowAtIndexPath:indexToDelete].textLabel.text;
    PFQuery *query = [PFQuery queryWithClassName:@"Place"];
    [query whereKey:@"name" equalTo:string_ObjectToDelete];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            NSLog(@"Successfully retrieved %lu scores.", (unsigned long)objects.count);
            // Do something with the found objects
            for (PFObject *object in objects) {
                [object deleteInBackground];
            }
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    
    PFQuery *query1 = [PFQuery queryWithClassName:@"Pics"];
    [query1 whereKey:@"name" equalTo:string_ObjectToDelete];
    [query1 findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            NSLog(@"Successfully retrieved %lu scores.", (unsigned long)objects.count);
            // Do something with the found objects
            for (PFObject *object in objects) {
                [object deleteInBackground];
            }
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    
}


///*********************************************************************************
//
// prepare for segue
//
//**********************************************************************************/
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

///*********************************************************************************
//
// initDisplay
//
//**********************************************************************************/
-(void)initDisplay{
    theTableView = [[UITableView alloc] initWithFrame:CGRectMake(10, 75, 300, self.view.frame.size.height-80) style:UITableViewStylePlain];
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
}

-(void)goToDetailView{
    [self performSegueWithIdentifier:@"ListeToDetailView" sender:self];
    
}

@end

