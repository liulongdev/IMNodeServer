//
//  MXRChatSocketMessage.m
//  huashida_home
//
//  Created by Martin.Liu on 2017/9/21.
//  Copyright © 2017年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import "MXRChatSocketMessage.h"
#import "NSString+IMMessageUUID.h"
@implementation MXRChatSocketMessage


@end

@implementation MXRChatRoomSocketMessage

- (instancetype)initWithChatRoomId:(NSString *)chatRoomId contentType:(MXRChatContentType)contentType content:(NSString *)content type:(NSString *)type
{
    self = [super initWithType:type];
    if (!self) return nil;
    _chatRoomId = chatRoomId;
    _contentType = contentType;
    _content = content;
    return self;
}

- (instancetype)initWithUUID:(NSString *)UUID chatRoomId:(NSString *)chatRoomId contentType:(MXRChatContentType)contentType content:(NSString *)content type:(NSString *)type
{
    self = [super initWithType:type];
    if (!self) return nil;
    _messageUUID = UUID;
    _chatRoomId = chatRoomId;
    _contentType = contentType;
    _content = content;
    return self;
}

@end

@implementation MXRP2PChatSocketMessage
- (instancetype)initWithReceiveUserId:(NSInteger)receiveUserId contentType:(MXRChatContentType)contentType content:(NSString *)content type:(NSString *)type
{
    self = [super initWithType:type];
    if (!self) return nil;
    _receiveUserId = receiveUserId;
    _contentType = contentType;
    _content = content;
    return self;
}

- (instancetype)initWithUUID:(NSString *)UUID receiveUserId:(NSInteger)receiveUserId contentType:(MXRChatContentType)contentType content:(NSString *)content type:(NSString *)type
{
    self = [super initWithType:type];
    if (!self) return nil;
    _messageUUID = UUID;
    _receiveUserId = receiveUserId;
    _contentType = contentType;
    _content = content;
    return self;
}

@end
