//
//  TouchVGViewController.h
//  VideoChat
//
//  Created by DuanWeiwei on 14-7-17.
//  Copyright (c) 2014年 DuanWeiwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Cell.h"

@interface TouchVGViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate, CCTalkListener, CCActionDelegate>

@property (nonatomic, strong) UIViewController *content;

@property (nonatomic, strong) NSString *myCallId;

@property (nonatomic, strong) NSString *peerCallId;

@property (strong, nonatomic) IBOutlet UIButton *btnCamera;

@property (strong, nonatomic) IBOutlet UIButton *btnSetting;

@property (strong, nonatomic) IBOutlet UIButton *btnRedPencil;

@property (strong, nonatomic) IBOutlet UIButton *btnBlackPencil;

@property (strong, nonatomic) IBOutlet UIButton *btnBluePencil;

@property (strong, nonatomic) IBOutlet UIButton *btnBrownPencil;

@property (strong, nonatomic) IBOutlet UIButton *btnDarkGreenPencil;

@property (strong, nonatomic) IBOutlet UIButton *btnGreyPencil;
@property (strong, nonatomic) IBOutlet UIButton *btnDarkOrange;

@property (strong, nonatomic) IBOutlet UIButton *btnLightBluePencil;

@property (strong, nonatomic) IBOutlet UIButton *btnLightGreenPencil;

@property (strong, nonatomic) IBOutlet UIButton *btnYellowPencil;

@property (strong, nonatomic) IBOutlet UIButton *btnEraser;

@property (strong, nonatomic) IBOutlet UIButton *btnBack;

- (IBAction)back:(id)sender;

- (IBAction)clear:(id)sender;

- (IBAction)pickImage:(id)sender;

@end
