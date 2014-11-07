//
//  ImageMeta.h
//  VideoChat
//
//  Created by Ambrose Xu on 14-8-7.
//  Copyright (c) 2014年 Ambrose Xu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ImageMetaTracker : NSObject

@property (nonatomic, assign) NSUInteger state;

@end


@interface ImageMeta : NSObject

- (id)initWithData:(NSData *)imageData peer:(NSString *)peer;

- (id)initWithSegment:(NSUInteger)fileSize segmentNum:(NSUInteger)segmentNum;

- (UIImage *)outputImage;

@property (nonatomic, strong) NSString *peer;
@property (nonatomic, assign) NSUInteger fileSize;
@property (nonatomic, strong) NSMutableArray *dataSegments;
@property (nonatomic, strong) NSMutableArray *transferTrackers;

@end
