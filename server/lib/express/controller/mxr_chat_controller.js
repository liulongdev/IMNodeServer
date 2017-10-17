/**
 * Created by Martin on 2017/9/20.
 * 聊天相关数据的逻辑层
 */
const constant = require('../../constant');
const db = require('../../dbhelper/mxr_db');
const MXRResponseModel = require('../../express/model/mxr-base-response-model');
const MXRUtility = require('../../utility/mxr-utility');
const uuidv1 = require('uuid/v1');
const chatController = {};
/*
* 获取聊天室的列表
*
* callback(result) : MXRResponseModel
* */
chatController.getChatRoomList = function(callBack){

    const selectSql = db.buildSql("SELECT", constant.TABLE_CHAT_ROOM, null, null, "ID");
    db.querySql(selectSql, null, function (err, recordset) {
        let result = new MXRResponseModel();
        if (err){
            result.header.setErrCode(constant.ERR_CODE_DEFAULT_1);
            result.header.errMsg = err + '';
            callBack(result);
        }
        else
        {
            if (recordset && Array.isArray(recordset[constant.DB_KEY_RECORD_SET]))
            {
                result.body = recordset[constant.DB_KEY_RECORD_SET];
                callBack(result);
            }
            else
            {
                callBack(result);
            }
        }
    })
};

/*
 * 获取聊天室的列表
 *'userId' :   'int'
 *
 * callback(result) : MXRResponseModel
 * */
chatController.getChatRoomSortList = async function(params, callBack){
    const result = new MXRResponseModel();
    if (!MXRUtility.verifyParams(params, ['userId']))
    {
        result.header.setErrCode(constant.ERR_CODE_INVALID_PARAM);
        result.header.errMsg = constant.ERR_MSG_INVALID_PARAM;
        callBack(result);
        console.log('In valid param');
        return;
    }
    // var hasJoinedRoomsSql = "SELECT roomT.* FROM " + constant.TABLE_CHAT_ROOM + " AS roomT JOIN " + constant.TABLE_USER_CHAT_ROOM + " AS userT ON roomT.UUID = userT.chatRoomId where userT.userId = " + params['userId'] + " ORDER BY ID";
    // var notJoinedRoomsSql = "SELECT roomT.* FROM " + constant.TABLE_CHAT_ROOM + " AS roomT JOIN " + constant.TABLE_USER_CHAT_ROOM + " AS userT ON roomT.UUID = userT.chatRoomId where userT.userId != " + params['userId'] + " ORDER BY ID";
    const hasJoinedRoomsSql = db.buildSql("SELECT", constant.TABLE_CHAT_ROOM, null, "WHERE UUID IN (SELECT chatRoomId from " + constant.TABLE_USER_CHAT_ROOM + " WHERE userId = " + params['userId'] + ")", "ID");
    const notJoinedRoomsSql = db.buildSql("SELECT", constant.TABLE_CHAT_ROOM, null, "WHERE UUID NOT IN (SELECT chatRoomId from " + constant.TABLE_USER_CHAT_ROOM + " WHERE userId = " + params['userId'] + ")", "ID");
    try {
        const joinedRoomSet = await db.querySqlAsync(hasJoinedRoomsSql);
        const notJoinedRoomSet = await db.querySqlAsync(notJoinedRoomsSql);
        result.body = {"hasJoinedRoomList":joinedRoomSet[constant.DB_KEY_RECORD_SET],
                        "notJoinedRoomList":notJoinedRoomSet[constant.DB_KEY_RECORD_SET]};
        callBack(result);
    }
    catch (err)
    {
        result.header.setErrCode(constant.ERR_CODE_DEFAULT_1);
        result.header.errMsg = err + '';
        callBack(result);
    }
};

/*
 * 添加一个聊天室
 *  'name':         string,
 *  'userMaxNum':   int,
 *
 *  callback(result) : MXRResponseModel
 * */
chatController.createChatRoom = function(params,callback){
    let result = new MXRResponseModel();
    if (!MXRUtility.verifyParams(params, ['name', 'userMaxNum']))
    {
        result.header.setErrCode(constant.ERR_CODE_INVALID_PARAM);
        result.header.errMsg = constant.ERR_MSG_INVALID_PARAM;
        callback(result);
        console.log('In valid param');
        return;
    }
    const addObj = {
                    'UUID':uuidv1(),
                    'name':params.name,
                    'userMaxNum':params.userMaxNum,
                    'createTime':MXRUtility.nowTimeString(),
                    'updateTime':MXRUtility.nowTimeString(),
    };
    db.add(addObj, constant.TABLE_CHAT_ROOM, function (err, recordset) {
        if (err){
            result.header.setErrCode(constant.ERR_CODE_DEFAULT_1);
            result.header.errMsg = err +'';
            callback(result);
            console.log('create chatRoom error :' + err);
        }
        else
        {
            callback(result);
            console.log('create chatRoom success');
        }
    })
};

/*
* 更改聊天室信息
*   'chatRoomId':   int,
*   'name':         string
*
*   callback(result) : MXRResponseModel
* */
chatController.updateChatRoomWithId = function (params, callback) {
    let result = new MXRResponseModel();
    if (!MXRUtility.verifyParams(params, ['chatRoomId', 'name']))
    {
        result.header.setErrCode(constant.ERR_CODE_INVALID_PARAM);
        result.header.errMsg = constant.ERR_MSG_INVALID_PARAM;
        callback(result);
        console.log('In valid param');
        return;
    }
    const updateObj = {'name': params['name'],
                        'updateTime': MXRUtility.nowTimeString()};
    const whereObj = {'UUID': params['chatRoomId']};
    db.update(updateObj, whereObj, constant.TABLE_CHAT_ROOM, function(err, recordset){
        if (err){
            result.header.setErrCode(constant.ERR_CODE_DEFAULT_1);
            result.header.errMsg = err +'';
            callback(result);
            console.log('update chatRoom error :' + err);
        }
        else
        {
            callback(result);
            console.log('update chatRoom success');
        }
    })
};

/*
* 增加一个群聊聊天记录
* 'chatRoomId':   int,
* 'userId':       int,
* 'content':      string,
* 'contentType':  int
*
* callback(result) : MXRResponseModel
* */
chatController.addChatRoomMessage = function(params, callback){
    let result = new MXRResponseModel();
    if (!MXRUtility.verifyParams(params, ['chatRoomId', 'userId', 'content']))
    {
        result.header.setErrCode(constant.ERR_CODE_INVALID_PARAM);
        result.header.errMsg = constant.ERR_MSG_INVALID_PARAM;
        callback(result);
        console.log('In valid param');
        return;
    }
    const addObj = {
        'UUID':uuidv1(),
        'chatRoomId':params['chatRoomId'],
        'userId':params['userId'],
        'content':params['content'],
        'contentType':params['contentType'],
        'createTime':MXRUtility.nowTimeString(),
        'updateTime':MXRUtility.nowTimeString(),
    };
    db.add(addObj, constant.TABLE_CHAT_ROOM_MESSAGE, function (err, recordset) {
        if (err){
            result.header.setErrCode(constant.ERR_CODE_DEFAULT_1);
            result.header.errMsg = err +'';
            callback(result);
            console.log('add chat message error :' + err);
        }
        else
        {
            callback(result);
            console.log('add chat message success');
        }
    })
};

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
chatController.addP2PChatMessage = function(params, callback){
    let result = new MXRResponseModel();
    if (!MXRUtility.verifyParams(params, ['receiveUserId', 'userId', 'content']))
    {
        result.header.setErrCode(constant.ERR_CODE_INVALID_PARAM);
        result.header.errMsg = constant.ERR_MSG_INVALID_PARAM;
        callback(result);
        console.log('In valid param');
        return;
    }
    let UUID = params['messageUUID'];
    if (UUID == null)
        UUID = uuidv1();
    const addObj = {
        'UUID':UUID,
        'receiverId':params['receiveUserId'],
        'senderId':params['userId'],
        'content':params['content'],
        'contentType':params['contentType'],
        'createTime':MXRUtility.nowTimeString(),
        'updateTime':MXRUtility.nowTimeString(),
    };
    db.add(addObj, constant.TABLE_P2P_CHAT_MESSAGE, function (err, recordset) {
        if (err){
            result.header.setErrCode(constant.ERR_CODE_DEFAULT_1);
            result.header.errMsg = err +'';
            callback(result);
            console.log('add p2p chat message error :' + err);
        }
        else
        {
            result.body = UUID;
            callback(result);
            console.log('add p2p chat message success');
        }
    })
};

/*删除某一条P2P聊天记录
*
* 'messageUUID' :      'string'
* */
chatController.deleteP2PMessage = async function (params, callback) {
    let result = new MXRResponseModel();
    if (!MXRUtility.verifyParams(params, ['messageUUID']))
    {
        result.header.setErrCode(constant.ERR_CODE_INVALID_PARAM);
        result.header.errMsg = constant.ERR_MSG_INVALID_PARAM;
        callback(result);
        console.log('In valid param');
        return;
    }

    const deleteObj = {'status': 1};
    const whereObj = {'UUID': params['messageUUID']};
    const updateSql = db.buildSql('UPDATE', constant.TABLE_P2P_CHAT_MESSAGE, deleteObj, whereObj);
    try {
        let recordSet = await db.querySqlAsync(updateSql);
        callback(result);
    }
    catch (err)
    {
        result.header.setErrCode(constant.ERR_CODE_DEFAULT_1);
        result.header.errMsg = '' + err;
        callback(result);
    }
};

/*
* 增加一个用户到聊天室中
* 'userId':         int,
* 'chatRoomId':     int,
* 'status'  :       int,
*
* callback(result) : MXRResponseModel
* */
chatController.addUserIntoChatRoom =  function(params, callback) {
    let result = new MXRResponseModel();
    if (!MXRUtility.verifyParams(params, ['chatRoomId', 'userId']))
    {
        result.header.setErrCode(constant.ERR_CODE_INVALID_PARAM);
        result.header.errMsg = constant.ERR_MSG_INVALID_PARAM;
        callback(result.toMXRString());
        console.log('In valid param');
        return;
    }
    const addObj = {
        'UUID':uuidv1(),
        'chatRoomId':params['chatRoomId'],
        'userId':params['userId'],
        'status':params['status'],
        'createTime':MXRUtility.nowTimeString(),
        'updateTime':MXRUtility.nowTimeString(),
    };
    const insertSql = db.buildSql("INSERT", constant.TABLE_USER_CHAT_ROOM, addObj);
    db.querySql(insertSql, null, function (err, recordset) {
        if (err){
            result.header.setErrCode(constant.ERR_CODE_DEFAULT_1);
            result.header.errMsg = err +'';
            callback(result);
            console.log('add user Info Room error :' + err);
        }
        else
        {
            callback(result);
            console.log('add user Info Room success');
        }
    });
};

/* 根据聊天室标识获取聊天室聊天记录
*   'chatRoomId':     int,
*   'afterDateTime':  'string',
*
*   callback(result) : MXRResponseModel
* */
chatController.getLastChatRoomMessages = function(params, callback) {
    let result = new MXRResponseModel();
    if (!MXRUtility.verifyParams(params, ['chatRoomId', 'afterDateTime']))
    {
        result.header.setErrCode(constant.ERR_CODE_INVALID_PARAM);
        result.header.errMsg = constant.ERR_MSG_INVALID_PARAM;
        callback(result);
        console.log('In valid param');
        return;
    }
    // SELECT messageT.*, userT.userName from T_ChatRoomMessage as messageT LEFT JOIN [userdata].[dbo].UserAccount as userT ON messageT.userId = userT.userID ORDER BY ID;
    // db.querySql('SELECT * FROM '+constant.TABLE_CHAT_ROOM_MESSAGE+ ' WHERE chatRoomId = @chatRoomId', params, function(err, recordset){
    db.querySql('SELECT messageT.*, userT.userNickName, CONVERT(varchar(100), messageT.createTime, 20) as createTime2, CONVERT(varchar(100), messageT.updateTime, 20) as updateTime2 FROM '+constant.TABLE_CHAT_ROOM_MESSAGE+ ' as messageT LEFT JOIN ' + constant.TABLE_USER_INFO + ' as userT ON messageT.userId = userT.userID' + ' WHERE chatRoomId = @chatRoomId and createTime > @afterDateTime ORDER BY messageT.ID', params, function(err, recordset){
        if (err){
            result.header.setErrCode(constant.ERR_CODE_DEFAULT_1);
            result.header.errMsg = err +'';
            callback(result);
            console.log('get chat message error :' + err);
        }
        else
        {
            if (recordset && Array.isArray(recordset[constant.DB_KEY_RECORD_SET]))
            {
                result.body = recordset[constant.DB_KEY_RECORD_SET];
                callback(result);
            }
            else
            {
                callback(result);
            }
        }
    });
};

/* 根据时间获取
 *   'chatRoomId':          'int',
 *   'deadlineDateTime':    'string',
 *   'pageIndex':           'int'      optional
 *   'pageSize':            'int'      optional
 *
 *   callback(result) : MXRResponseModel
 * */
chatController.getEarlierChatRoomMessages = function(params, callback) {
    let result = new MXRResponseModel();
    if (!MXRUtility.verifyParams(params, ['chatRoomId', 'deadlineDateTime']))
    {
        result.header.setErrCode(constant.ERR_CODE_INVALID_PARAM);
        result.header.errMsg = constant.ERR_MSG_INVALID_PARAM;
        callback(result);
        console.log('In valid param');
        return;
    }

    if (!MXRUtility.verifyParams(params, ['pageIndex', 'pageSize']) || params['pageIndex'] == 0 || params['pageSize'] == 0)
    {
        params['pageIndex'] = 1;
        params['pageSize'] = 50;
    }
    const selectSql = "SELECT messageT.*, userT.userNickName, CONVERT(varchar(100), messageT.createTime, 20) as createTime2, CONVERT(varchar(100), messageT.updateTime, 20) as updateTime2 FROM "+constant.TABLE_CHAT_ROOM_MESSAGE+ " as messageT LEFT JOIN " + constant.TABLE_USER_INFO + " as userT ON messageT.userId = userT.userID WHERE chatRoomId = '" + params['chatRoomId'] + "' and createTime < '" + params['deadlineDateTime'] + "'";
    const pageSql = db.buildPageSelectSql(selectSql, "ID DESC", params['pageIndex'], params['pageSize']);
    db.querySql(pageSql, null, function(err, recordset){
        if (err){
            result.header.setErrCode(constant.ERR_CODE_DEFAULT_1);
            result.header.errMsg = err +'';
            callback(result);
            console.log('get chat message error :' + err);
        }
        else
        {
            if (recordset && Array.isArray(recordset[constant.DB_KEY_RECORD_SET]))
            {
                result.body = recordset[constant.DB_KEY_RECORD_SET].reverse();
                callback(result);
            }
            else
            {
                callback(result);
            }
        }
    });
};

/* 获取某个房间中所有加入的人的id
*   'chatRoomId':       'string'
*
*   callback(result) : MXRResponseModel
* */
chatController.getUserIdListInRoom = function(params, callback) {
    let result = new MXRResponseModel();
    if (!MXRUtility.verifyParams(params, ['chatRoomId']))
    {
        result.header.setErrCode(constant.ERR_CODE_INVALID_PARAM);
        result.header.errMsg = constant.ERR_MSG_INVALID_PARAM;
        callback(result);
        console.log('In valid param');
        return;
    }

    const selectSql = db.buildSql("SELECT", constant.TABLE_USER_CHAT_ROOM, ["userId"], {'chatRoomId':params['chatRoomId']}, "ID");
    db.querySql(selectSql, null, function (err, recordset) {
        if (err){
            result.header.setErrCode(constant.ERR_CODE_DEFAULT_1);
            result.header.errMsg = err +'';
            callback(result);
            console.log('get chat message error :' + err);
        }
        else
        {
            if (recordset && Array.isArray(recordset[constant.DB_KEY_RECORD_SET]))
            {
                result.body = recordset[constant.DB_KEY_RECORD_SET];
                callback(result);
            }
            else
            {
                callback(result);
            }
        }
    });
};

/* 获取某个房间里的所有用户
*  'chatRoomId':       'string'
*   'pageIndex':        'int'
*   'pageSize':         'int'
* */
chatController.getUserListInRoom = function(params, callback) {
    let result = new MXRResponseModel();
    if (!MXRUtility.verifyParams(params, ['chatRoomId', 'pageIndex', 'pageSize']))
    {
        result.header.setErrCode(constant.ERR_CODE_INVALID_PARAM);
        result.header.errMsg = constant.ERR_MSG_INVALID_PARAM;
        callback(result);
        console.log('In valid param');
        return;
    }

    // var selectSql = db.buildSql("SELECT", constant.TABLE_USER_CHAT_ROOM, ["userId"], {'chatRoomId':params['chatRoomId']}, "ID");
    let selectSql = "SELECT userT.* FROM " + constant.TABLE_USER_INFO + " AS userT  WHERE userT.userID IN (SELECT userId FROM " + constant.TABLE_USER_CHAT_ROOM + " WHERE chatRoomId = '" + params['chatRoomId'] + "')";
    selectSql = db.buildPageSelectSql(selectSql, 'userID', params['pageIndex'], params['pageSize']);
    db.querySql(selectSql, null, function (err, recordset) {
        if (err){
            result.header.setErrCode(constant.ERR_CODE_DEFAULT_1);
            result.header.errMsg = err +'';
            callback(result);
            console.log('get chat message error :' + err);
        }
        else
        {
            if (recordset && Array.isArray(recordset[constant.DB_KEY_RECORD_SET]))
            {
                result.body = recordset[constant.DB_KEY_RECORD_SET];
                callback(result);
            }
            else
            {
                callback(result);
            }
        }
    });
};

/* 根据聊天室标识获取P2P聊天室聊天记录
 *   'senderId':        int,
 *   'receiverId":       int,
 *   'afterDateTime':  'string',
 *
 *   callback(result) : MXRResponseModel
 * */
chatController.getLastP2PChatMessages = async function (params, callback) {
    let result = new MXRResponseModel();
    if (!MXRUtility.verifyParams(params, ['senderId', 'receiverId', 'afterDateTime']))
    {
        result.header.setErrCode(constant.ERR_CODE_INVALID_PARAM);
        result.header.errMsg = constant.ERR_MSG_INVALID_PARAM;
        callback(result);
        console.log('In valid param');
        return;
    }
    try {
        const senderId = params['senderId'], receiverId = params['receiverId'], afterDateTime = params['afterDateTime'];
        let recordSet = await chatController.db_selectLastP2PMessages(senderId, receiverId, afterDateTime);
        result.body = recordSet[constant.DB_KEY_RECORD_SET];
        callback(result);
    }
    catch (err)
    {
        result.header.setErrCode(constant.ERR_CODE_DEFAULT_1);
        result.header.errMsg = err +'';
        callback(result);
    }
};

/* 根据时间获取P2P聊天消息
 *   'senderId':        int,
 *   'receiverId":       int,
 *   'deadlineDateTime':    'string',
 *   'pageIndex':           'int'      optional
 *   'pageSize':            'int'      optional
 *
 *   callback(result) : MXRResponseModel
 * */
chatController.getEarlierP2PChatMessages = async function (params, callback) {
    let result = new MXRResponseModel();
    if (!MXRUtility.verifyParams(params, ['senderId', 'receiverId', 'deadlineDateTime']))
    {
        result.header.setErrCode(constant.ERR_CODE_INVALID_PARAM);
        result.header.errMsg = constant.ERR_MSG_INVALID_PARAM;
        callback(result);
        console.log('In valid param');
        return;
    }
    if (!MXRUtility.verifyParams(params, ['pageIndex', 'pageSize']) || params['pageIndex'] == 0 || params['pageSize'] == 0)
    {
        params['pageIndex'] = 1;
        params['pageSize'] = 50;
    }

    try {
        const senderId = params['senderId'], receiverId = params['receiverId'], deadlineDateTime = params['deadlineDateTime'], pageIndex = params['pageIndex'], pageSize = params['pageSize'];
        let recordSet = await chatController.db_selectEarlierP2PMessages(senderId, receiverId, deadlineDateTime, pageIndex, pageSize)
        result.body = recordSet[constant.DB_KEY_RECORD_SET].reverse();
        callback(result);
    }
    catch (err)
    {
        result.header.setErrCode(constant.ERR_CODE_DEFAULT_1);
        result.header.errMsg = err +'';
        callback(result);
    }
};

/*获取P2P聊天信息
* 'senderId'    :       'int'
* 'receiverId'  :       'int'
* 'deadlineDateTime':   'string'
* 'pageIndex':           'int'      optional
* 'pageSize':            'int'      optional
* */
chatController.db_selectEarlierP2PMessages = async function (senderId, receiverId, deadlineDateTime, pageIndex, PageSize) {
    const selectP2pChatMessagesSql = "SELECT messageT.*, userT.userNickName, CONVERT(varchar(100), messageT.createTime, 20) as createTime2, CONVERT(varchar(100), messageT.updateTime, 20) as updateTime2 FROM "+constant.TABLE_P2P_CHAT_MESSAGE + " AS messageT JOIN " + constant.TABLE_USER_INFO +" AS userT ON userT.userID = senderId WHERE ((senderId = '" +senderId +"' and receiverId = '" + receiverId + "') or (senderId = '" +receiverId +"' and receiverId = '" + senderId +"')) and status = 0 and createTime < '" + deadlineDateTime + "'";
    const selectP2pChatMessagesPageSql = db.buildPageSelectSql(selectP2pChatMessagesSql, 'ID DESC', pageIndex, PageSize);
    let recordSet = await db.querySqlAsync(selectP2pChatMessagesPageSql);
    return recordSet;
};

/*获取P2P聊天信息
 * 'senderId'    :       'int'
 * 'receiverId'  :       'int'
 * 'afterDateTime':   'string'
 * */
chatController.db_selectLastP2PMessages = async function (senderId, receiverId, afterDateTime) {

    const selectP2pChatMessagesSql = "SELECT messageT.*, userT.userNickName, CONVERT(varchar(100), messageT.createTime, 20) AS createTime2, CONVERT(varchar(100), messageT.updateTime, 20) AS updateTime2 FROM "+constant.TABLE_P2P_CHAT_MESSAGE + " AS messageT JOIN " + constant.TABLE_USER_INFO +" AS userT ON userT.userID = senderId WHERE ((senderId = '" +senderId +"' and receiverId = '" + receiverId + "') or (senderId = '" +receiverId +"' and receiverId = '" + senderId +"'))  and status = 0 and createTime > '" + afterDateTime + "' ORDER BY ID";
    let recordSet = await db.querySqlAsync(selectP2pChatMessagesSql);
    return recordSet;
};

// SELECT top 10 * FROM userdata.dbo.UserAccount as userT where  userT.userID IN (Select userId from T_User_ChatRoom WHERE chatRoomId = 'bea395b0-a4bf-11e7-aa69-1d006d7d86db')

//
//
// chatController.getChatRoomList(function(result){
//     console.log('>>>>> tst : ' + result);
// });
// chatController.createChatRoom(function(err, recordsset){});

// chatController.updateChatRoomWithId({'chatRoomId':1,'name':'更改房间名222'}, function(result){
//     console.log('>>>>> tst : ' + result);
// });

// chatController.addChatMessage({
//     'chatRoomId':1,
//     'userId':100,
//     'userName':'马丁测试',
//     'contentType':0,
//     'content':'发个消息试试',
//     'createTime':MXRUtility.nowTimeString(),
//     'updateTime':MXRUtility.nowTimeString(),
// }, function(result){
//     console.log('>>>>> tst : ' + result);
// })

// chatController.addUserIntoChatRoom({'userId':100, 'chatRoomId':1,status:0}, function (result) {
//     console.log('>>>> test : ' + result);
// })

// chatController.getUserListInRoom({'chatRoomId':'bea395b0-a4bf-11e7-aa69-1d006d7d86db'}, function (result) {
//     console.log(result.toMXRString());
// })

module.exports = chatController;