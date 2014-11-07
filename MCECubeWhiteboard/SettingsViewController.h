//
//  SettingsViewController.h
//  VideoChat
//
//  Created by DuanWeiwei on 14-7-18.
//  Copyright (c) 2014年 DuanWeiwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsViewController : UIViewController <UIActionSheetDelegate>
{
 IBOutlet UIButton *mBtnVideoSize;
 IBOutlet UILabel *mStatusLabel;
 IBOutlet UISwitch *mVideoEnabled;
}

@end
