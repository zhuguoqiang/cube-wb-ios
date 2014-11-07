//
//  ImageMeta.m
//  VideoChat
//
//  Created by Ambrose Xu on 14-8-7.
//  Copyright (c) 2014年 Ambrose Xu. All rights reserved.
//

#import "ImageMeta.h"

@implementation ImageMetaTracker

- (id)init
{
    self = [super init];
    if (self)
    {
        self.state = 0;
    }
    return self;
}

@end


@implementation ImageMeta

- (id)init
{
    self = [super init];
    if (self)
    {
        self.fileSize = 0;
        self.dataSegments = [[NSMutableArray alloc] init];
        self.transferTrackers = [[NSMutableArray alloc] init];
    }
    return self;
}

- (id)initWithData:(NSData *)imageData peer:(NSString *)peer
{
    self = [super init];
    if (self)
    {
        self.peer = peer;
        self.fileSize = imageData.length;
        self.dataSegments = [[NSMutableArray alloc] init];
        self.transferTrackers = [[NSMutableArray alloc] init];

        const NSUInteger segmentSize = 14336;//16384;
        NSString *base64str = [imageData base64Encoding];

        NSUInteger strlen = base64str.length;
        if (strlen > segmentSize)
        {
            NSUInteger numSegments = floor(strlen / segmentSize);
            NSUInteger loc = 0;
            for (int i = 0; i < numSegments; ++i)
            {
                NSString *str = [base64str substringWithRange:NSMakeRange(loc, segmentSize)];
                [self.dataSegments addObject:str];
                [self.transferTrackers addObject:[[ImageMetaTracker alloc] init]];
                loc += segmentSize;
            }

            NSUInteger mod = strlen % segmentSize;
            if (mod > 0)
            {
                numSegments += 1;
                NSString *str = [base64str substringWithRange:NSMakeRange(loc, mod)];
                [self.dataSegments addObject:str];
                [self.transferTrackers addObject:[[ImageMetaTracker alloc] init]];
            }
        }
        else
        {
            [self.dataSegments addObject:base64str];
            [self.transferTrackers addObject:[[ImageMetaTracker alloc] init]];
        }

    }
    return self;
}

- (id)initWithSegment:(NSUInteger)fileSize segmentNum:(NSUInteger)segmentNum
{
    self = [super init];
    if (self)
    {
        self.fileSize = fileSize;
        self.dataSegments = [[NSMutableArray alloc] init];
        self.transferTrackers = [[NSMutableArray alloc] init];

        for (int i = 0; i < segmentNum; ++i)
        {
            [self.transferTrackers addObject:[[ImageMetaTracker alloc] init]];
        }
    }
    return self;
}

- (UIImage *)outputImage
{
    NSString *base64 = [self.dataSegments objectAtIndex:0];
    if (self.dataSegments.count > 1)
    {
        for (int i = 1; i < self.dataSegments.count; ++i)
        {
            base64 = [base64 stringByAppendingString:[self.dataSegments objectAtIndex:i]];
        }
    }
    
    NSData *data = [[NSData alloc] initWithBase64EncodedString:base64 options:NSDataBase64DecodingIgnoreUnknownCharacters];
    UIImage *img = [UIImage imageWithData:data];
    return img;
}

@end
