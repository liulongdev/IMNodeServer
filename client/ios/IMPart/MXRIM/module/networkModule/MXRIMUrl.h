//
//  MXRIMUrl.h
//  huashida_home
//
//  Created by Martin.Liu on 2017/9/26.
//  Copyright © 2017年 苏州梦想人软件科技有限公司. All rights reserved.
//

#ifndef MXRIMUrl_h
#define MXRIMUrl_h

#define SERVER_SOCKET_HOST @"192.168.2.3"
#define SERVER_SOCKET_PORT @"8181"
#define SERVER_EXPRESS_HOST SERVER_SOCKET_HOST
#define SERVER_EXPRESS_PORT @"3000"

//#define MXRURLStringCat(_host_, _serviceurl_)     [[NSURL URLWithString:_serviceurl_ relativeToURL:[NSURL URLWithString:_host_]] absoluteString]

#define CHATSERVER [NSString stringWithFormat:@"http://%@:%@", SERVER_EXPRESS_HOST, SERVER_EXPRESS_PORT]
#define CHATURL_GetChatRoomList @"/core/chat/v1/getChatRoomList"
#define CHATURL_GetChatMessageWithRoomId @"/core/chat/v1/getMessagesWithRoomId"
#define CHATURL_GetChatMessagesByPage @"/core/chat/v1/getChatRoomMessages"    // page
#define CHATURL_JoinInRoom      @"/core/chat/v1/joinToChatRoom"
#define CHATURL_GetChatRoomSortList @"/core/chat/v1/getChatRoomSortList" 
#define CHATURL_GetCUserInfoListInRoom @"/core/chat/v1/getUserInfoListInRoom"
#define CHATURL_GetFriendshipBetweenUsers @"/core/chat/v1/getFriendshipBetweenUsers"
#define CHATURL_SendFriendInvitation @"/core/chat/v1/sendFriendInvitation"  // 发送好友邀请
#define CHATURL_CreateFriendShip @"/core/chat/v1/createFriendShip"          // 建立好友关系
#define CHATURL_GetReceiveInvitations @"/core/chat/v1/getReceiveInvitations"  // 获取某个人被好友邀请的列表
#define CHATURL_AcceptFriendInvitation @"/core/chat/v1/acceptFriendInvitation"  // 接受好友邀请
#define CHATURL_GetFriendListUserInfo @"/core/chat/v1/getFriendListUserInfo"  // 获取某个用户的所有好友信息列表
#define CHATURL_GetEarlierP2PChatMessages @"/core/chat/v1/getEarlierP2PChatMessages"    // 获取历史的P2P聊天记录
#define CHATURL_GetLastP2PChatMessages  @"/core/chat/v1/getLastP2PChatMessages" // 获取历史的P2P聊天记录
#define CHATURL_AddP2PChatMessage  @"/core/chat/v1/addP2PChatMessage" // 增加P2P聊天记录
#define CHATURL_DeleteP2PChatMessage  @"/core/chat/v1/deleteP2PChatMessage" // 删除某一条P2P聊天记录

#endif /* MXRIMUrl_h */
