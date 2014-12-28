//
//  OrtHinzuefugen.h
//  TravelApp
//
//  Created by Zenib Awan on 17.12.14.
//  Copyright (c) 2014 Eli. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>

@interface OrtHinzuefugen: UIViewController <UITextFieldDelegate>{
    UIImageView *imageView;
    NSString *_textfieldString;
    
}
@property (nonatomic, retain) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) UIImage *myImage;
@property float longitude, latitude;
@property (nonatomic, strong) NSString *geoPlace;

@end
