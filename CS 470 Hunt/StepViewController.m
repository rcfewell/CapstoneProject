//
//  StepViewController.m
//  CS 470 Hunt
//
//  Created by Riley Fewell on 4/19/15.
//  Copyright (c) 2015 PaulRileyJulian. All rights reserved.
//

#import "StepViewController.h"


@interface StepViewController ()
{
    int stepNumber;
}



@property (weak, nonatomic) IBOutlet UILabel *huntTitle;
@property (weak, nonatomic) IBOutlet UILabel *stepCount;
@property (weak, nonatomic) IBOutlet UIImageView *stepImage;
@property (weak, nonatomic) IBOutlet UILabel *optionalText;
@property (weak, nonatomic) IBOutlet UIView *helpIndicator;
@property (weak, nonatomic) IBOutlet UISwitch *needHelp;

@property (nonatomic) StepDataSource *dataSource;
@property (nonatomic) Step *step;
@property (nonatomic) NSInteger numberOfSteps;
@property (nonatomic) UIActivityIndicatorView *activityIndicator;


@property (nonatomic) BOOL dataReady;

@property (nonatomic) CLLocationDegrees imageLongitude;
@property (nonatomic) CLLocationDegrees imageLatitude;
@property (nonatomic) CLLocation * imageLocation;
@property (nonatomic) float previousDistance;
@end
        
@implementation StepViewController

@synthesize stepImage;
@synthesize locationManager;

int count = 0;


- (instancetype) initWithHunt:(Hunt *) hunt
{
    if( (self = [super init]) == nil )
        return nil;
    self.hunt = hunt;
    
    return self;

}

- (void) viewDidLoad
{
    self.helpIndicator.layer.borderColor = [UIColor clearColor].CGColor;
    NSLog( @"In view did load" );
    NSLog( @"Title: %@", self.huntName );
    self.huntTitle.text = self.huntName;
//    [self.huntTitle setTextColor:[UIColor whiteColor]];
    [self.huntTitle setTextColor:[UIColor colorWithRed:(98.0/255.0) green:(90.0/255.0) blue:(90.0/255.0) alpha:1.0]];
    
    
    NSString *hName = [self.hunt title];
    self.huntTitle.text = hName;
    
    NSLog( @"hunt Name: %@", hName );
    
    NSString *stepURLString = @"http://www.cs.sonoma.edu/~ppfeffer/470/pullData.py?rType=stepsInHunt&rHunt=";
    stepURLString = [stepURLString stringByAppendingString:hName];
    stepURLString = [stepURLString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    self.dataSource = [[StepDataSource alloc] initWithStepsURL:stepURLString];
    [self.dataSource setDelegate:self];
    
    
    
    _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [self.activityIndicator setCenter: self.view.center];
    [self.view addSubview: self.activityIndicator];
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    //-----------------------------------------------
    //          Set up location stuff
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    {
        [self.locationManager requestAlwaysAuthorization];
    }
    [self.locationManager startUpdatingLocation];
    self.imageLocation = [[CLLocation alloc]init];
    //-----------------------------------------------
}

- (void) dataSourceReadyForUse:(StepDataSource *) dataSource
{
    [self.activityIndicator stopAnimating];
    NSLog( @"Data source is ready for use" );
    
    
    self.dataReady = true;
    
    self.step = [self.dataSource stepAtIndex:0];
    self.numberOfSteps = [self.dataSource numberOfSteps];
    NSLog(@"Number of Steps: %lu",(unsigned long)self.numberOfSteps );
    stepNumber = 0;

    [self addStepNumber];
}

- (void) addStepNumber
{
    NSLog( @"step Number: ->%@<-", [self.step getStepNumber] );
//        if( [self.step getStepNumber] < & )
//            self.stepCount.text = [NSString stringWithFormat:@"No Available steps for this hunt"];
    
    self.stepCount.text = [NSString stringWithFormat:@"Step %@", [self.step getStepNumber]];
    [self.stepCount setTextColor:[UIColor colorWithRed:(98.0/255.0) green:(90.0/255.0) blue:(90.0/255.0) alpha:.75]];
    [self setUpOptionalDescription];
    
    
}

- (void) setUpOptionalDescription
{
    self.optionalText.text = [NSString stringWithFormat:@"Hint:\n %@", [self.step getDescription]];
//    self.optionalText.layer.borderWidth = 1;
    self.optionalText.layer.cornerRadius = 2;
    
    [self.optionalText setTextColor:[UIColor colorWithRed:(98.0/255.0) green:(90.0/255.0) blue:(90.0/255.0) alpha:0.75]];
    [self addImage];
    
    
}

- (IBAction)doesNeedHelp:(UISwitch *)sender
{

    if( [self.needHelp isOn])
    {
        NSLog( @"Switch is on" );
    }
    else{
        self.helpIndicator.layer.borderColor = [UIColor clearColor].CGColor;
    }
}



- (void) addImage
{

    NSString *urlString = [NSString stringWithFormat:@"%@", [self.step getImageURL]];

//    NSData *urlData = [NSData dataWithContentsOfURL:stepURLPath];
//    UIImage *urlImage = [UIImage imageWithData:urlData];
//    UIImage *urlImage = [UIImage imageWithContentsOfFile:urlString];
    
//    self.stepImage.image = [UIImage imageNamed:@"loading_compass.png"];
    
  
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlString]];
        
        dispatch_async(dispatch_get_main_queue(), ^{
           
            if( imageData )
            {
                UIImage *urlImage = [UIImage imageWithData:imageData];
                
                if( urlImage )
                {
                    self.stepImage.image = urlImage;
//
                }
                
            }
//                else
//                    self.stepImage.image = [UIImage imageNamed:@"loading_image.jpg"];
//            }
//            else
//                self.stepImage.image = [UIImage imageNamed:@"loading_image.jpg"];
            
        });
    });
    

    
    
}


- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    CLLocation *currentLocation = newLocation;
    self.imageLatitude = [[self.step getValueForAttribute:@"lat"] doubleValue];
    self.imageLongitude = [[self.step getValueForAttribute:@"long"] doubleValue];

    CLLocation *imageLocation = [[CLLocation alloc] initWithLatitude:self.imageLatitude longitude:self.imageLongitude];
    float distance = [imageLocation getDistanceFrom:currentLocation];
    NSLog(@"Distance = %.12f", distance);
    // if distance is less than whatever it needs to be we go to next step?
    
    
    NSString *imgLong = [NSString stringWithFormat:@"Image Longitude %.12f", self.imageLongitude];
    NSString *imgLat = [NSString stringWithFormat:@"Image Latitude %.12f", self.imageLatitude];
    NSLog( @"%@", imgLong );
    NSLog( @"%@", imgLat );
    NSLog(@"Users Longitude %@", @(currentLocation.coordinate.longitude));
    NSLog(@"Users Latitude  %@", @(currentLocation.coordinate.latitude));
    
    // withing 5 meters of the image == about 10 feet
    if( distance < 16.0 ){
//        [self changeStep];
        count += 1;
    }
    else{
        count = 0;
    }
    if (count >= 3){
        [self changeStep];
    }
    if( [self.needHelp isOn])
    {
        if (self.previousDistance < distance){
            self.helpIndicator.layer.borderColor = [UIColor redColor].CGColor;
        }
        else if (self.previousDistance == distance){
            
        }
        else{
            self.helpIndicator.layer.borderColor = [UIColor greenColor].CGColor;
        }
    }
    else{
        NSLog(@"%lu", self.needHelp.state);
    }
    self.previousDistance = distance;

}

- (void) changeStep
{
    NSLog( @"We found the picture" );
    stepNumber++;
//    self.needHelp.on = NO;
    [self.needHelp setOn:NO animated:YES];
    self.helpIndicator.layer.borderColor = [UIColor clearColor].CGColor;
    
    if( stepNumber == self.numberOfSteps )
    {
        UIAlertView *finishedHunt = [[UIAlertView alloc] initWithTitle:@"Congratulations" message:@"You finished the hunt!" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles: nil];
        [finishedHunt show];
//        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    
    if( stepNumber < self.numberOfSteps )
    {
        self.step = [self.dataSource stepAtIndex:stepNumber];
        [self addStepNumber];
//        [UIView animateWithDuration:1.0 animations:^{
//            self.stepImage.alpha = 0.0;
//            
//        }completion:^(BOOL finished) {
//            self.step = [self.dataSource stepAtIndex:stepNumber];
//            [self addStepNumber];
////            self.stepImage.alpha = 1.0;
//        }];
    }

}
-(void) viewDidAppear:(BOOL)animated{
    if (self.isMovingFromParentViewController){
        NSLog(@"Moving to parent");
        [locationManager stopUpdatingLocation];
    }
}

-(void) viewWillDisappear:(BOOL)animated{
    if (self.isMovingFromParentViewController){
        NSLog(@"Moving to parent");
        [locationManager stopUpdatingLocation];
    }
}
- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if( buttonIndex == 0 )
        [self.navigationController popToRootViewControllerAnimated:YES];
}
@end











