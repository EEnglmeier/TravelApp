//
//  OrtHinzuefugen.m
//  TravelApp
//
//  Created by Zenib Awan on 20.12.14.
//  Copyright (c) 2014 Eli. All rights reserved.
//

#import "OrtHinzuefugen.h"
#import "BuildDetailView.h"



@implementation OrtHinzuefugen{
    UIImage *takenImage;
}

//--- Variable für die vom MapViewController übergebenen Koordinate durch longPressAtCoordinate
CLLocationCoordinate2D longpressed;

//--- ImagePicker: je nach Source durch camera oder photo library
UIImagePickerController *pic;

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
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
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Add a photo" message:@"Take a photo or choose from existing" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Take a photo", @"Choose from photo library", nil];
    alert.tag = 1;
    [alert show];
}


- (void)imagePickerController:(UIImagePickerController *)pic didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo{
    
    self->takenImage = image;
    [pic dismissViewControllerAnimated:NO completion:^{[self performSegueWithIdentifier:@"OrtToBuildDetail" sender:self];}];
//    [self performSegueWithIdentifier:@"OrtToBuildDetail" sender:self];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"OrtToBuildDetail"]){
        BuildDetailView *editViewController = segue.destinationViewController;
//        BuildDetailView *editViewController =
//        (BuildDetailView *)segue.destinationViewController;
        [editViewController setMyImage:takenImage];
        //[editViewController setPlaceLocationBV:longpressed];
        NSLog(@"Segue prepared");
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)pic {
    [pic dismissViewControllerAnimated:YES completion:^{[self performSegueWithIdentifier:@"OrtToMapView" sender:self];}];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    if ([title isEqualToString:@"Cancel"]) {
        [self imagePickerControllerDidCancel:pic];
    } else if ([title isEqualToString:@"Take a photo"]){
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
    [self presentViewController:pic animated:YES completion:nil];
    NSLog(@"Bild durch camera");
}


- (IBAction)selectPhoto{
    
    UIImagePickerController *pic = [[UIImagePickerController alloc] init];
    pic.delegate = self;
    pic.allowsEditing = YES;
    pic.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    pic.navigationBarHidden = YES;
    [self presentViewController:pic animated:YES completion:nil];
    NSLog(@"Bild durch Library");
}


@end