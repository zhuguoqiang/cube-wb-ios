//
//  whiteBoardWorker.m
//  MCECubeWhiteboard
//
//  Created by 朱国强 on 14-10-23.
//  Copyright (c) 2014年 MCECube. All rights reserved.
//

#import "whiteBoardWorker.h"
#import "TouchVGViewController.h"

@implementation whiteBoardWorker

+ (whiteBoardWorker *)sharedInstance
{
    static dispatch_once_t pred = 0;
    __strong static whiteBoardWorker *_shareWBWorker = nil;
    dispatch_once(&pred, ^{
        _shareWBWorker = [[self alloc]init];
    });
    return _shareWBWorker;
    
}

- (TouchVGViewController *)startWithMyCallId:(NSString *)myCall andPeerCallId:(NSString *)peerCallId
{
    TouchVGViewController *touchVGVC = [[TouchVGViewController alloc]initWithNibName:@"TouchVGViewController" bundle:nil];
    touchVGVC.myCallId = myCall;
    touchVGVC.peerCallId = peerCallId;
    return touchVGVC;
}

- (TouchVGViewController *)answterWhiteBoardWithPeerId:(NSString *)peerId
{
    TouchVGViewController *touchVGVC = [[TouchVGViewController alloc]initWithNibName:@"TouchVGViewController" bundle:nil];
    touchVGVC.myCallId = self.myCallId;
    touchVGVC.peerCallId = peerId;
    return touchVGVC;
}

- (void)stop
{
    
}
@end
