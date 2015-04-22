//
//  ViewController.m
//  CS 470 Hunt
//
//  Created by student on 4/13/15.
//  Copyright (c) 2015 PaulRileyJulian. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIButton *huntsButton;
@property (weak, nonatomic) IBOutlet UIButton *createButton;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self.huntsButton setTitle:@"Hunts" forState:UIControlStateNormal];
    self.huntsButton.layer.borderColor = [UIColor colorWithRed:255.0 green:255.0 blue:255.0 alpha:0.40].CGColor;
        self.createButton.layer.borderColor = [UIColor colorWithRed:255.0 green:255.0 blue:255.0 alpha:0.40].CGColor;
    
}

- (IBAction)didPressHuntsButton:(UIButton *)sender
{
    NSLog( @"Did Press Hunts Button" );
}

- (IBAction)didPressCreateButton:(UIButton *)sender
{
    NSLog( @"Did Press Create Button" );
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
