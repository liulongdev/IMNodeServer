/**
 * Created by Martin on 2017/9/20.
 */

module.exports = Object.freeze({
    DB_KEY_RECORD_SET: 'recordset',
    DB_KEY_ROWS_AFFECTED: 'rowsAffected',

    ERR_MSG_INVALID_PARAM: '缺少参数，请检查',

    ERR_CODE_DEFAULT_1: 1,
    ERR_CODE_INVALID_PARAM: 2,

    TABLE_CHAT_ROOM :                   '[mxr_IM].[dbo].T_ChatRoom',                  // 存储聊天室的
    TABLE_P2P_CHAT_MESSAGE :           '[mxr_IM].[dbo].T_P2P_ChatMessage',             // 存储p2p聊天记录
    TABLE_CHAT_ROOM_MESSAGE :           '[mxr_IM].[dbo].T_ChatRoomMessage',           // 存储聊天记录的
    TABLE_USER_CHAT_ROOM :              '[mxr_IM].[dbo].T_User_ChatRoom',             // 存储用户对应聊天室的记录
    TABLE_USER_ACCOUNT:                 '[userdata].[dbo].UserAccount',                 // 存储用户？？？？
    TABLE_USER_INFO:                    '[userdata].[dbo].UserInfo',                 // 存储用户基本信息的表
    TABLE_USER_FRIENDSHIP:              '[mxr_IM].[dbo].T_User_FriendShip',             // 好友关系表
    TABLE_USER_FRIENDSHIP_COLLECTION:   '[mxr_IM].[dbo].T_User_FriendShip_Collection',  // 记录好友集合的表
    TABLE_USER_FRIENDSHIP_GROUP:        '[mxr_IM].[dbo].T_User_FriendShip_Group',       // 记录好友关系组的表
    TABLE_USER_FRIENDSHIP_FRIEND:       '[mxr_IM].[dbo].T_User_FriendShip_Friend',      // 好友存储表
    TABLE_USER_FRIENDSHIP_INVITATION:   '[mxr_IM].[dbo].T_User_FriendShip_Invitation',  // 好友邀请表

    SOCKET_MESSAGE_TYPE_SendUserId:     'Socket_SendUserId',     // 吧userId绑定到socket上
    SOCKET_MESSAGE_TYPE_JoinChatRoom:   'ChatRoom_JoinChatRoom',        // 添加到聊天室
    SOCKET_MESSAGE_TYPE_SendChatRoomMessage: 'ChatRoom_SendChatRoomMessage', // 发送聊天室聊天
    SOCKET_MESSAGE_TYPE_SendP2PChatMessage: 'P2PChat_SendChatMessage',      // 发送P2P聊天记录

    SERVER_URL_GetChatRoomList:         '/core/chat/v1/getChatRoomList',    // 获取聊天室列表
    SERVER_URL_CreateChatRoom:          '/core/chat/v1/createChatRoom',     // 创建聊天室
    SERVER_URL_UpdateChatRoomInfo:      '/core/chat/v1/updateChatRoom',     // 更新聊天室信息
    SERVER_URL_AddMessageIntoChatRoom:  '/core/chat/v1/addMessageIntoChatRoom',  // 向聊天室发送信息
    SERVER_URL_JoinToChatRoom:          '/core/chat/v1/joinToChatRoom',     // 加入聊天室
    SERVER_URL_GetLastChatRoomMessages: '/core/chat/v1/getMessagesWithRoomId', // 获取聊天室聊天记录
    SERVER_URL_GetEarlierChatRoomMessages: '/core/chat/v1/getChatRoomMessages', // 获取聊天室聊天记录
    SERVER_URL_GetChatRoomSortList:     '/core/chat/v1/getChatRoomSortList', // 获取聊天室列表， 分为已加入和未加入
    SERVER_URL_GetUserInfoListInRoom:   '/core/chat/v1/getUserInfoListInRoom', // 获取聊天室里所有成员信息列表
    SERVER_URL_GetFriendshipBetweenUsers:'/core/chat/v1/getFriendshipBetweenUsers',     // 获取用户之间的关系
    SERVER_URL_SendFriendInvitation:    '/core/chat/v1/sendFriendInvitation',     // 获取用户之间的关系
    SERVER_URL_CreateFriendShip:        '/core/chat/v1/createFriendShip',       // 添加好友关系
    SERVER_URL_GetReceiveInvitations:   '/core/chat/v1/getReceiveInvitations',  // 获取某个人被好友邀请的列表
    SERVER_URL_AcceptFriendInvitation:  '/core/chat/v1/acceptFriendInvitation', // 接受好友邀请
    SERVER_URL_GetFriendListUserInfo:   '/core/chat/v1/getFriendListUserInfo',  // 获取某个用户的所有好友信息列表
    SERVER_URL_GetEarlierP2PChatMessages:   '/core/chat/v1/getEarlierP2PChatMessages',  // 获取历史的P2P聊天记录
    SERVER_URL_GetLastP2PChatMessages:  '/core/chat/v1/getLastP2PChatMessages',  // 获取历史的P2P聊天记录
    SERVER_URL_AddP2PChatMessage:       '/core/chat/v1/addP2PChatMessage',      // 增加P2P聊天记录
    SERVER_URL_DeleteP2PChatMessage:    '/core/chat/v1/deleteP2PChatMessage',      // 删除某一条P2P聊天记录

})
