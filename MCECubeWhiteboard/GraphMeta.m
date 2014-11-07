//
//  GraphMeta.m
//  VideoChat
//
//  Created by Ambrose Xu on 14-7-25.
//  Copyright (c) 2014年 Ambrose Xu. All rights reserved.
//

#import "GraphMeta.h"

@implementation GraphMeta

- (id)init
{
    self = [super init];
    if (self)
    {
        self.path = [[NSMutableArray alloc] initWithCapacity:10];
    }

    return self;
}

- (id)initWithJSON:(NSDictionary *)json
{
    self = [super init];
    if (self)
    {
        NSDictionary *begin = [json objectForKey:@"begin"];
        self.begin = [NSDictionary dictionaryWithDictionary:begin];
        
        NSDictionary *end = [json objectForKey:@"end"];
        self.end = [NSDictionary dictionaryWithDictionary:end];

        NSArray *path = [json objectForKey:@"path"];
        self.path = [[NSMutableArray alloc] initWithArray:path];
    }

    return self;
}

- (void)dealloc
{
    [self.path removeAllObjects];
    self.path = nil;
}

- (NSString *)toJSONString
{
    // 起点
    NSNumber *x = [self.begin valueForKey:@"x"];
    NSNumber *y = [self.begin valueForKey:@"y"];
    NSString *beginJSON = [NSString stringWithFormat:@"{\"x\":%.2f,\"y\":%.2f}", [x floatValue], [y floatValue]];
    
    // 路径点
    NSData *pathData = [NSJSONSerialization dataWithJSONObject:self.path options:NSJSONWritingPrettyPrinted error:nil];
    NSString *pathJSON = [[NSString alloc] initWithData:pathData encoding:NSUTF8StringEncoding];
    
    // 终点
    x = [self.end valueForKey:@"x"];
    y = [self.end valueForKey:@"y"];
    NSString *endJSON = [NSString stringWithFormat:@"{\"x\":%.2f,\"y\":%.2f}", [x floatValue], [y floatValue]];

    NSString *ret = [NSString stringWithFormat:@"{\"begin\":%@, \"end\":%@, \"path\":%@}"
                     , beginJSON, endJSON, pathJSON];
    return ret;
}

@end
