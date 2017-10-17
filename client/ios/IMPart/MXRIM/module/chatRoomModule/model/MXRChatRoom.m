//
//  MXRChatRoom.m
//  huashida_home
//
//  Created by Martin.Liu on 2017/9/21.
//  Copyright © 2017年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import "MXRChatRoom.h"

@implementation MXRChatRoom

+ (NSDictionary<NSString *,id> *)mxr_modelCustomPropertyMapper
{
    return @{@"chatRoomId":@"UUID"};
}

@end
