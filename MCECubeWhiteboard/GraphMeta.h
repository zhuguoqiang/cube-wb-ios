//
//  GraphMeta.h
//  VideoChat
//
//  Created by Ambrose Xu on 14-7-25.
//  Copyright (c) 2014年 Ambrose Xu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GraphMeta : NSObject

- (id)initWithJSON:(NSDictionary *)json;

@property (nonatomic, strong) NSDictionary *begin;
@property (nonatomic, strong) NSDictionary *end;
@property (nonatomic, strong) NSMutableArray *path;

- (NSString *)toJSONString;

@end
