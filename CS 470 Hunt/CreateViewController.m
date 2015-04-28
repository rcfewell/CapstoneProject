//
//  CreateViewController.m
//  CS 470 Hunt
//
//  Created by student on 4/27/15.
//  Copyright (c) 2015 PaulRileyJulian. All rights reserved.
//

#import "CreateViewController.h"

@interface CreateViewController ()

@property (weak, nonatomic) IBOutlet UITextField *huntTitle;
@property (weak, nonatomic) IBOutlet UILabel *stepNum;
@property (weak, nonatomic) IBOutlet UIButton *takePicture;
@property (weak, nonatomic) IBOutlet UIImageView *stepImage;
@property (weak, nonatomic) IBOutlet UITextView *stepDesc;
@property (weak, nonatomic) IBOutlet UIButton *submitStep;
@property (weak, nonatomic) IBOutlet UIButton *finishHunt;


@end

@implementation CreateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)takePictureButtonPressed:(UIButton *)sender {
    NSLog(@"Open Camera roll");
    
    UIImagePickerController *pickImage = [[UIImagePickerController alloc] init];
    pickImage.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    pickImage.delegate = self;
    [self presentViewController:pickImage animated:YES completion:nil];
//    [pickImage  release];
    
    ////// USING Camera /////
    
//    UIImagePickerController *takePhoto = [[UIImagePickerController alloc] init];
//    
//    takePhoto.delegate = self;
//    takePhoto.allowsEditing = YES;
//    takePhoto.sourceType = UIImagePickerControllerSourceTypeCamera;
//    [self presentViewController:takePhoto animated:YES completion:nil];
//
}

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
//    [picker release];
    
    self.stepImage.image = [info objectForKey: UIImagePickerControllerOriginalImage];
    
    
    
    
}


- (IBAction)submitStepButtonPressed:(UIButton *)sender {
    NSLog(@"Title = %@", self.huntTitle.text);
    NSLog(@"Description = %@", self.stepDesc.text);
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
