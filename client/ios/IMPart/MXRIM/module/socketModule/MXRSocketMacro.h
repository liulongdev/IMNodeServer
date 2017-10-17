//
//  MXRSocketMacro.h
//  huashida_home
//
//  Created by Martin.Liu on 2017/9/26.
//  Copyright © 2017年 苏州梦想人软件科技有限公司. All rights reserved.
//

extern NSString * const MXRNOTIFICATION_ADDUGC;            // 发送增加URG的通知
extern NSString * const MXRNOTIFICATION_CONNETING;         // 发送正在尝试连接Socket的通知
extern NSString * const MXRNOTIFICATION_SOCKETOPEN;        // 发送连接Socket成功的通知
extern NSString * const MXRNOTIFICATION_SOCKETOPENBYUSERID; // 发送socket已与socket绑定的通知
extern NSString * const MXRNOTIFICATION_SOCKETCLOSE;       // 发送正在关闭Socket的通知

extern NSString * const MXRNOTIFICATION_CHATROOMMESSAGE;   // 发送关于聊天室的通知
extern NSString * const MXRNOTIFICATION_P2PCHATMESSAGE;     // 发送P2P聊天消息

extern NSString * const MXRSocketType_ADDUGC_URL;           // 广播添加URL的UGC
extern NSString * const MXRSocketType_ADDUGC_AUDIO;         // 广播添加音频的UGC
extern NSString * const MXRSocketType_ADDUGC_VIDEO;         // 广播添加视频的UGC
extern NSString * const MXRSocketType_ADDUGC_FACEVIDEO;     // 广播添加小视频的UGC
extern NSString * const MXRSocketType_ADDUGC_PIC;           // 广播添加图片的UGC
extern NSString * const MXRSocketType_ADDUGC_NEWPAGE;       // 广播添加页面的UGC
extern NSString * const MXRSocketType_ADDUGC_COMMENT;       // 广播添加文字的UGC
extern NSString * const MXRSocketType_SynchronizeDummy;     // 广播同步3D模型

extern NSString * const MXRSocketType_SendUserId; // 发送userId
// 聊天相关
extern NSString * const MXRSocketType_ChatRoom_JoinChatRoom; // 添加到聊天室
extern NSString * const MXRSocketType_ChatRoom_SendChatRoomMessage; // 发送聊天室聊天内容
extern NSString * const MXRSocketType_P2PChat_SendChatMessage; // 发送聊天室聊天内容
#import "MXRIMUrl.h"
