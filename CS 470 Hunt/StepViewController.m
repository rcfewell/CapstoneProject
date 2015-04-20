//
//  StepViewController.m
//  CS 470 Hunt
//
//  Created by Riley Fewell on 4/19/15.
//  Copyright (c) 2015 PaulRileyJulian. All rights reserved.
//

#import "StepViewController.h"

@interface StepViewController ()

//@property (nonatomic) NSString *huntName;
@property (weak, nonatomic) IBOutlet UILabel *huntTitle;


@end

@implementation StepViewController

- (instancetype) initWithTitle: (NSString *) title
{
    NSLog( @"Title: %@", title );
    
    if( (self = [super init]) == nil )
        return nil;
    self.huntName = [[NSString alloc] initWithString:title];
        
    return self;
}

- (void) viewDidLoad
{
    NSLog( @"In view did load" );
    NSLog( @"Title: %@", self.huntName );
    self.huntTitle.text = self.huntName;
}

@end
