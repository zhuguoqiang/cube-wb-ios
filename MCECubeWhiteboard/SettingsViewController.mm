//
//  SettingsViewController.m
//  VideoChat
//
//  Created by DuanWeiwei on 14-7-18.
//  Copyright (c) 2014年 DuanWeiwei. All rights reserved.
//

#import "SettingsViewController.h"
//#import "SipEngineManager.h"

@interface SettingsViewController ()
@property (strong, nonatomic) IBOutlet UIButton *btnBack;

@end

@implementation SettingsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)SetEnableVideo:(UISwitch *)sender {
//    [[SipEngineManager instance] EnableVideo:[sender isOn]];
}
- (IBAction)btnBackAction:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (IBAction)selectVideoSize:(id)sender {
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:@"选择视频尺寸"
                                  delegate:self
                                  cancelButtonTitle:@"取消"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:@"QCIF 176x144", @"QVGA 320x240",@"CIF 352x288",@"VGA 640x480",@"HD 960x720",@"WHD 1280x720",nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [actionSheet showInView:self.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
//    SipEngine *the_sip_engine = [SipEngineManager getSipEngine];
//    
//    if (buttonIndex == 0) {
//        [mBtnVideoSize setTitle:@"QCIF" forState:UIControlStateNormal];
//        [mStatusLabel setText:@"视频尺寸 QCIF 176x144"];
//        the_sip_engine->SetVideoSize(QCIF);
//        the_sip_engine->SetVideoSendRate(128);
//    }else if (buttonIndex == 1) {
//        [mBtnVideoSize setTitle:@"QVGA" forState:UIControlStateNormal];
//        [mStatusLabel setText:@"视频尺寸 QVGA 320x240"];
//        the_sip_engine->SetVideoSize(QVGA);
//        the_sip_engine->SetVideoSendRate(256);
//    }else if (buttonIndex == 2) {
//        [mBtnVideoSize setTitle:@"CIF" forState:UIControlStateNormal];
//        [mStatusLabel setText:@"视频尺寸 CIF 352x288"];
//        the_sip_engine->SetVideoSize(CIF);
//        the_sip_engine->SetVideoSendRate(384);
//    }else if(buttonIndex == 3) {
//        [mBtnVideoSize setTitle:@"VGA" forState:UIControlStateNormal];
//        [mStatusLabel setText:@"视频尺寸 VGA 640x480"];
//        the_sip_engine->SetVideoSize(VGA);
//        the_sip_engine->SetVideoSendRate(512);
//    }else if(buttonIndex == 4) {
//        [mBtnVideoSize setTitle:@"HD" forState:UIControlStateNormal];
//        [mStatusLabel setText:@"视频尺寸 HD 960x720"];
//        the_sip_engine->SetVideoSendRate(768);
//        the_sip_engine->SetVideoSize(HD);
//    }else if(buttonIndex == 5) {
//        [mBtnVideoSize setTitle:@"WHD" forState:UIControlStateNormal];
//        [mStatusLabel setText:@"视频尺寸 WHD 1280x720"];
//        the_sip_engine->SetVideoSize(WHD);
//        the_sip_engine->SetVideoSendRate(1024);
//    }
//    
}
@end
