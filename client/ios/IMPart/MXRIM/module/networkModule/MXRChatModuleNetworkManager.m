//
//  MXRChatModuleNetworkManager.m
//  huashida_home
//
//  Created by Martin.Liu on 2017/9/21.
//  Copyright © 2017年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import "MXRChatModuleNetworkManager.h"
#import "MXRNetworkManager.h"
#import "MXRIMUrl.h"

@implementation MXRChatModuleNetworkManager

+ (void)getChatRoomListSuccess:(void (^)(MXRNetworkResponse *))success
                       failure:(void (^)(id))failure
{
    NSString *url = [NSString stringWithFormat:@"%@%@", CHATSERVER, CHATURL_GetChatRoomList];
    [MXRNetworkManager mxr_get:url parameters:nil success:^(NSURLSessionTask *task, MXRNetworkResponse *response) {
        if (success) {
            success(response);
        };
    } failure:^(NSURLSessionTask *task, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)getChatRoomSortList:(MXRGetChatRoomSortListR *)param
                    success:(void (^)(MXRNetworkResponse *))success
                    failure:(void (^)(id))failure
{
    NSString *url = [NSString stringWithFormat:@"%@%@", CHATSERVER, CHATURL_GetChatRoomSortList];
    [MXRNetworkManager mxr_get:url parameters:[param mxr_modelToJSONObject] success:^(NSURLSessionTask *task, MXRNetworkResponse *response) {
        if (success) {
            success(response);
        };
    } failure:^(NSURLSessionTask *task, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)getLastChatMessages:(MXRGetLastChatRoomMessageR *)param
                    success:(void (^)(MXRNetworkResponse *))success
                    failure:(void (^)(id))failure
{
    NSString *url = [NSString stringWithFormat:@"%@%@", CHATSERVER, CHATURL_GetChatMessageWithRoomId];
    [MXRNetworkManager mxr_get:url parameters:[param mxr_modelToJSONObject] success:^(NSURLSessionTask *task, MXRNetworkResponse *response) {
        if (success) {
            success(response);
        };
    } failure:^(NSURLSessionTask *task, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)getEarlierChatRoomMessages:(MXRGetEarlierChatRoomMessageR *)param
                           success:(void (^)(MXRNetworkResponse *))success
                           failure:(void (^)(id))failure
{
    NSString *url = [NSString stringWithFormat:@"%@%@", CHATSERVER, CHATURL_GetChatMessagesByPage];
    [MXRNetworkManager mxr_get:url parameters:[param mxr_modelToJSONObject] success:^(NSURLSessionTask *task, MXRNetworkResponse *response) {
        if (success) {
            success(response);
        };
    } failure:^(NSURLSessionTask *task, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)joinInChatRoom:(MXRJoinInChatRoomR *)param
               success:(void (^)(MXRNetworkResponse *))success
               failure:(void (^)(id))failure
{
    NSString *url = [NSString stringWithFormat:@"%@%@", CHATSERVER, CHATURL_JoinInRoom];
    [MXRNetworkManager mxr_post:url parameters:[param mxr_modelToJSONString] success:^(NSURLSessionTask *task, MXRNetworkResponse *response) {
        if (success) {
            success(response);
        }
    } failure:^(NSURLSessionTask *task, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)getUserListInfoRoom:(MXRGetUserInfoListInRoomR *)param
                    success:(void (^)(MXRNetworkResponse *))success
                    failure:(void (^)(id))failure
{
    NSString *url = [NSString stringWithFormat:@"%@%@", CHATSERVER, CHATURL_GetCUserInfoListInRoom];
    [MXRNetworkManager mxr_get:url parameters:[param mxr_modelToJSONObject] success:^(NSURLSessionTask *task, MXRNetworkResponse *response) {
        if (success) {
            success(response);
        }
    } failure:^(NSURLSessionTask *task, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)sendFriendInvitation:(MXRSendFriendInvitationR *)param
                     success:(void (^)(MXRNetworkResponse *))success
                     failure:(void (^)(id))failure
{
    NSString *url = [NSString stringWithFormat:@"%@%@", CHATSERVER, CHATURL_SendFriendInvitation];
    [MXRNetworkManager mxr_post:url parameters:[param mxr_modelToJSONString] success:^(NSURLSessionTask *task, MXRNetworkResponse *response) {
        if (success) {
            success(response);
        }
    } failure:^(NSURLSessionTask *task, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)getFriendshipBetweenUsers:(MXRGetUsersFriendShipR *)param
                          success:(void (^)(MXRNetworkResponse *))success
                          failure:(void (^)(id))failure
{
    NSString *url = [NSString stringWithFormat:@"%@%@", CHATSERVER, CHATURL_GetFriendshipBetweenUsers];
    [MXRNetworkManager mxr_get:url parameters:[param mxr_modelToJSONObject] success:^(NSURLSessionTask *task, MXRNetworkResponse *response) {
        if (success) {
            success(response);
        }
    } failure:^(NSURLSessionTask *task, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)createFriendShip:(MXRCreateFirendShipWithUsersR *)param
                 success:(void (^)(MXRNetworkResponse *))success
                 failure:(void (^)(id))failure
{
    NSString *url = [NSString stringWithFormat:@"%@%@", CHATSERVER, CHATURL_CreateFriendShip];
    [MXRNetworkManager mxr_post:url parameters:[param mxr_modelToJSONObject] success:^(NSURLSessionTask *task, MXRNetworkResponse *response) {
        if (success) {
            success(response);
        }
    } failure:^(NSURLSessionTask *task, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)getReceiveInvatations:(MXRGetReceiveInvitationsR *)param
                      success:(void (^)(MXRNetworkResponse *))success
                      failure:(void (^)(id))failure
{
    NSString *url = [NSString stringWithFormat:@"%@%@", CHATSERVER, CHATURL_GetReceiveInvitations];
    [MXRNetworkManager mxr_get:url parameters:[param mxr_modelToJSONObject] success:^(NSURLSessionTask *task, MXRNetworkResponse *response) {
        if (success) {
            success(response);
        }
    } failure:^(NSURLSessionTask *task, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)acceptFriendInvitation:(MXRAcceptFriendInvitationR *)param
                       success:(void (^)(MXRNetworkResponse *))success
                       failure:(void (^)(id))failure
{
    NSString *url = [NSString stringWithFormat:@"%@%@", CHATSERVER, CHATURL_AcceptFriendInvitation];
    [MXRNetworkManager mxr_post:url parameters:[param mxr_modelToJSONString] success:^(NSURLSessionTask *task, MXRNetworkResponse *response) {
        if (success) {
            success(response);
        }
    } failure:^(NSURLSessionTask *task, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)getFriendListUserInfo:(MXRGetFriendListUserInfoR *)param
                      success:(void (^)(MXRNetworkResponse *))success
                      failure:(void (^)(id))failure
{
    NSString *url = [NSString stringWithFormat:@"%@%@", CHATSERVER, CHATURL_GetFriendListUserInfo];
    [MXRNetworkManager mxr_get:url parameters:[param mxr_modelToJSONObject] success:^(NSURLSessionTask *task, MXRNetworkResponse *response) {
        if (success) {
            success(response);
        }
    } failure:^(NSURLSessionTask *task, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)getEarlierP2PChatMessages:(MXRGetEarlierP2PChatMessageR *)param
                          success:(void (^)(MXRNetworkResponse *))success
                          failure:(void (^)(id))failure
{
    NSString *url = [NSString stringWithFormat:@"%@%@", CHATSERVER, CHATURL_GetEarlierP2PChatMessages];
    [MXRNetworkManager mxr_get:url parameters:[param mxr_modelToJSONObject] success:^(NSURLSessionTask *task, MXRNetworkResponse *response) {
        if (success) {
            success(response);
        }
    } failure:^(NSURLSessionTask *task, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)getLastP2PChatMessages:(MXRGetLastP2PChatMessageR *)param
                       success:(void (^)(MXRNetworkResponse *))success
                       failure:(void (^)(id))failure
{
    NSString *url = [NSString stringWithFormat:@"%@%@", CHATSERVER, CHATURL_GetLastP2PChatMessages];
    [MXRNetworkManager mxr_get:url parameters:[param mxr_modelToJSONObject] success:^(NSURLSessionTask *task, MXRNetworkResponse *response) {
        if (success) {
            success(response);
        }
    } failure:^(NSURLSessionTask *task, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)addP2PchatMessage:(MXRAddP2PChatMessageR *)param
                  success:(void (^)(MXRNetworkResponse *))success
                  failure:(void (^)(id))failure
{
    NSString *url = [NSString stringWithFormat:@"%@%@", CHATSERVER, CHATURL_AddP2PChatMessage];
    [MXRNetworkManager mxr_post:url parameters:[param mxr_modelToJSONString] success:^(NSURLSessionTask *task, MXRNetworkResponse *response) {
        if (success) {
            success(response);
        }
    } failure:^(NSURLSessionTask *task, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)deleteP2PChatMessage:(MXRDeleteP2PChatMessageR *)param
                     success:(void (^)(MXRNetworkResponse *))success
                     failure:(void (^)(id))failure
{
    NSString *url = [NSString stringWithFormat:@"%@%@", CHATSERVER, CHATURL_DeleteP2PChatMessage];
    [MXRNetworkManager mxr_post:url parameters:[param mxr_modelToJSONString] success:^(NSURLSessionTask *task, MXRNetworkResponse *response) {
        if (success) {
            success(response);
        }
    } failure:^(NSURLSessionTask *task, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}
@end
