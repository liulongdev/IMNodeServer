/**
 * Created by Martin on 2017/9/27.
 * 对聊天处理方外开放的接口方法
 */
const constant = require('../constant');
const MXRChatController = require('./controller/mxr_chat_controller');
const MXRUserController = require('./controller/mxr_user_friendship_controller');

function mxr_express_chat_room(app) {
    /*
     * 获取聊天室列表
     * */
    app.get(constant.SERVER_URL_GetChatRoomList, function(req, res, next){
        MXRChatController.getChatRoomList((result) => {
            res.header('content-type', 'application/json;charset=utf-8');
            res.end(result.toMXRString());
        });
    });

    /*
     * 添加聊天室
     *   'name':         string,
     *   'userMaxNum':   int,
     * */
    app.post(constant.SERVER_URL_CreateChatRoom, function(req, res, next){
        MXRChatController.createChatRoom(req.body, function(result){
            res.header('content-type', 'application/json;charset=utf-8');
            res.end(result.toMXRString());
        });
    });

    /*
     * 更新聊天室信息
     *   'chatRoomId':   int,
     *   'name':         string
     * */
    app.post(constant.SERVER_URL_UpdateChatRoomInfo, function(req, res, next){
        MXRChatController.updateChatRoomWithId(req.body, function(result){
            res.header('content-type', 'application/json;charset=utf-8');
            res.end(result.toMXRString());
        });
    });

    /*
     * 增加一个聊天记录
     * 'chatRoomId':   int,
     * 'userId':       int,
     * 'userName':     string,
     * 'content':      string,
     * 'contentType':  int
     * */
    app.post(constant.SERVER_URL_AddMessageIntoChatRoom, function(req, res, next) {
        MXRChatController.updateChatRoomWithId(req.body, function(result){
            res.header('content-type', 'application/json;charset=utf-8');
            res.end(result.toMXRString());
        });
    });

    /*
     * 增加一个用户到聊天室中
     * 'userId':         int,
     * 'chatRoomId':     string,
     * 'status'  :       int,
     * */
    app.post(constant.SERVER_URL_JoinToChatRoom, function (req, res, next) {
        MXRChatController.addUserIntoChatRoom(req.body, function(result){
            res.header('content-type', 'application/json;charset=utf-8');
            res.end(result.toMXRString());
        });
    });

    /* 根据聊天室标识获取聊天室聊天记录
     *   'chatRoomId':     'int',
     *   'afterDateTime':  'string',
     * */
    app.get(constant.SERVER_URL_GetLastChatRoomMessages, function (req, res, next) {
        MXRChatController.getLastChatRoomMessages(req.query, function(result){
            res.header('content-type', 'application/json;charset=utf-8');
            res.end(result.toMXRString());
        });
    });

    /* 根据聊天室标识获取聊天室更早的聊天记录
     *   'chatRoomId':          'int',
     *   'deadlineDateTime':    'string',
     *   'pageIndex':           'int'      optional
     *   'pageSize':            'int'      optional
     * */
    app.get(constant.SERVER_URL_GetEarlierChatRoomMessages, function (req, res, next) {
        MXRChatController.getEarlierChatRoomMessages(req.query, function(result){
            res.header('content-type', 'application/json;charset=utf-8');
            res.end(result.toMXRString());
        });
    });

    /*
     * 获取聊天室分组的列表
     *'userId' :   'int'
     * */
    app.get(constant.SERVER_URL_GetChatRoomSortList, function (req, res, next) {
        MXRChatController.getChatRoomSortList(req.query, function (result) {
            res.header('content-type', 'application/json;charset=utf-8');
            res.end(result.toMXRString());
        });
    });

    /* 获取某个房间里的所有用户
     *  'chatRoomId':       'string'
     *   'pageIndex':        'int'
     *   'pageSize':         'int'
     * */
    app.get(constant.SERVER_URL_GetUserInfoListInRoom, function (req, res, next) {
        MXRChatController.getUserListInRoom(req.query, function (result) {
            res.header('content-type', 'application/json;charset=utf-8');
            res.end(result.toMXRString());
        });
    });

    /*两人之间的关系 0:无关系 1:好友关系 2:用户A给用户B发送过好友邀请
     *
     * ‘userId' :        'int'
     * 'otherId' :       'int'
     *
     * return responseModel.body:{'friendship': 0/1/2}
     * */
    app.get(constant.SERVER_URL_GetFriendshipBetweenUsers, function (req, res, next) {
        MXRUserController.getFriendshipBetweenUsers(req.query, function (result) {
            res.header('content-type', 'application/json;charset=utf-8');
            res.end(result.toMXRString());
        });
    });

    /* 发送好友邀请
     *
     * 'userId':   'int'
     * 'invitedUserId:   'int'
     * 'content':       'string' optional
     */
    app.post(constant.SERVER_URL_SendFriendInvitation, function (req, res, next) {
        MXRUserController.sendFriendInvitation(req.body, function (result) {
            res.header('content-type', 'application/json;charset=utf-8');
            res.end(result.toMXRString());
        });
    });

    /* 创建一个好友
     * 'firstUserId':     'int'
     * 'secondUserId' :   'int'
     * */
    app.post(constant.SERVER_URL_CreateFriendShip, function (req, res, next) {
        MXRUserController.createUserFriendShipFriend(req.body, function (result) {
            res.header('content-type', 'application/json;charset=utf-8');
            res.end(result.toMXRString());
        });
    });

    /* 获取某个人的被邀请的好友列表
     *   'invitedUserId':        'int'
     *   'pageIndex':            'int'  optional
     *   'pageSize':             'int'  optional
     */
    app.get(constant.SERVER_URL_GetReceiveInvitations, function (req, res, next) {
        MXRUserController.getReceiveInvitations(req.query, function (result) {
            res.header('content-type', 'application/json;charset=utf-8');
            res.end(result.toMXRString());
        });
    });

    /*接受好友邀请
     * 'invitedUserId':    'int'
     * 'invitationUUID':     'string'
     * */
    app.post(constant.SERVER_URL_AcceptFriendInvitation, function (req, res, next) {
        MXRUserController.acceptFriendInvitation(req.body, function (result) {
            res.header('content-type', 'application/json;charset=utf-8');
            res.end(result.toMXRString());
        });
    });

    /* 获取用户的所有好友列表
     *   'userId'：       'int',
     * */
    app.get(constant.SERVER_URL_GetFriendListUserInfo, function (req, res, next) {
        MXRUserController.getFriendListUserInfo(req.query, function (result) {
            res.header('content-type', 'application/json;charset=utf-8');
            res.end(result.toMXRString());
        });
    });

    /* 根据时间获取历史的P2P聊天消息
     *   'senderId':        int,
     *   'receiverId":       int,
     *   'deadlineDateTime':    'string',
     *   'pageIndex':           'int'      optional
     *   'pageSize':            'int'      optional
     *
     *   callback(result) : MXRResponseModel
     * */
    app.get(constant.SERVER_URL_GetEarlierP2PChatMessages, function (req, res, next) {
        MXRChatController.getEarlierP2PChatMessages(req.query, function (result) {
            res.header('content-type', 'application/json;charset=utf-8');
            res.end(result.toMXRString());
        });
    });

    /* 获取P2P聊天室聊天记录
     *   'senderId':        int,
     *   'receiverId":       int,
     *   'afterDateTime':  'string',
     *
     *   callback(result) : MXRResponseModel
     * */
    app.get(constant.SERVER_URL_GetLastP2PChatMessages, function (req, res, next) {
        MXRChatController.getLastP2PChatMessages(req.query, function (result) {
            res.header('content-type', 'application/json;charset=utf-8');
            res.end(result.toMXRString());
        });
    });

    /*
     * 增加一个P2P聊天记录
     * 'messageUUID'           : string  optional
     * 'userId':       int,
     * 'receiveUserId':   int,
     * 'content':      string,
     * 'contentType':  int
     *
     * callback(result) : MXRResponseModel
     * */
    app.post(constant.SERVER_URL_AddP2PChatMessage , function (req, res, next) {
        MXRChatController.addP2PChatMessage(req.body, function (result) {
            res.header('content-type', 'application/json;charset=utf-8');
            res.end(result.toMXRString());
        });
    });

    /*删除某一条P2P聊天记录
     *
     * 'messageUUID' :      'string'
     *
     *  callback(result) : MXRResponseModel
     * */
    app.post(constant.SERVER_URL_DeleteP2PChatMessage, function (req, res, next) {
        MXRChatController.deleteP2PMessage(req.body, function (result) {
            res.header('content-type', 'application/json;charset=utf-8');
            res.end(result.toMXRString());
        });
    });

}

module.exports = mxr_express_chat_room;