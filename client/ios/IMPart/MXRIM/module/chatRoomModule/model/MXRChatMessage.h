//
//  MXRChatMessage.h
//  huashida_home
//
//  Created by Martin.Liu on 2017/9/22.
//  Copyright © 2017年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+MXRModel.h"
#import "JSQMessages.h"
#import "MXRChatSocketMessage.h"
#import "MXRIMMessage.h"
#import "MXRIMRequestModel.h"

typedef NS_ENUM(NSInteger, MXRIMMessageStatus) {
    MXRIMMessageStatusNormal = 0,
    MXRIMMessageStatusDelete = 1,
    MXRIMMessageStatusSending = 10001,
    MXRIMMessageStatusResending = 10002,
    MXRIMMessageStatusSendFailure = 10003,
    
};
@interface MXRChatMessage : MXRIMMessage<MXRModelDelegate>

@property (nonatomic, strong) NSString *chatMessageId;
@property (nonatomic, strong) NSString *chatRoomId;
@property (nonatomic, assign) NSInteger userId;

@property (nonatomic, strong) NSString *userName;

- (JSQMessage *)buildJSQMessage;

@end

@interface MXRP2PChatMessage : MXRIMMessage<MXRModelDelegate>

@property (nonatomic, strong) NSString *messageId;
//@property (nonatomic, assign) NSInteger mySenderId;     // 用self.senderId
@property (nonatomic, strong) NSString *receiveUserName;

@property (nonatomic, assign) NSInteger receiverId;

- (void)prepareToSend;

- (void)prepareToResend;
/**
 need called before @select(prepareToSend) action
 */
- (MXRP2PChatSocketMessage *)buildP2pChatSocketMessage;
- (MXRAddP2PChatMessageR *)buildAddP2PChatMessageR;
@end
