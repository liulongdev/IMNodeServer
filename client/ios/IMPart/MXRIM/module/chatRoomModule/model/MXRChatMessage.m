//
//  MXRChatMessage.m
//  huashida_home
//
//  Created by Martin.Liu on 2017/9/22.
//  Copyright © 2017年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import "MXRChatMessage.h"
#import "NSString+Ex.h"
#import "NSString+IMMessageUUID.h"
#import "MXRSocketManager.h"

@implementation MXRChatMessage

+ (NSDictionary<NSString *,id> *)mxr_modelCustomPropertyMapper
{
    return @{@"chatMessageId": @"UUID",
             @"userName": @[@"userNickName", @"userName"],
             @"createTime": @"createTime2",
             @"updateTime": @"updateTime2"
             };
}

- (JSQMessage *)buildJSQMessage
{
    NSString *displayName = self.userName;
    if ([NSString isBlankString:displayName]) {
        if ([[UserInformation modelInformation].userID integerValue] == self.userId) {
            displayName = [UserInformation modelInformation].userNickName;
        }
        if ([NSString isBlankString:displayName])
            displayName =[NSString stringWithFormat:@"%@", self.userName ?: [NSString stringWithFormat:@"%ld", (long)self.userId]];
    }
    displayName = displayName ?: @"";
    JSQMessage *message = [[JSQMessage alloc] initWithSenderId:[NSString stringWithFormat:@"%ld", (long)self.userId] senderDisplayName:displayName date:self.createTime text:self.content];
    return message;
}

- (NSString *)senderDisplayName
{
    if ([_userName isKindOfClass:[NSString class]] && [_userName length] > 0) {
        return _userName;
    }
    if ([self.senderId isEqualToString:[UserInformation modelInformation].userID]) {
        return [UserInformation modelInformation].userNickName ?: @"我";
    }
    return @"昵称";
}

@end

@interface MXRP2PChatMessage()

@end

@implementation MXRP2PChatMessage

//@synthesize senderId = _senderId;
//@synthesize senderDisplayName = _senderDisplayName;
//@synthesize date = _date;


+ (NSDictionary<NSString *,id> *)mxr_modelCustomPropertyMapper
{
    return @{@"chatMessageId": @"UUID",
             @"messageUUID": @"UUID",
             @"receiveUserName": @[@"userNickName", @"userName"],
             @"createTime": @"createTime2",
             @"updateTime": @"updateTime2"
             };
}

- (NSString *)senderDisplayName
{
    if ([self.senderId isEqualToString:[UserInformation modelInformation].userID]) {
        return [UserInformation modelInformation].userNickName ?: @"我";
    }
    return self.receiveUserName ?: @"昵称";
}

- (void)prepareToSend
{
    self.status = MXRIMMessageStatusSending;
    NSDate *nowDate = [NSDate date];
//    if (_date == nil) {
//        _date = nowDate;
//    }
    self.createTime = self.updateTime = nowDate;
    self.messageUUID = [NSString IMmessageUUID];
}

- (void)prepareToResend
{
    self.status = MXRIMMessageStatusResending;
    NSDate *nowDate = [NSDate date];
    self.createTime = self.updateTime = nowDate;
}

- (MXRP2PChatSocketMessage *)buildP2pChatSocketMessage
{
    MXRP2PChatSocketMessage *p2pChatSocketMessage = [[MXRP2PChatSocketMessage alloc] initWithUUID:self.messageUUID receiveUserId:self.receiverId contentType:MXRChatContentType_Text content:[self text] type:MXRSocketType_P2PChat_SendChatMessage];
    return p2pChatSocketMessage;
}

- (MXRAddP2PChatMessageR *)buildAddP2PChatMessageR
{
    MXRAddP2PChatMessageR *addP2PChatMessageR = [MXRAddP2PChatMessageR new];
    addP2PChatMessageR.messageUUID = self.messageUUID;
    addP2PChatMessageR.userId = [self.senderId integerValue];
    addP2PChatMessageR.receiveUserId = self.receiverId;
    addP2PChatMessageR.content = [self text];
    return addP2PChatMessageR;
}

- (JSQMessage *)buildJSQMessage
{
    NSString *displayName = self.receiveUserName;
    if ([NSString isBlankString:self.receiveUserName]) {
        if ([UserInformation modelInformation].userID == self.senderId) {
            displayName = [UserInformation modelInformation].userNickName;
            if ([NSString isBlankString:self.receiveUserName])
            {
                displayName =[NSString stringWithFormat:@"%@", self.receiveUserName ?: [NSString stringWithFormat:@"%ld", (long)self.senderId]];
            }
        }
    }
    displayName = displayName ?: @"";
    JSQMessage *message = [[JSQMessage alloc] initWithSenderId:self.senderId senderDisplayName:displayName date:self.createTime text:self.content];
    return message;
}

@end
