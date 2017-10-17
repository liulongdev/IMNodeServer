//
//  MXRIMResponseModel.m
//  huashida_home
//
//  Created by Martin.Liu on 2017/9/29.
//  Copyright © 2017年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import "MXRIMResponseModel.h"

@implementation MXRIMResponseModel

@end

@implementation MXRChatRoomSortList

+ (NSDictionary<NSString *,id> *)mxr_modelCustomPropertyMapper
{
    return @{@"hasJoinedChatRoomArray":@"hasJoinedRoomList",
             @"otherChatRoomArray":@"notJoinedRoomList"
             };
}

+ (NSDictionary<NSString *,id> *)mxr_modelContainerPropertyGenericClass
{
    return @{@"hasJoinedChatRoomArray":[MXRChatRoom class],
             @"otherChatRoomArray":[MXRChatRoom class]
             };
}

@end

