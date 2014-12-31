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

UIImagePickerController *pic;

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    pic = [[UIImagePickerController alloc] init];
    pic.delegate = self;
    pic.allowsEditing = YES;
    [self presentModalViewController:pic animated:YES];
    NSLog(@"Ort");
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo{
    
    self->takenImage = image;
    [self performSegueWithIdentifier:@"OrtToBulldDetail" sender:self];
    [picker dismissViewControllerAnimated:NO completion:NULL];
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"OrtToBulldDetail"]){
        BuildDetailView *editViewController =
        (BuildDetailView *)segue.destinationViewController;
        [editViewController setMyImage:takenImage];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self performSegueWithIdentifier:@"OrtToPlaces" sender:self];
    [picker dismissViewControllerAnimated:YES completion:NULL];
}


@end
