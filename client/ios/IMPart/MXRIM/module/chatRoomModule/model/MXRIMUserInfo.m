//
//  MXRIMUserInfo.m
//  huashida_home
//
//  Created by Martin.Liu on 2017/9/30.
//  Copyright © 2017年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import "MXRIMUserInfo.h"

@implementation MXRIMUserInfo

- (NSString *)userSexString
{
    return self.userSex == 1 ? @"男" : @"女";
}

@end
