//
//  CreateViewController.m
//  CS 470 Hunt
//
//  Created by student on 4/27/15.
//  Copyright (c) 2015 PaulRileyJulian. All rights reserved.
//

#import "CreateViewController.h"

struct location
{
    double longitude;
    double latitude;
};



@interface CreateViewController ()


@property (weak, nonatomic) IBOutlet UITextField *huntTitle;
@property (weak, nonatomic) IBOutlet UILabel *stepNum;
@property (weak, nonatomic) IBOutlet UIButton *takePicture;
@property (weak, nonatomic) IBOutlet UIImageView *stepImage;
@property (weak, nonatomic) IBOutlet UITextView *stepDesc;
@property (weak, nonatomic) IBOutlet UIButton *submitStep;
@property (weak, nonatomic) IBOutlet UIButton *finishHunt;


@property (nonatomic) CreateDataSource *dataSource;
@property (nonatomic) ALAssetsLibrary *library;

@property (nonatomic) NSMutableArray * listOfStepDescriptions;
@property (nonatomic) NSMutableArray * listOfStepImages;
@property (nonatomic) NSMutableArray * listOfStepLocations;
@property (nonatomic) NSMutableArray * listOfStepLong;
@property (nonatomic) NSMutableArray * listOfStepLat;


@property (nonatomic) double userLong;
@property (nonatomic) double userLat;
@end


@implementation CreateViewController

@synthesize huntTitle;
@synthesize stepDesc;
@synthesize locationManager;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.huntTitle.delegate = self;
    self.stepDesc.delegate = self;
    self.library = [[ALAssetsLibrary alloc] init];
    
    self.listOfStepDescriptions = [[NSMutableArray alloc]init];
    self.listOfStepImages = [[NSMutableArray alloc]init];

    self.listOfStepLat = [[NSMutableArray alloc] init];
    self.listOfStepLong = [[NSMutableArray alloc] init];

    //-----------------------------------------------
    //          Set up location stuff
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    {
        [self.locationManager requestAlwaysAuthorization];
    }
    [self.locationManager startUpdatingLocation];
    
    //-----------------------------------------------
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)submitStepForHunt:(UIButton *)sender
{
    NSLog( @"Submit step" );
    [self.listOfStepDescriptions addObject:self.stepDesc.text];

    //==============================================
    // Add the long and lat of step to an array
    NSNumber *tempLat = [[NSNumber alloc] initWithDouble:self.userLat];
    NSNumber *tempLong = [[NSNumber alloc] initWithDouble:self.userLong];
    [self.listOfStepLat addObject:tempLat];
    [self.listOfStepLong addObject:tempLong];
    //==============================================
    
    NSLog([self.listOfStepDescriptions description]); 
    
    CGRect newRect = CGRectMake(0, 0, 512, 512);
    
    UIGraphicsBeginImageContext(newRect.size);
    UIImage * tempImage = [[UIImage alloc] init];
    tempImage = self.stepImage.image;
    [tempImage drawInRect:CGRectMake(0, 0, newRect.size.width, newRect.size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [self.listOfStepImages addObject:newImage];
    
    self.stepImage.image = nil;
    stepDesc.text = @"";
    
    self.stepNum.text = [NSString stringWithFormat:@"Step %lu", (unsigned long)[self.listOfStepDescriptions count]+1];
    self.finishHunt.enabled = true;
}


- (IBAction)submitHunt:(UIButton *)sender
{
    NSLog( @"submit hunt" );
    NSDate *date = [[NSDate alloc] init];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM-dd-yy"];
    
    NSString *todayDate = [dateFormatter stringFromDate:date];
    
    NSLog( @"Todays Date: %@ Hunt Title: %@", todayDate, self.huntTitle.text);
    
    NSString *huntURLString = [NSString stringWithFormat:@"http://www.cs.sonoma.edu/~ppfeffer/470/pullData.py?rType='setHuntName=%@---setHuntDate=%@", self.huntTitle.text, todayDate];
    huntURLString = [huntURLString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    int i=0;
    //Loop through array of steps Descriptions
    for (NSString *curStep in self.listOfStepDescriptions) {
        i++;
        //===
        NSDate *currentTime = [NSDate date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd_hh:mm:ss"];
        NSString *resultString = [dateFormatter stringFromDate: currentTime];
        resultString = [NSString stringWithFormat:@"%d-%@", i, resultString];
        NSLog(@"Image coming up");
        NSLog(@"%@", [self.listOfStepImages[i-1] description]);
        NSLog(@"%@", [self.stepImage.image description]);
        //======================================================================================================================================================================================
        //======================================================================================================================================================================================
        NSData *imageData = UIImagePNGRepresentation(self.listOfStepImages[i-1]);
        NSString *urlString = @"http://www.cs.sonoma.edu/~ppfeffer/470/uploader.php";
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        
        [request setURL:[NSURL URLWithString:urlString]];
        [request setHTTPMethod:@"POST"];

        NSString *boundary = @"---------------------------14737809831466499882746641449";
        NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
        
        [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
        
        NSMutableData *body = [NSMutableData data];
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"uploadedfile\"; filename=\"%@.jpg\"\r\n", resultString] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[NSData dataWithData:imageData]];
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [request setHTTPBody:body];
        
        NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
        NSString *tempString = [NSString stringWithFormat:@"Image Return String: %@", [returnString description]];  // Get rid of warnings
        NSLog(@"%@", tempString);
        //======================================================================================================================================================================================
        //======================================================================================================================================================================================
        NSString * urlPath = [NSString stringWithFormat:@"http://www.cs.sonoma.edu/~ppfeffer/470/uploads/%@.jpg",resultString];
        NSString *stepURLString = [NSString stringWithFormat:@"http://www.cs.sonoma.edu/~ppfeffer/470/pullData.py?rType=huntName=%@---stepDesc=%@---urlPath=%@---stepNum=%d---userLong=%@---userLat=%@", self.huntTitle.text, curStep, urlPath,i, self.listOfStepLong[i-1], self.listOfStepLat[i-1]];
        stepURLString = [stepURLString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSLog(@"%@", stepURLString);
        self.dataSource = [[CreateDataSource alloc] initWithHuntString:stepURLString];  // Have faith daniel son

        

    }
    
    self.dataSource = [[CreateDataSource alloc] initWithHuntString:huntURLString];
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}

- (IBAction)takePictureButtonPressed:(UIButton *)sender
{
    NSLog(@"Open Camera roll");
    
//    UIAlertView *chose = [[UIAlertView alloc] initWithTitle:@"Upload Photo" message:@"How would you like to add a photo?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Camera", @"Photo Library", nil];
    UIActionSheet *prac = [[UIActionSheet alloc] initWithTitle:@"Upload Photo" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Camera", @"Photo Library", nil];
    [prac showInView:self.view];
//    [chose show];
    
    
}

- (void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if( buttonIndex == 0 )
    {
        NSLog( @"pressed camera" );
        UIAlertView *cameraAlert = [[UIAlertView alloc] initWithTitle:@"Simulator Error" message:@"Simulator does not allow the camera to be used" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles: nil];
        
        [cameraAlert show];
//        UIImagePickerController *takePhoto = [[UIImagePickerController alloc] init];
//        
//        takePhoto.delegate = self;
//        takePhoto.allowsEditing = YES;
//        takePhoto.sourceType = UIImagePickerControllerSourceTypeCamera;
//        [self presentViewController:takePhoto animated:YES completion:nil];
    }
    if( buttonIndex == 1 )
    {
        NSLog( @"pressed photo library" );
        UIImagePickerController *pickImage = [[UIImagePickerController alloc] init];
        pickImage.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        pickImage.delegate = self;
        [self presentViewController:pickImage animated:YES completion:nil];
    }
    if( buttonIndex == 2 )
        NSLog( @"pressed cancel" );
        
}

//- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    if( buttonIndex == 0)
//        NSLog( @"pressed cancel" );
//    else if( buttonIndex == 1 )
//    {
//        NSLog( @"pressed camera" );
//        UIAlertView *cameraAlert = [[UIAlertView alloc] initWithTitle:@"Simulator Error" message:@"Simulator does not allow the camera to be used" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles: nil];
//
//        [cameraAlert show];
////        UIImagePickerController *takePhoto = [[UIImagePickerController alloc] init];
////    
////        takePhoto.delegate = self;
////        takePhoto.allowsEditing = YES;
////        takePhoto.sourceType = UIImagePickerControllerSourceTypeCamera;
////        [self presentViewController:takePhoto animated:YES completion:nil];
//    }
//    else if ( buttonIndex == 2 )
//    {
//        NSLog( @"pressed photo Library" );
//        UIImagePickerController *pickImage = [[UIImagePickerController alloc] init];
//        pickImage.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//        pickImage.delegate = self;
//        [self presentViewController:pickImage animated:YES completion:nil];
//    }
//}

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{

    
    self.stepImage.image = [info objectForKey: UIImagePickerControllerOriginalImage];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    

//    NSLog( @"image desc: %@", self.stepImage.isAnimating );
//    NSURL *imageURL = [info objectForKey:UIImagePickerControllerReferenceURL];
//    [self.library assetForURL:imageURL resultBlock:^(ALAsset *asset){
//
//        ALAssetRepresentation *r = [asset defaultRepresentation];
//        self.stepImage.image = [UIImage imageWithCGImage: r.fullResolutionImage];
//        
//    }failureBlock:nil];
    
    
    
    
    
}


- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    CLLocation *currentLocation = newLocation;

    NSLog(@"Users Longitude %@", @(currentLocation.coordinate.longitude));
    NSLog(@"Users Latitude  %@", @(currentLocation.coordinate.latitude));

    self.userLong = currentLocation.coordinate.longitude;
    self.userLat = currentLocation.coordinate.latitude;
}


- (void) textFieldDidBeginEditing:(UITextField *)textField
{
    NSLog( @"text field did begin editing" );
}


- (void) textFieldDidEndEditing:(UITextField *)textField
{
    NSLog( @"text field did end editing" );
    NSLog( @"hunt Title: %@", self.huntTitle.text );
}

- (void) textViewDidBeginEditing:(UITextView *)textView
{
    NSLog( @"text view did begin editing" );
}

-(void) textViewDidEndEditing:(UITextView *)textView
{
    NSLog( @"done editing text view" );
    NSLog( @"step description: %@", self.stepDesc.text );
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}






//#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
//}


@end
