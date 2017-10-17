//
//  NSString+IMMessageUUID.m
//  huashida_home
//
//  Created by Martin.Liu on 2017/10/15.
//  Copyright © 2017年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import "NSString+IMMessageUUID.h"

@implementation NSString (IMMessageUUID)

+ (NSString *)IMmessageUUID
{
    CFUUIDRef uuid = CFUUIDCreate(NULL);
    CFStringRef string = CFUUIDCreateString(NULL, uuid);
    CFRelease(uuid);
    return (__bridge_transfer NSString *)string;
}

@end
