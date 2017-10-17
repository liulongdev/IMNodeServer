//
//  MXRSocketMacro.m
//  huashida_home
//
//  Created by Martin.Liu on 2017/9/26.
//  Copyright © 2017年 苏州梦想人软件科技有限公司. All rights reserved.
//

NSString * const MXRNOTIFICATION_ADDUGC             = @"MXRNOTIFICATION_ADDUGC";
NSString * const MXRNOTIFICATION_CONNETING          = @"MXRNOTIFICATION_CONNETING";
NSString * const MXRNOTIFICATION_SOCKETOPEN         = @"MXRNOTIFICATION_SOCKETOPEN";
NSString * const MXRNOTIFICATION_SOCKETOPENBYUSERID = @"MXRNOTIFICATION_SOCKETOPENBYUSERID";
NSString * const MXRNOTIFICATION_SOCKETCLOSE        = @"MXRNOTIFICATION_SOCKETCLOSE";

NSString * const MXRNOTIFICATION_CHATROOMMESSAGE    = @"MXRNOTIFICATION_CHATROOMMESSAGE";
NSString * const MXRNOTIFICATION_P2PCHATMESSAGE    = @"MXRNOTIFICATION_P2PCHATMESSAGE";


// 对外广播的类型
// 书本相关
NSString * const MXRSocketType_ADDUGC_URL           = @"ADDUGC_URL";        // 广播添加URL的UGC
NSString * const MXRSocketType_ADDUGC_AUDIO         = @"ADDUGC_AUDIO";      // 广播添加音频的UGC
NSString * const MXRSocketType_ADDUGC_VIDEO         = @"ADDUGC_VIDEO";      // 广播添加视频的UGC
NSString * const MXRSocketType_ADDUGC_FACEVIDEO     = @"BroadCastType_ADDUGC_FACEVIDEO";    // 广播添加小视频的UGC
NSString * const MXRSocketType_ADDUGC_PIC           = @"ADDUGC_PIC";        // 广播添加图片的UGC
NSString * const MXRSocketType_ADDUGC_NEWPAGE       = @"ADDUGC_NEWPAGE";    // 广播添加页面的UGC
NSString * const MXRSocketType_ADDUGC_COMMENT       = @"ADDUGC_COMMENT";    // 广播添加文字的UGC
NSString * const MXRSocketType_SynchronizeDummy     = @"Synchronize4DModel";      // 广播同步3D模型

NSString * const MXRSocketType_SendUserId         = @"Socket_SendUserId"; // 发送userId
// 聊天相关
NSString * const MXRSocketType_ChatRoom_JoinChatRoom         = @"ChatRoom_JoinChatRoom"; // 添加到聊天室
NSString * const MXRSocketType_ChatRoom_SendChatRoomMessage  = @"ChatRoom_SendChatRoomMessage"; // 发送聊天室聊天内容

NSString * const MXRSocketType_P2PChat_SendChatMessage  = @"P2PChat_SendChatMessage"; // 发送聊天记录


#import "MXRSocketMacro.h"


