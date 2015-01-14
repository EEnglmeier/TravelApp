//
//  DetailView.m
//  TravelApp
//
//  Created by Zenib Awan on 15.12.14.
//  Copyright (c) 2014 Eli. All rights reserved.
//

#import "DetailView.h"
#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <QuartzCore/QuartzCore.h>
#import "MapViewController.h"
#import "BuildDetailView.h"
#import "TravelApp-Swift.h"

@interface DetailView ()

@end

@implementation DetailView
typedef void(^methodAWithCompletion)(BOOL);

///*********************************************************************************
//
// variables
//
//**********************************************************************************/

@synthesize objectID, segueTag, name, category, adress, imageFile, allImages, getImage;
int buttonsize1 = 60;
int aPlaceLabelY = 460;
float buttonBorderwidth1 = 1.7f;
NSString  *geoName;
UIImageView *imageView;
PFFile *imageFile;
NSString *objectIDFromMapView;
NSString *objectIDFromTableView;
UIImagePickerController *pic;
bool _imageChosen = NO;
UIButton *nextImage;
UIImage *pickedImage;
bool *finished;
NSMutableArray *arrayAllImages, *obj;
UIButton *button_Right, *button_Left;
int i_next=0;
static int i_prev;


///*********************************************************************************
//
// viewWillAppear
//
//**********************************************************************************/

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self whichObjectToShow];
    [self initDisplay];
    i_next = 0;
    
}

///*********************************************************************************
//
// navigation functions & button actions
//
//**********************************************************************************/

- (void)backToMap{
    // back to map... (im storyboard heißt der tabbarcontroller "tabbarController"
    UITabBarController* tabController = [[UIStoryboard storyboardWithName:@"Main" bundle:NULL] instantiateViewControllerWithIdentifier:@"tabbarController"];
    
    // hier kann man die transition ändern z.B. kCATransitionPush, kCATransitionFromBottom ...
    CATransition* transition = [CATransition animation];
    transition.duration = 0.5;
    transition.type = kCATransitionFromBottom;
    //transition.type = kCATransitionFade;
    
    // present tabController
    [self.view.window.layer addAnimation:transition forKey:kCATransition];
    [self presentViewController:tabController animated:NO completion:nil];
}

-(void)done{
    [[RouteModel sharedInstance] updateAllData];
    NSLog(@"Done Button is clicked");
    if ([segueTag isEqualToString:@"buildDetailView"]) {
        [self backToMap];
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
}


///*********************************************************************************
//
// which place to show in detailView
//
//**********************************************************************************/

-(void) whichObjectToShow{
    
    if ([segueTag isEqualToString:@"buildDetailView"]) {
        NSLog(@"from buildDetailView");
        PFQuery *query = [PFQuery queryWithClassName:@"Place"];
        [query orderByDescending:@"updatedAt"];
        PFObject *aPlace = [query getFirstObject];
        name = [aPlace objectForKey:@"name"];
        category = [aPlace objectForKey:@"category"];
        adress = [aPlace objectForKey:@"adress"];
        PFQuery *queryImg = [PFQuery queryWithClassName:@"Pics"];
        [queryImg whereKey:@"placeName" equalTo:name];
        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:2]];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, kNilOptions), ^{
            PFObject *aImage = [queryImg getFirstObject];
            imageFile = aImage[@"imageFile"];
            //[[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:2]];
            [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
            [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:2]];
            if (!data) {
                //[[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:2]];
                return NSLog(@"%@", error);
            }
            // Do something with the image
            imageView.image = [UIImage imageWithData:data];
            }];
        });
        
        
        
        
        /*PFQuery *getPlaces = [PFQuery queryWithClassName:@"Place"];
        
        //[getPlaces orderByAscending:@"celebid"];
        
        PFQuery *getPics = [PFQuery queryWithClassName:@"Pic"];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, kNilOptions), ^{
            [getPics whereKey:@"placeName" matchesKey:@"name" inQuery:getPlaces];
        [getPics findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (!error) {
                for (PFObject *object in objects) {
                    [obj addObject:object];
                }
                getImage = obj;
            }
            
            PFObject *aImage = getImage[0];
            
            imageFile = aImage[@"imageFile"];
            [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                if (!data) {
                    return NSLog(@"%@", error);
                }
                // Do something with the image
                imageView.image = [UIImage imageWithData:data];
            }];
        }];
            
            
        });*/
        
        
        
    }
    
    if ([segueTag isEqualToString:@"clickedObject"]) {
        NSLog(@"from tableView");
        PFQuery *query = [PFQuery queryWithClassName:@"Place"];
        [query whereKey:@"objectId" equalTo:self.objectID];
        PFObject *object = [query getFirstObject];
        name = [object objectForKey:@"name"];
        category = [object objectForKey:@"category"];
        adress = [object objectForKey:@"adress"];
        //imageFile = object[@"image"];
        [self methodAWithCompletion:^(BOOL finished) {
            if(finished){
                NSLog(@"success");
            }
        }];
    }
    
    if([segueTag isEqualToString:@"clickedPin"]){
        PFQuery *query = [PFQuery queryWithClassName:@"Place"];
        [query whereKey:@"objectId" equalTo:self.objectID];
        PFObject *object = [query getFirstObject];
        name = [object objectForKey:@"name"];
        category = [object objectForKey:@"category"];
        adress = [object objectForKey:@"adress"];
        //imageFile = object[@"image"];
        [self methodAWithCompletion:^(BOOL finished) {
            if(finished){
                NSLog(@"success");
            }
        }];
    }
}

//*********************************************************************************
//
// Load Images from one Place in Array
//
//**********************************************************************************/

- (void)downloadAllImages{
    [self methodAWithCompletion:^(BOOL success) {
        // check if thing worked.
    }];
}

- (void)methodAWithCompletion:(void (^) (BOOL success))completion
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, kNilOptions), ^{
        
        arrayAllImages = [[NSMutableArray alloc]init];
        PFQuery *query = [PFQuery queryWithClassName:@"Pics"];
        [query whereKey:@"placeName" equalTo:name];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (!error) {
                for (PFObject *object in objects) {
                    [arrayAllImages addObject:object];
                }
                allImages = arrayAllImages;
                i_prev = allImages.count;
                imageFile = allImages[0][@"imageFile"];
                [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                    if (!data) {
                        return NSLog(@"%@", error);
                    }
                    // Do something with the image
                    imageView.image = [UIImage imageWithData:data];
                }];
                
                
            }
            NSLog(@"Successfully retrieved %lu images.", (unsigned long)allImages.count);
        }];
    });
    completion(YES);
    
}

//*********************************************************************************
//
// show other images from one place
//
//**********************************************************************************/

-(void) pressRightForNextImage{
    
    if (i_next < (allImages.count-1))
    {
        i_next=i_next+1;
        imageFile = allImages[i_next][@"imageFile"];
        [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
            if (!data) {
                return NSLog(@"%@", error);
            }
            // Do something with the image
            imageView.image = [UIImage imageWithData:data];
        }];
        if(i_next == allImages.count-1){
            button_Right.hidden = YES;
            button_Left.hidden = NO;
            i_next = 0;
        }
    }
    else{
        //
        NSLog(@" you reach the last items ");
        
    }
}

-(void) pressLeftForPreviousImage{
    
    
    NSLog(@"left");
    
    if(i_prev >= 1){
        i_prev = i_prev-1;
        
        //NSLog(i);
        imageFile = allImages[i_prev-1][@"imageFile"];
        [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
            if (!data) {
                return NSLog(@"%@", error);
            }
            // Do something with the image
            imageView.image = [UIImage imageWithData:data];
        }];
        if(i_prev == 1){
            button_Left.hidden = YES;
            button_Right.hidden = NO;
            i_prev = allImages.count;
        }
    }
    else
    {
        //
        NSLog(@" you reach the last items ");
        
    }
}



///*********************************************************************************
//
// imagePicker
//
//**********************************************************************************/

- (void) initImagePicker{
    
    //--- Wenn keine camera vorhanden
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                              message:@"Device has no camera"
                                                             delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles: nil];
        [myAlertView show];
    }
    
    //--- Wahl der Source
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Add a photo" message:@"Take a photo or choose from existing" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Choose from photo library", @"Take a photo", nil];
    alert.tag = 1;
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    if ([title isEqualToString:@"Cancel"]) {
//        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else if ([title isEqualToString:@"Take a photo"]){
        [self takePhoto];
    } else if ([title isEqualToString:@"Choose from photo library"]){
        [self selectPhoto];
    }
}

- (void)takePhoto{
    
    UIImagePickerController *pic = [[UIImagePickerController alloc] init];
    pic.delegate = self;
    pic.allowsEditing = YES;
    pic.sourceType = UIImagePickerControllerSourceTypeCamera;
    pic.navigationBarHidden = YES;
    [self presentViewController:pic animated:YES completion:^{ _imageChosen = YES; }];
    NSLog(@"Bild durch camera");
}


- (IBAction)selectPhoto{
    
    UIImagePickerController *pic = [[UIImagePickerController alloc] init];
    pic.delegate = self;
    pic.allowsEditing = YES;
    pic.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    pic.navigationBarHidden = YES;
    [self presentViewController:pic animated:YES completion:^{ _imageChosen = YES; }];
    NSLog(@"Bild durch Library");
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)pic {
    [pic dismissViewControllerAnimated:YES completion:^{
        [self resetView];
    }];
}

- (void) resetView{
    _imageChosen = NO;
}

- (void)imagePickerController:(UIImagePickerController *)pic didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo{
    pickedImage = image;
    _imageChosen = YES;
    nextImage = [[UIButton alloc] init];
    UIImage *img1 = [UIImage imageNamed:@"Arrow"];
    [nextImage setImage:img1 forState:UIControlStateNormal];
    [nextImage setFrame:CGRectMake(85, 430, 0, 0)];
    [nextImage addTarget:self action:@selector(newMethod:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextImage];
    //self->takenImage = image;
    [pic dismissViewControllerAnimated:NO completion:nil];
    [self saveImageToParse];
}


///*********************************************************************************
//
// save pickedImage to Parse
//
//**********************************************************************************/

-(void)saveImageToParse{
    PFObject *object = [PFObject objectWithClassName:@"Pics"];
    NSData *imageData = UIImageJPEGRepresentation(pickedImage, 0.8);
    NSString *filename = [NSString stringWithFormat:@"test.png"];
    imageFile = [PFFile fileWithName:filename data:imageData];
    [object setObject:imageFile forKey:@"imageFile"];
    [object setObject:name forKey:@"placeName"];
    
    
    [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Upload Failure" message:[error localizedDescription] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
    }];
}

////*********************************************************************************
//
// initDisplay
//
//**********************************************************************************/

- (void)initDisplay{
    
    
    UINavigationBar *navBarLocation = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 70)];
    navBarLocation.backgroundColor = [UIColor grayColor];
    UINavigationItem *navItemLocation = [[UINavigationItem alloc] init];
    navItemLocation.title = name;
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(done)];
    navItemLocation.rightBarButtonItem = doneButton;
    navBarLocation.items = @[navItemLocation];
    [[self view] addSubview: navBarLocation];
    
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(85, 90, 150, 150)];
    [[self view] addSubview: imageView];
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    
    UIButton *addImage = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [addImage addTarget:self action:@selector(initImagePicker) forControlEvents:UIControlEventTouchUpInside];
    [addImage setTitle:@"Add Image +" forState:UIControlStateNormal];
    addImage.frame = CGRectMake(80.0, 240.0, 160.0, 40.0);
    [self.view addSubview:addImage];
    
    UILabel *locationLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 285, self.view.frame.size.width, 40)];
    locationLabel.text = [@"     " stringByAppendingString: name];
    locationLabel.font = [UIFont systemFontOfSize:15];
    locationLabel.layer.borderColor = [UIColor grayColor].CGColor;
    locationLabel.layer.borderWidth = 1.0;
    [self.view addSubview:locationLabel];
    
    
    UILabel *locAdress = [[UILabel alloc] initWithFrame:CGRectMake(20, 345, 280, 40)];
    locAdress.text = adress;
    //locAdress.lineBreakMode = UILineBreakModeWordWrap;
    locAdress.numberOfLines = 2;
    locAdress.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:locAdress];
    
    
    UIButton *locationButton = [UIButton buttonWithType:UIButtonTypeCustom];
    locationButton.frame = CGRectMake(125, 410, buttonsize1, buttonsize1);
    locationButton.clipsToBounds = YES;
    locationButton.layer.cornerRadius = buttonsize1/2.0f;
    locationButton.layer.borderWidth=buttonBorderwidth1;
    
    if ([segueTag isEqualToString:@"clickedObject"]) {
        
        
        
        button_Right = [UIButton buttonWithType:UIButtonTypeCustom];
        button_Right.frame = CGRectMake(250, 157, 25, 25);
        [button_Right setImage:[UIImage imageNamed:@"Arrow"] forState:UIControlStateNormal];
        [button_Right addTarget: self action: @selector(pressRightForNextImage) forControlEvents: UIControlEventTouchUpInside];
        [self.view addSubview:button_Right];
        if (allImages.count-1 == 0) {
            button_Right.hidden = YES;
        } else{
            button_Right.hidden = NO;
        }
        
        button_Left = [UIButton buttonWithType:UIButtonTypeCustom];
        button_Left.frame = CGRectMake(40, 145, 50, 50);
        [button_Left setImage:[UIImage imageNamed:@"ArrowLeft"] forState:UIControlStateNormal];
        [button_Left addTarget: self action: @selector(pressLeftForPreviousImage) forControlEvents: UIControlEventTouchUpInside];
        button_Left.hidden =YES;
        [self.view addSubview:button_Left];
    }
    
    if([category isEqual: @"shopping"]){
        
        [locationButton setImage:[UIImage imageNamed:@"shopping_clicked"] forState:UIControlStateNormal];
        locationButton.layer.backgroundColor = [[UIColor colorWithRed:95/255.f green:180/255.f blue:229/255.f alpha:1.0f] CGColor];
        locationButton.layer.borderColor = [[UIColor colorWithRed:95/255.f green:180/255.f blue:229/255.f alpha:1.0f] CGColor];
        [locationButton setImageEdgeInsets:UIEdgeInsetsMake(12, 12, 12, 12)];
        [[self view] addSubview:locationButton];
        UILabel  *locationLabel = [[UILabel alloc] initWithFrame:CGRectMake(125, aPlaceLabelY, 90, 50)];
        locationLabel.text = @"Shopping";
        locationLabel.font = [UIFont systemFontOfSize:14];
        [self.view addSubview:locationLabel];
    }
    
    if([category isEqual: @"activity"]){
        
        [locationButton setImage:[UIImage imageNamed:@"activity_clicked"] forState:UIControlStateNormal];
        locationButton.layer.backgroundColor = [[UIColor colorWithRed:234/255.f green:226/255.f blue:88/255.f alpha:1.0f] CGColor];
        locationButton.layer.borderColor = [[UIColor colorWithRed:234/255.f green:226/255.f blue:88/255.f alpha:1.0f] CGColor];
        [locationButton setImageEdgeInsets:UIEdgeInsetsMake(11, 11, 11, 11)];
        [[self view] addSubview:locationButton];
        UILabel  *locationLabel = [[UILabel alloc] initWithFrame:CGRectMake(132, aPlaceLabelY, 90, 50)];
        locationLabel.text = @"Activity";
        locationLabel.font = [UIFont systemFontOfSize:14];
        [self.view addSubview:locationLabel];
    }
    
    if([category isEqual: @"cafe"]){
        
        [locationButton setImage:[UIImage imageNamed:@"cafe_clicked"] forState:UIControlStateNormal];
        locationButton.layer.backgroundColor = [[UIColor colorWithRed:148/255.f green:100/255.f blue:214/255.f alpha:1.0f] CGColor];
        locationButton.layer.borderColor = [[UIColor colorWithRed:148/255.f green:100/255.f blue:214/255.f alpha:1.0f] CGColor];
        [locationButton setImageEdgeInsets:UIEdgeInsetsMake(12, 13, 13, 12)];
        [[self view] addSubview:locationButton];
        UILabel  *locationLabel = [[UILabel alloc] initWithFrame:CGRectMake(139, aPlaceLabelY, 90, 50)];
        locationLabel.text = @"Cafe";
        locationLabel.font = [UIFont systemFontOfSize:14];
        [self.view addSubview:locationLabel];
    }
    
    
    if([category isEqual: @"culture"]){
        
        [locationButton setImage:[UIImage imageNamed:@"culture_clicked"] forState:UIControlStateNormal];
        locationButton.layer.backgroundColor = [[UIColor colorWithRed:230/255.f green:115/255.f blue:191/255.f alpha:1.0f] CGColor];
        locationButton.layer.borderColor = [[UIColor colorWithRed:230/255.f green:115/255.f blue:191/255.f alpha:1.0f] CGColor];
        [locationButton setImageEdgeInsets:UIEdgeInsetsMake(13, 12, 12, 12)];
        [[self view] addSubview:locationButton];
        UILabel  *locationLabel = [[UILabel alloc] initWithFrame:CGRectMake(132, aPlaceLabelY, 90, 50)];
        locationLabel.text = @"Culture";
        locationLabel.font = [UIFont systemFontOfSize:14];
        [self.view addSubview:locationLabel];
    }
    
    if([category isEqual: @"food"]){
        
        [locationButton setImage:[UIImage imageNamed:@"food_clicked"] forState:UIControlStateNormal];
        locationButton.layer.backgroundColor = [[UIColor colorWithRed:255/255.f green:58/255.f blue:48/255.f alpha:1.0f] CGColor];
        locationButton.layer.borderColor=[[UIColor colorWithRed:255/255.f green:58/255.f blue:48/255.f alpha:1.0f] CGColor];
        [locationButton setImageEdgeInsets:UIEdgeInsetsMake(12, 12, 12, 12)];
        [[self view] addSubview:locationButton];
        UILabel  *locationLabel = [[UILabel alloc] initWithFrame:CGRectMake(140, aPlaceLabelY, 90, 50)];
        locationLabel.text = @"Food";
        locationLabel.font = [UIFont systemFontOfSize:14];
        [self.view addSubview:locationLabel];
    }
    
    if([category isEqual: @"hotel"]){
        
        [locationButton setImage:[UIImage imageNamed:@"hotel_clicked"] forState:UIControlStateNormal];
        locationButton.layer.backgroundColor = [[UIColor colorWithRed:27/255.f green:175/255.f blue:126/255.f alpha:1.0f] CGColor];
        locationButton.layer.borderColor=[[UIColor colorWithRed:27/255.f green:175/255.f blue:126/255.f alpha:1.0f] CGColor];
        [locationButton setImageEdgeInsets:UIEdgeInsetsMake(9, 9, 9, 9)];
        [[self view] addSubview:locationButton];
        UILabel  *locationLabel = [[UILabel alloc] initWithFrame:CGRectMake(138, aPlaceLabelY, 90, 50)];
        locationLabel.text = @"Hotel";
        locationLabel.font = [UIFont systemFontOfSize:14];
        [self.view addSubview:locationLabel];
    }
    
    if([category isEqual: @"icons"]){
        
        [locationButton setImage:[UIImage imageNamed:@"icons_clicked"] forState:UIControlStateNormal];
        locationButton.layer.backgroundColor = [[UIColor colorWithRed:249/255.f green:137/255.f blue:18/255.f alpha:1.0f] CGColor];
        locationButton.layer.borderColor = [[UIColor colorWithRed:249/255.f green:137/255.f blue:18/255.f alpha:1.0f] CGColor];
        [locationButton setImageEdgeInsets:UIEdgeInsetsMake(11, 12, 11, 11)];
        [[self view] addSubview:locationButton];
        UILabel  *locationLabel = [[UILabel alloc] initWithFrame:CGRectMake(137, aPlaceLabelY, 90, 50)];
        locationLabel.text = @"Sights";
        locationLabel.font = [UIFont systemFontOfSize:14];
        [self.view addSubview:locationLabel];
    }
    
    if([category isEqual: @"nightlife"]){
        
        [locationButton setImage:[UIImage imageNamed:@"nightlife_clicked"] forState:UIControlStateNormal];
        locationButton.layer.backgroundColor = [[UIColor colorWithRed:85/255.f green:85/255.f blue:85/255.f alpha:1.0f] CGColor];
        locationButton.layer.borderColor = [[UIColor colorWithRed:85/255.f green:85/255.f blue:85/255.f alpha:1.0f] CGColor];
        [locationButton setImageEdgeInsets:UIEdgeInsetsMake(13, 13, 13, 13)];
        [[self view] addSubview:locationButton];
        UILabel  *locationLabel = [[UILabel alloc] initWithFrame:CGRectMake(130, aPlaceLabelY, 90, 50)];
        locationLabel.text = @"Nightlife";
        locationLabel.font = [UIFont systemFontOfSize:14];
        [self.view addSubview:locationLabel];
    }
    
    if([category isEqual: @"other"]){
        
        [locationButton setImage:[UIImage imageNamed:@"other_clicked"] forState:UIControlStateNormal];
        locationButton.layer.backgroundColor = [[UIColor blackColor] CGColor];
        locationButton.layer.borderColor = [[UIColor blackColor] CGColor];
        [locationButton setImageEdgeInsets:UIEdgeInsetsMake(11, 9, 9, 9)];
        [[self view] addSubview:locationButton];
        UILabel  *locationLabel = [[UILabel alloc] initWithFrame:CGRectMake(137, aPlaceLabelY, 90, 50)];
        locationLabel.text = @"Other";
        locationLabel.font = [UIFont systemFontOfSize:14];
        [self.view addSubview:locationLabel];
    }
}
@end
