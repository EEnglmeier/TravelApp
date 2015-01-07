//
//  CustomInfoWindow.h
//  TravelApp
//
//  Created by Katrin Schauer on 07.01.15.
//  Copyright (c) 2015 Eli. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomInfoWindow : UIView

@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *address;
@property (weak, nonatomic) IBOutlet UIImageView *photo;
@property (weak, nonatomic) IBOutlet UIImageView *category;

@end
