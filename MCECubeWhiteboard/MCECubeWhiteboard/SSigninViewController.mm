//
//  SSigninViewController.m
//  MCECubeWhiteboard
//
//  Created by 朱国强 on 14-10-21.
//  Copyright (c) 2014年 MCECube. All rights reserved.
//

#import "SSigninViewController.h"
#import "TouchVGViewController.h"


@interface SSigninViewController ()
@property (strong, nonatomic) IBOutlet UITextField *tfPeerName;
@property (strong, nonatomic) IBOutlet UITextField *tfMyName;
@property (strong, nonatomic) IBOutlet UIButton *btnSignin;

@end

UIViewController *createTestView(CGRect frame);

@implementation SSigninViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnSigninAction:(id)sender {

//    UIViewController *controller = nil;
    TouchVGViewController *touchVGVC = [[TouchVGViewController alloc]initWithNibName:@"TouchVGViewController" bundle:nil];
    touchVGVC.myCallId = self.tfMyName.text;
    touchVGVC.peerCallId = self.tfPeerName.text;
//    controller = createTestView(touchVGVC.contentView.bounds);
    
    [self presentViewController:touchVGVC animated:YES completion:^{
//        touchVGVC.content = controller;
    }];
}

#pragma mark UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if (interfaceOrientation == UIInterfaceOrientationLandscapeLeft
        || interfaceOrientation == UIInterfaceOrientationLandscapeRight)
    {
        return YES;
    }
    else
    {
        return YES;
    }
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}

- (BOOL)shouldAutorotate
{
    return NO;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
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
