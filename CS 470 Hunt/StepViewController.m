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
@property (weak, nonatomic) IBOutlet UILabel *stepCount;
@property (weak, nonatomic) IBOutlet UIImageView *stepImage;
@property (weak, nonatomic) IBOutlet UILabel *optionalText;

@property (nonatomic) StepDataSource *dataSource;
@property (nonatomic) Step *step;
@property (nonatomic) UIActivityIndicatorView *activityIndicator;


@property (nonatomic) BOOL dataReady;

//@property (nonatomic,strong) CLLocationManager *locationManager;


@end
        
@implementation StepViewController

@synthesize stepImage;



- (instancetype) initWithHunt:(Hunt *) hunt
{
    if( (self = [super init]) == nil )
        return nil;
    self.hunt = hunt;
    
    return self;

}

- (void) viewDidLoad
{
    NSLog( @"In view did load" );
    NSLog( @"Title: %@", self.huntName );
    self.huntTitle.text = self.huntName;
//    [self.huntTitle setTextColor:[UIColor whiteColor]];
    [self.huntTitle setTextColor:[UIColor colorWithRed:(98.0/255.0) green:(90.0/255.0) blue:(90.0/255.0) alpha:1.0]];
    
    
    NSString *hName = [self.hunt title];
    self.huntTitle.text = hName;
    
    NSLog( @"hunt Name: %@", hName );
    
    NSString *stepURLString = @"http://cs.sonoma.edu/~ppfeffer/470/pullData.py?rType=stepsInHunt&rHunt=";
    stepURLString = [stepURLString stringByAppendingString:hName];
    stepURLString = [stepURLString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    self.dataSource = [[StepDataSource alloc] initWithStepsURL:stepURLString];
    [self.dataSource setDelegate:self];
    
    
    
    _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [self.activityIndicator setCenter: self.view.center];
    [self.view addSubview: self.activityIndicator];
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager startUpdatingLocation];
//    locationManager.location
    
    
    
}

- (void) dataSourceReadyForUse:(StepDataSource *) dataSource
{
    [self.activityIndicator stopAnimating];
    NSLog( @"Data source is ready for use" );
    
    
    self.dataReady = true;
    
    self.step = [self.dataSource stepAtIndex:0];

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
                    self.stepImage.image = urlImage;
            }
//                else
//                    self.stepImage.image = [UIImage imageNamed:@"loading_image.jpg"];
//            }
//            else
//                self.stepImage.image = [UIImage imageNamed:@"loading_image.jpg"];
            
        });
    });

    
    
}


/* This is from http://stackoverflow.com/questions/6894624/how-can-i-get-gps-location-in-iphone 
 It is an attempt to get the users current location.. This will be used to see if user is in vicinity of photo
 */
//-(void)startLocationManager
//{
//        NSLog(@"Called start location manager");
//    if ([CLLocationManager locationServicesEnabled]) {
//        self.locationManager = [[CLLocationManager alloc] init];
//        self.locationManager.delegate = self;
//        [self.locationManager startUpdatingLocation];
//    } else {
//        NSLog(@"Location services are not enabled");
//        return;
//    }
//    
//
//    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
//        [self.locationManager requestAlwaysAuthorization];
//    }
//    
//    self.locationManager.desiredAccuracy=kCLLocationAccuracyBest;
//    [self.locationManager startMonitoringSignificantLocationChanges];
//    self.locationManager.distanceFilter=kCLDistanceFilterNone;
//    [self.locationManager startUpdatingLocation];
//
//    //
////    CLLocation *newLocation = [[CLLocation alloc] initWithLatitude:0 longitude:0];
////    CLLocation *oldLocation = [[CLLocation alloc] initWithLatitude:100 longitude:100];
////    [self locationManager:self.locationManager didUpdateLocations:newLocation fromLocation:oldLocation];
//    
//}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
//    CLLocationCoordinate2D coordinate = [newLocation coordinate];
//    double dblLatitude = coordinate.latitude;
//    double dblLongitude = coordinate.longitude;

    NSLog(@"didUpdateToLocation: %@", newLocation);

}

@end











