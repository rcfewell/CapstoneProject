//
//  StepViewController.h
//  CS 470 Hunt
//
//  Created by Riley Fewell on 4/19/15.
//  Copyright (c) 2015 PaulRileyJulian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StepDataSource.h"
#import "Step.h"
#import "Hunt.h"
#import <CoreLocation/CoreLocation.h>

//@protocol CLLocationManagerDelegate;


@interface StepViewController : UIViewController<CLLocationManagerDelegate>

@property (nonatomic) NSString *huntName;
@property (nonatomic) Hunt *hunt;

//- (instancetype) initWithTitle: (NSString *) title;
- (instancetype) initWithHunt: (Hunt *) hunt;

@end

