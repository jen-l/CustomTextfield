//
//  ViewController.m
//  CustomTextfield
//
//  Created by Jenelle Walker on 12/15/14.
//  Copyright (c) 2014 Jenelle Walker. All rights reserved.
//

#import "ViewController.h"
#import "CTextField.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet CTextField *textField;
@property (weak, nonatomic) IBOutlet UITextField *regTextField;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [CTextField setAllTextfieldsUnderlineImage:[UIImage imageNamed:@"underline"] forViewController:self];
    [self.textField setMessageAlignment:CMessageAlignmentCenter];
    [self.textField setMessageColor:[UIColor blackColor]];
    [self.textField setUnderlineErrorColor:[UIColor redColor]];
    [self.textField setMessageFont:[UIFont fontWithName:@"Courier" size:15]];
    [self.textField setMessageDropShadowColor:[UIColor whiteColor]];
    [self.textField setHasValidationErrorWithCustomString:@"not an email address"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
