//
//  CreateViewController.h
//  CS 470 Hunt
//
//  Created by student on 4/27/15.
//  Copyright (c) 2015 PaulRileyJulian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

#import "CreateDataSource.h"
@import AssetsLibrary;

@interface CreateViewController : UIViewController<UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate, UITextViewDelegate, UIAlertViewDelegate, UIActionSheetDelegate, CLLocationManagerDelegate>{
    CLLocationManager *locationManager;

}
@property (strong, nonatomic) CLLocationManager *locationManager;

@end
