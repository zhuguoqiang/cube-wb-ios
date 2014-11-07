//
//  whiteBoardWorker.h
//  MCECubeWhiteboard
//
//  Created by 朱国强 on 14-10-23.
//  Copyright (c) 2014年 MCECube. All rights reserved.
//

#import <Foundation/Foundation.h>
@class TouchVGViewController;

@interface whiteBoardWorker : NSObject

@property (nonatomic, strong) NSString *myCallId;

@property (nonatomic, strong) NSString *peerCallId;

+ (whiteBoardWorker *)sharedInstance;

- (TouchVGViewController *)startWithMyCallId:(NSString *)myCall andPeerCallId:(NSString *)peerCallId;

- (TouchVGViewController *)answterWhiteBoardWithPeerId:(NSString *)peerId;

- (void)stop;

@end
