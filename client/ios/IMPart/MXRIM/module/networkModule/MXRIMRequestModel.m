//
//  MXRIMRequestModel.m
//  huashida_home
//
//  Created by Martin.Liu on 2017/9/29.
//  Copyright © 2017年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import "MXRIMRequestModel.h"

@implementation MXRIMRequestModel

@end

@implementation MXRGetChatRoomSortListR

@end

@implementation MXRGetLastChatRoomMessageR

@end

@implementation MXRJoinInChatRoomR

@end

@implementation MXRGetUserInfoListInRoomR

@end

//@implementation MXRCheckIsFriendR
//
//@end

//@implementation MXRCheckIsExistInvitationR
//
//@end

@implementation MXRGetUsersFriendShipR

@end

@implementation MXRSendFriendInvitationR

@end

@implementation MXRGetEarlierChatRoomMessageR

@end

@implementation MXRCreateFirendShipWithUsersR

@end

@implementation MXRGetReceiveInvitationsR

@end

@implementation MXRAcceptFriendInvitationR

@end

@implementation MXRGetFriendListUserInfoR

@end

@implementation MXRGetEarlierP2PChatMessageR

@end

@implementation MXRGetLastP2PChatMessageR

@end

@implementation MXRAddP2PChatMessageR

- (void)setContent:(NSString *)content
{
    if ([content isKindOfClass:[NSString class]]) {
        _content = [content stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
    }
    else
        _content = content;
}

@end

@implementation MXRDeleteP2PChatMessageR

@end
