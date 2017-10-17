//
//  MXRSocketMessage.m
//  huashida_home
//
//  Created by Martin.Liu on 2017/9/21.
//  Copyright © 2017年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import "MXRSocketMessage.h"

@implementation MXRSocketMessage

- (instancetype)initWithType:(NSString *)type
{
    self = [super init];
    if (!self) return nil;
    _userId = [UserInformation modelInformation].userID;
    _type = type;
    return self;
}

@end
