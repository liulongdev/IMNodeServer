//
//  MXRChatSocketMessage.h
//  huashida_home
//
//  Created by Martin.Liu on 2017/9/21.
//  Copyright © 2017年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MXRSocketMessage.h"
typedef NS_ENUM(NSInteger, MXRChatContentType) {
    MXRChatContentType_Text = 0,
    MXRChatContentType_Picture = 1,
    MXRChatContentType_Audio ,
    MXRChatContentType_Video,
    MXRChatContentType_Location,
};


@interface MXRChatSocketMessage : MXRSocketMessage


@end

@interface MXRChatRoomSocketMessage : MXRChatSocketMessage

@property (nonatomic, strong) NSString *messageUUID;
@property (nonatomic, assign) NSString *chatRoomId;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, assign) NSInteger contentType;

- (instancetype)initWithChatRoomId:(NSString *)chatRoomId contentType:(MXRChatContentType)contentType content:(NSString *)content type:(NSString *)type;

- (instancetype)initWithUUID:(NSString *)UUID chatRoomId:(NSString *)chatRoomId contentType:(MXRChatContentType)contentType content:(NSString *)content type:(NSString *)type;

@end

@interface MXRP2PChatSocketMessage : MXRChatSocketMessage

@property (nonatomic, strong) NSString *messageUUID;
@property (nonatomic, assign) NSInteger receiveUserId;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, assign) NSInteger contentType;

- (instancetype)initWithReceiveUserId:(NSInteger)receiveUserId contentType:(MXRChatContentType)contentType content:(NSString *)content type:(NSString *)type;

- (instancetype)initWithUUID:(NSString *)UUID receiveUserId:(NSInteger)receiveUserId contentType:(MXRChatContentType)contentType content:(NSString *)content type:(NSString *)type;

@end
