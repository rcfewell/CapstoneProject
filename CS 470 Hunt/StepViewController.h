//
//  StepViewController.h
//  CS 470 Hunt
//
//  Created by Riley Fewell on 4/19/15.
//  Copyright (c) 2015 PaulRileyJulian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StepViewController : UIViewController

@property (nonatomic) NSString *huntName;

- (instancetype) initWithTitle: (NSString *) title;

@end
