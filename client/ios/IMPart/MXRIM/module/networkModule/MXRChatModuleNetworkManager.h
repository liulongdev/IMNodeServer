//
//  MXRChatModuleNetworkManager.h
//  huashida_home
//
//  Created by Martin.Liu on 2017/9/21.
//  Copyright © 2017年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MXRSocketManager.h"
#import "MXRNetworkResponse.h"
#import "MXRIMRequestModel.h"
#import "MXRIMResponseModel.h"

@interface MXRChatModuleNetworkManager : NSObject

+ (void)getChatRoomListSuccess:(void (^)(MXRNetworkResponse *response))success
                       failure:(void (^)(id error))failure;

+ (void)getChatRoomSortList:(MXRGetChatRoomSortListR *)param
                    success:(void (^)(MXRNetworkResponse *response))success
                    failure:(void (^)(id error))failure;

// 根据时间节点获取最新的消息
+ (void)getLastChatMessages:(MXRGetLastChatRoomMessageR *)param
                    success:(void (^)(MXRNetworkResponse *response))success
                    failure:(void (^)(id error))failure;

// 根据时间节点获取更早的消息
+ (void)getEarlierChatRoomMessages:(MXRGetEarlierChatRoomMessageR *)param
                           success:(void (^)(MXRNetworkResponse *response))success
                           failure:(void (^)(id error))failure;

+ (void)joinInChatRoom:(MXRJoinInChatRoomR *)param
               success:(void (^)(MXRNetworkResponse *response))success
               failure:(void (^)(id error))failure;

+ (void)getUserListInfoRoom:(MXRGetUserInfoListInRoomR *)param
                    success:(void (^)(MXRNetworkResponse *response))success
                    failure:(void (^)(id error))failure;

+ (void)sendFriendInvitation:(MXRSendFriendInvitationR *)param
                     success:(void (^)(MXRNetworkResponse *response))success
                     failure:(void (^)(id error))failure;

+ (void)getFriendshipBetweenUsers:(MXRGetUsersFriendShipR *)param
                          success:(void (^)(MXRNetworkResponse *response))success
                          failure:(void (^)(id error))failure;

+ (void)createFriendShip:(MXRCreateFirendShipWithUsersR *)param
                 success:(void (^)(MXRNetworkResponse *response))success
                 failure:(void (^)(id error))failure;

+ (void)getReceiveInvatations:(MXRGetReceiveInvitationsR *)param
                    success:(void (^)(MXRNetworkResponse *response))success
                    failure:(void (^)(id error))failure;

+ (void)acceptFriendInvitation:(MXRAcceptFriendInvitationR *)param
                       success:(void (^)(MXRNetworkResponse *response))success
                       failure:(void (^)(id error))failure;

+ (void)getFriendListUserInfo:(MXRGetFriendListUserInfoR *)param
                      success:(void (^)(MXRNetworkResponse *response))success
                      failure:(void (^)(id error))failure;

// 根据时间节点获取更早的P2P聊天消息
+ (void)getEarlierP2PChatMessages:(MXRGetEarlierP2PChatMessageR *)param
                           success:(void (^)(MXRNetworkResponse *response))success
                           failure:(void (^)(id error))failure;

+ (void)getLastP2PChatMessages:(MXRGetLastP2PChatMessageR *)param
                       success:(void (^)(MXRNetworkResponse *response))success
                       failure:(void (^)(id error))failure;

+ (void)addP2PchatMessage:(MXRAddP2PChatMessageR *)param
                  success:(void (^)(MXRNetworkResponse *response))success
                  failure:(void (^)(id error))failure;


/**
 删除某一条P2P聊天记录

 @param param @see MXRDeleteP2PChatMessageR
 @param success 成功回调
 @param failure 失败回调
 */
+ (void)deleteP2PChatMessage:(MXRDeleteP2PChatMessageR *)param
                     success:(void (^)(MXRNetworkResponse *response))success
                     failure:(void (^)(id error))failure;

@end
