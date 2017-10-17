//
//  MXRIMRequestModel.h
//  huashida_home
//
//  Created by Martin.Liu on 2017/9/29.
//  Copyright © 2017年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MXRIMRequestModel : NSObject

@end

@interface MXRGetChatRoomSortListR : NSObject

@property (nonatomic, assign) NSInteger userId;

@end

@interface MXRGetLastChatRoomMessageR : NSObject

@property (nonatomic, strong) NSString *chatRoomId;
@property (nonatomic, strong) NSDate *afterDateTime;

@end

@interface MXRJoinInChatRoomR : NSObject

@property (nonatomic, assign) NSInteger userId;
@property (nonatomic, strong) NSString *chatRoomId;
@property (nonatomic, assign) NSInteger status;

@end


@interface MXRGetUserInfoListInRoomR : NSObject

@property (nonatomic, strong) NSString *chatRoomId;
@property (nonatomic, assign) NSInteger pageSize;
@property (nonatomic, assign) NSInteger pageIndex;

@end

//@interface MXRCheckIsFriendR : NSObject
//
//@property (nonatomic, assign) NSInteger userId;
//@property (nonatomic, assign) NSInteger otherUserId;
//
//@end

//@interface MXRCheckIsExistInvitationR : NSObject
//
//@property (nonatomic, assign) NSInteger userId;
//@property (nonatomic, assign) NSInteger invitedUserId;
//
//@end

@interface MXRGetUsersFriendShipR : NSObject

@property (nonatomic, assign) NSInteger userId;
@property (nonatomic, assign) NSInteger otherUserId;

@end

@interface MXRSendFriendInvitationR : NSObject

@property (nonatomic, assign) NSInteger userId;
@property (nonatomic, assign) NSInteger invitedUserId;
@property (nonatomic, strong) NSString *content;

@end

@interface MXRGetEarlierChatRoomMessageR : NSObject

@property (nonatomic, strong) NSString *chatRoomId;
@property (nonatomic, assign) NSInteger pageIndex;
@property (nonatomic, assign) NSInteger pageSize;
@property (nonatomic, strong) NSDate *deadlineDateTime;   // yyyy-MM-dd hh:mm:ss

@end

@interface MXRCreateFirendShipWithUsersR : NSObject

@property (nonatomic, assign) NSInteger firstUserId;
@property (nonatomic, assign) NSInteger secondUserId;

@end

@interface MXRGetReceiveInvitationsR : NSObject

@property (nonatomic, assign) NSInteger invitedUserId;
@property (nonatomic, assign) NSInteger pageIndex;
@property (nonatomic, assign) NSInteger pageSize;

@end

@interface MXRAcceptFriendInvitationR : NSObject

@property (nonatomic, assign) NSInteger invitedUserId;
@property (nonatomic, strong) NSString *invitationUUID;

@end

@interface MXRGetFriendListUserInfoR : NSObject

@property (nonatomic, assign) NSInteger userId;

@end

@interface MXRGetEarlierP2PChatMessageR : NSObject

@property (nonatomic, assign) NSInteger senderId;
@property (nonatomic, assign) NSInteger receiverId;
@property (nonatomic, assign) NSInteger pageIndex;
@property (nonatomic, assign) NSInteger pageSize;
@property (nonatomic, strong) NSDate *deadlineDateTime;   // yyyy-MM-dd hh:mm:ss

@end


@interface MXRGetLastP2PChatMessageR : NSObject

@property (nonatomic, assign) NSInteger senderId;
@property (nonatomic, assign) NSInteger receiverId;
@property (nonatomic, strong) NSDate *afterDateTime;   // yyyy-MM-dd hh:mm:ss

@end

@interface MXRAddP2PChatMessageR : NSObject

@property (nonatomic, strong) NSString *messageUUID;
@property (nonatomic, assign) NSInteger userId;
@property (nonatomic, assign) NSInteger receiveUserId;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, assign) NSInteger contentType;

@end

@interface MXRDeleteP2PChatMessageR : NSObject

@property (nonatomic, strong) NSString *messageUUID;

@end

