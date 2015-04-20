//
//  StepViewController.m
//  CS 470 Hunt
//
//  Created by Riley Fewell on 4/19/15.
//  Copyright (c) 2015 PaulRileyJulian. All rights reserved.
//

#import "StepViewController.h"

@interface StepViewController ()

@property (weak, nonatomic) IBOutlet UILabel *huntTitle;
@property (nonatomic) StepDataSource *dataSource;
@property (nonatomic) Step *step;
@property(nonatomic) UIActivityIndicatorView *activityIndicator;



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
    
    self.step = [[Step alloc]init];
    
    NSString *stepURLString = @"http://cs.sonoma.edu/~ppfeffer/470/pullData.py?rType=stepsInHunt&rHunt=";
    stepURLString = [stepURLString stringByAppendingString:self.huntName];
    stepURLString = [stepURLString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    self.dataSource = [[StepDataSource alloc] initWithStepsURL:stepURLString];
    [self.dataSource setDelegate:self];
    
    
    _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [self.activityIndicator setCenter: self.view.center];
    [self.view addSubview: self.activityIndicator];
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    NSLog(@"description: %@", [self.step.stepAttributes valueForKey:@"description"] );
    
    
    

    
    
    
    
    
    
    
    
    

    
    
    
    
    
    
    
    
    
    
    
    
    
}

- (void) dataSourceReadyForUse:(StepDataSource *) dataSource
{
    [self.activityIndicator stopAnimating];
}

@end










