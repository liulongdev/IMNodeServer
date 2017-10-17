/**
 * Created by Martin on 2017/9/28.
 */

const constant = require('../../constant');
const db = require('../../dbhelper/mxr_db');
const MXRResponseModel = require('../../express/model/mxr-base-response-model');
const MXRUtility = require('../../utility/mxr-utility');
const userFriendShipController = {};
const uuidv1 = require('uuid/v1');

/* 增加一条好友组
* 'name':       'string'
* */
userFriendShipController.createUserFriendShipGroup = function (params, callback) {
    let result;
    result = new MXRResponseModel();
    if (!MXRUtility.verifyParams(params, ['name']))
    {
        result.header.setErrCode(constant.ERR_CODE_INVALID_PARAM);
        result.header.errMsg = constant.ERR_MSG_INVALID_PARAM;
        callback(result);
        console.log('In valid param');
        return;
    }
    const nowTimeStr = MXRUtility.nowTimeString();
    params['UUID'] = uuidv1();
    params['createTime'] = nowTimeStr;
    params['updateTime'] = nowTimeStr;
    const sql = db.buildSql("INSERT", constant.TABLE_USER_FRIENDSHIP_GROUP, params);
    db.querySql(sql, null, function (err, recordset) {
        if (err)
        {
            result.header.setErrCode(constant.ERR_CODE_DEFAULT_1);
            result.header.errMsg = err +'';
            callback(result);
            console.log('create userFriendShipGroup error :' + err);
        }
        else {
            callback(result);
        }
    });
};

/* 创建一个好友
* 'firstUserId':     'int'
* 'secondUserId' :   'int'
* 'groupId':         'int'  //optional
* */
userFriendShipController.createUserFriendShipFriend = async function(params, callback) {
    let result = new MXRResponseModel();
    if (!MXRUtility.verifyParams(params, ['firstUserId', 'firstUserId']))
    {
        result.header.setErrCode(constant.ERR_CODE_INVALID_PARAM);
        result.header.errMsg = constant.ERR_MSG_INVALID_PARAM;
        callback(result);
        console.log('In valid param');
        return;
    }
    let sqlArray = [];
    try {
        let sqlStr = "SELECT *, c.UUID as findGroupId FROM " + constant.TABLE_USER_FRIENDSHIP + " AS a JOIN " + constant.TABLE_USER_FRIENDSHIP_COLLECTION + " AS b ON a.friendCollectionId = b.UUID JOIN " + constant.TABLE_USER_FRIENDSHIP_GROUP + " AS c ON c.UUID = b.friendGroupId JOIN " +constant.TABLE_USER_FRIENDSHIP_FRIEND + " AS d on c.UUID = d.friendGroupId WHERE a.userId = " + params['secondUserId'] + " AND d.userID = " + params['firstUserId'];
        let recordset = await db.querySqlAsync(sqlStr, null);
        if (recordset[constant.DB_KEY_RECORD_SET] && recordset[constant.DB_KEY_ROWS_AFFECTED] > 0)
        {
            result.header.setErrCode(constant.ERR_CODE_DEFAULT_1);
            result.header.errMsg = '已经是好友了';
            callback(result);
            return;
        }

        sqlStr = "SELECT *, c.UUID as findGroupId FROM " + constant.TABLE_USER_FRIENDSHIP + " AS a JOIN " + constant.TABLE_USER_FRIENDSHIP_COLLECTION + " AS b ON a.friendCollectionId = b.UUID JOIN " + constant.TABLE_USER_FRIENDSHIP_GROUP + " AS c ON c.UUID = b.friendGroupId JOIN " +constant.TABLE_USER_FRIENDSHIP_FRIEND + " AS d on c.UUID = d.friendGroupId WHERE a.userId = " + params['firstUserId'] + " AND d.userID = " + params['secondUserId'];
        recordset = await db.querySqlAsync(sqlStr, null);
        if (recordset[constant.DB_KEY_RECORD_SET] && recordset[constant.DB_KEY_ROWS_AFFECTED] > 0)
        {
            result.header.setErrCode(constant.ERR_CODE_DEFAULT_1);
            result.header.errMsg = '已经是好友了';
            callback(result);
            return;
        }

        const nowTimeStr = MXRUtility.nowTimeString();
        sqlStr = db.buildSql("SELECT", constant.TABLE_USER_FRIENDSHIP, null, {'userId':params['firstUserId']});
        recordset = await db.querySqlAsync(sqlStr,null);
        console.log('>>>>>>>>');
        console.log(recordset);
        if (recordset[constant.DB_KEY_RECORD_SET] && recordset[constant.DB_KEY_ROWS_AFFECTED] > 0)
        {
            const collecitonId = recordset[constant.DB_KEY_RECORD_SET][0]['UUID'];
            sqlStr = "SELECT *, c.UUID as findGroupId FROM " + constant.TABLE_USER_FRIENDSHIP + " AS a JOIN " + constant.TABLE_USER_FRIENDSHIP_COLLECTION + " AS b ON a.friendCollectionId = b.UUID JOIN " + constant.TABLE_USER_FRIENDSHIP_GROUP + " AS c ON c.UUID = b.friendGroupId where a.userId = " + params['firstUserId'];
            recordset = await db.querySqlAsync(sqlStr, null);
            console.log('>>>>>>>>');
            console.log(recordset);
            if (recordset[constant.DB_KEY_RECORD_SET] && recordset[constant.DB_KEY_ROWS_AFFECTED] > 0)
            {
                const groupId = recordset[constant.DB_KEY_RECORD_SET][0]['findGroupId'];
                // 添加好友位
                sqlStr = db.buildSql("INSERT", constant.TABLE_USER_FRIENDSHIP_FRIEND, {'UUID':uuidv1(), 'userId':params['secondUserId'], 'friendGroupId':groupId, 'createTime':nowTimeStr, 'updateTime':nowTimeStr});
                sqlArray.push(sqlStr);
            }
            else {
                // 有collecitonId 没有groupId,
                // 添加group
                const groupUUID = uuidv1();
                sqlStr = db.buildSql("INSERT", constant.TABLE_USER_FRIENDSHIP_GROUP, {'UUID':groupUUID, 'name':'好友', 'createTime':nowTimeStr, 'updateTime':nowTimeStr});
                sqlArray.push(sqlStr);
                // 添加好友位置
                sqlStr = db.buildSql("INSERT", constant.TABLE_USER_FRIENDSHIP_FRIEND, {'UUID':uuidv1(), 'userId':params['secondUserId'], 'friendGroupId':groupUUID, 'createTime':nowTimeStr, 'updateTime':nowTimeStr});
                sqlArray.push(sqlStr);
            }
        }
        else
        {
            // 没有好友集合
            // 添加group
            const groupUUID = uuidv1();
            sqlStr = db.buildSql("INSERT", constant.TABLE_USER_FRIENDSHIP_GROUP, {'UUID':groupUUID, 'name':'好友', 'createTime':nowTimeStr, 'updateTime':nowTimeStr});
            sqlArray.push(sqlStr);
            // 添加好友位置
            sqlStr = db.buildSql("INSERT", constant.TABLE_USER_FRIENDSHIP_FRIEND, {'UUID':uuidv1(), 'userId':params['secondUserId'], 'friendGroupId':groupUUID, 'createTime':nowTimeStr, 'updateTime':nowTimeStr});
            sqlArray.push(sqlStr);
            // 添加集合记录
            const collectionUUID = uuidv1();
            sqlStr = db.buildSql("INSERT", constant.TABLE_USER_FRIENDSHIP_COLLECTION, {'UUID':collectionUUID, 'friendGroupId':groupUUID, 'createTime':nowTimeStr, 'updateTime':nowTimeStr});
            sqlArray.push(sqlStr);
            // 添加好友集合记录
            sqlStr = db.buildSql("INSERT", constant.TABLE_USER_FRIENDSHIP, {'UUID':uuidv1(), 'userId':params['firstUserId'], 'friendCollectionId':collectionUUID, 'createTime':nowTimeStr, 'updateTime':nowTimeStr});
            sqlArray.push(sqlStr);
        }


        sqlStr = db.buildSql("SELECT", constant.TABLE_USER_FRIENDSHIP, null, {'userId':params['secondUserId']});
        recordset = await db.querySqlAsync(sqlStr,null);
        console.log('>>>>>>>>');
        console.log(recordset);
        if (recordset[constant.DB_KEY_RECORD_SET] && recordset[constant.DB_KEY_ROWS_AFFECTED] > 0)
        {
            const collecitonId = recordset[constant.DB_KEY_RECORD_SET][0]['UUID'];
            sqlStr = "SELECT *, c.UUID as findGroupId FROM " + constant.TABLE_USER_FRIENDSHIP + " AS a JOIN " + constant.TABLE_USER_FRIENDSHIP_COLLECTION + " AS b ON a.friendCollectionId = b.UUID JOIN " + constant.TABLE_USER_FRIENDSHIP_GROUP + " AS c ON c.UUID = b.friendGroupId where a.userId = " + params['secondUserId'];
            recordset = await db.querySqlAsync(sqlStr, null);
            console.log('>>>>>>>>');
            console.log(recordset);
            if (recordset[constant.DB_KEY_RECORD_SET] && recordset[constant.DB_KEY_ROWS_AFFECTED] > 0)
            {
                const groupId = recordset[constant.DB_KEY_RECORD_SET][0]['findGroupId'];
                // 添加好友位
                sqlStr = db.buildSql("INSERT", constant.TABLE_USER_FRIENDSHIP_FRIEND, {'UUID':uuidv1(), 'userId':params['firstUserId'], 'friendGroupId':groupId, 'createTime':nowTimeStr, 'updateTime':nowTimeStr});
                sqlArray.push(sqlStr);
            }
            else {
                // 有collecitonId 没有groupId,
                // 添加group
                const groupUUID = uuidv1();
                sqlStr = db.buildSql("INSERT", constant.TABLE_USER_FRIENDSHIP_GROUP, {'UUID':groupUUID, 'name':'好友', 'createTime':nowTimeStr, 'updateTime':nowTimeStr});
                sqlArray.push(sqlStr);
                // 添加好友位置
                sqlStr = db.buildSql("INSERT", constant.TABLE_USER_FRIENDSHIP_FRIEND, {'UUID':uuidv1(), 'userId':params['firstUserId'], 'friendGroupId':groupUUID, 'createTime':nowTimeStr, 'updateTime':nowTimeStr});
                sqlArray.push(sqlStr);
            }
        }
        else
        {
            // 没有好友集合
            // 添加group
            const groupUUID = uuidv1();
            sqlStr = db.buildSql("INSERT", constant.TABLE_USER_FRIENDSHIP_GROUP, {'UUID':groupUUID, 'name':'好友', 'createTime':nowTimeStr, 'updateTime':nowTimeStr});
            sqlArray.push(sqlStr);
            // 添加好友位置
            sqlStr = db.buildSql("INSERT", constant.TABLE_USER_FRIENDSHIP_FRIEND, {'UUID':uuidv1(), 'userId':params['firstUserId'], 'friendGroupId':groupUUID, 'createTime':nowTimeStr, 'updateTime':nowTimeStr});
            sqlArray.push(sqlStr);
            // 添加集合记录
            const collectionUUID = uuidv1();
            sqlStr = db.buildSql("INSERT", constant.TABLE_USER_FRIENDSHIP_COLLECTION, {'UUID':collectionUUID, 'friendGroupId':groupUUID, 'createTime':nowTimeStr, 'updateTime':nowTimeStr});
            sqlArray.push(sqlStr);
            // 添加好友集合记录
            sqlStr = db.buildSql("INSERT", constant.TABLE_USER_FRIENDSHIP, {'UUID':uuidv1(), 'userId':params['secondUserId'], 'friendCollectionId':collectionUUID, 'createTime':nowTimeStr, 'updateTime':nowTimeStr});
            sqlArray.push(sqlStr);
        }

        db.transactionExcute(sqlArray, function (err, res) {
            if (err){
                result.header.setErrCode(constant.ERR_CODE_DEFAULT_1);
                result.header.errMsg = err +'';
                callback(result);
                console.log('create userFriendShipGroup error :' + err);
            }
            else
            {
                callback(result);
            }
        });
    }
    catch (err) {
        result.header.setErrCode(constant.ERR_CODE_DEFAULT_1);
        result.header.errMsg = err + '';
        callback(result);
        return;
    }
};

/*接受好友邀请
*   'invitedUserId':    'int'
* 'invitationUUID':     'string'
* */
userFriendShipController.acceptFriendInvitation = async function (params, callback) {
    console.log('>>>>> 11111111111\n\n');
    console.log(params);
    let result = new MXRResponseModel();
    if (!MXRUtility.verifyParams(params, ['invitedUserId', 'invitationUUID']))
    {
        result.header.setErrCode(constant.ERR_CODE_INVALID_PARAM);
        result.header.errMsg = constant.ERR_MSG_INVALID_PARAM;
        callback(result);
        console.log('In valid param');
        return;
    }
    try {
        const invitationUUID = params['invitationUUID'], type = 0;
        let recordSet = await userFriendShipController.db_selectInvitationData(invitationUUID, type);
        console.log('>>>>> 2222222\n\n');
        if (recordSet[constant.DB_KEY_ROWS_AFFECTED] >= 1)
        {
            const userId = recordSet[constant.DB_KEY_RECORD_SET][0]['userId'];
            const invitedUserId = recordSet[constant.DB_KEY_RECORD_SET][0]['invitedUserId'];

            params['firstUserId'] = userId;
            params['secondUserId'] = invitedUserId;

            console.log('>>>>> 3333333\n\n');
            console.log(params);

            if (invitedUserId !== params['invitedUserId'])
            {
                result.header.setErrCode(constant.ERR_CODE_DEFAULT_1);
                result.header.errMsg =  '发生错误，请稍后再试';
                callback(result);
                return;
            }
            let sqlArray = [];
            const updateInvitationSql = db.buildSql("UPDATE", constant.TABLE_USER_FRIENDSHIP_INVITATION, {'type':1, 'updateTime':MXRUtility.nowTimeString()}, {'UUID':params['invitationUUID']});
            sqlArray.push(updateInvitationSql);

            let sqlStr = "SELECT *, c.UUID as findGroupId FROM " + constant.TABLE_USER_FRIENDSHIP + " AS a JOIN " + constant.TABLE_USER_FRIENDSHIP_COLLECTION + " AS b ON a.friendCollectionId = b.UUID JOIN " + constant.TABLE_USER_FRIENDSHIP_GROUP + " AS c ON c.UUID = b.friendGroupId JOIN " +constant.TABLE_USER_FRIENDSHIP_FRIEND + " AS d on c.UUID = d.friendGroupId WHERE a.userId = " + params['secondUserId'] + " AND d.userID = " + params['firstUserId'];
            let recordset = await db.querySqlAsync(sqlStr, null);
            if (recordset[constant.DB_KEY_RECORD_SET] && recordset[constant.DB_KEY_ROWS_AFFECTED] > 0)
            {
                result.header.setErrCode(constant.ERR_CODE_DEFAULT_1);
                result.header.errMsg = '已经是好友了';
                callback(result);
                return;
            }

            sqlStr = "SELECT *, c.UUID as findGroupId FROM " + constant.TABLE_USER_FRIENDSHIP + " AS a JOIN " + constant.TABLE_USER_FRIENDSHIP_COLLECTION + " AS b ON a.friendCollectionId = b.UUID JOIN " + constant.TABLE_USER_FRIENDSHIP_GROUP + " AS c ON c.UUID = b.friendGroupId JOIN " +constant.TABLE_USER_FRIENDSHIP_FRIEND + " AS d on c.UUID = d.friendGroupId WHERE a.userId = " + params['firstUserId'] + " AND d.userID = " + params['secondUserId'];
            recordset = await db.querySqlAsync(sqlStr, null);
            if (recordset[constant.DB_KEY_RECORD_SET] && recordset[constant.DB_KEY_ROWS_AFFECTED] > 0)
            {
                result.header.setErrCode(constant.ERR_CODE_DEFAULT_1);
                result.header.errMsg = '已经是好友了';
                callback(result);
                return;
            }

            const nowTimeStr = MXRUtility.nowTimeString();
            sqlStr = db.buildSql("SELECT", constant.TABLE_USER_FRIENDSHIP, null, {'userId':params['firstUserId']});
            recordset = await db.querySqlAsync(sqlStr,null);
            console.log('>>>>>>>>');
            console.log(recordset);
            if (recordset[constant.DB_KEY_RECORD_SET] && recordset[constant.DB_KEY_ROWS_AFFECTED] > 0)
            {
                const collecitonId = recordset[constant.DB_KEY_RECORD_SET][0]['UUID'];
                sqlStr = "SELECT *, c.UUID as findGroupId FROM " + constant.TABLE_USER_FRIENDSHIP + " AS a JOIN " + constant.TABLE_USER_FRIENDSHIP_COLLECTION + " AS b ON a.friendCollectionId = b.UUID JOIN " + constant.TABLE_USER_FRIENDSHIP_GROUP + " AS c ON c.UUID = b.friendGroupId where a.userId = " + params['firstUserId'];
                recordset = await db.querySqlAsync(sqlStr, null);
                console.log('>>>>>>>>');
                console.log(recordset);
                if (recordset[constant.DB_KEY_RECORD_SET] && recordset[constant.DB_KEY_ROWS_AFFECTED] > 0)
                {
                    const groupId = recordset[constant.DB_KEY_RECORD_SET][0]['findGroupId'];
                    // 添加好友位
                    sqlStr = db.buildSql("INSERT", constant.TABLE_USER_FRIENDSHIP_FRIEND, {'UUID':uuidv1(), 'userId':params['secondUserId'], 'friendGroupId':groupId, 'createTime':nowTimeStr, 'updateTime':nowTimeStr});
                    sqlArray.push(sqlStr);
                }
                else {
                    // 有collecitonId 没有groupId,
                    // 添加group
                    const groupUUID = uuidv1();
                    sqlStr = db.buildSql("INSERT", constant.TABLE_USER_FRIENDSHIP_GROUP, {'UUID':groupUUID, 'name':'好友', 'createTime':nowTimeStr, 'updateTime':nowTimeStr});
                    sqlArray.push(sqlStr);
                    // 添加好友位置
                    sqlStr = db.buildSql("INSERT", constant.TABLE_USER_FRIENDSHIP_FRIEND, {'UUID':uuidv1(), 'userId':params['secondUserId'], 'friendGroupId':groupUUID, 'createTime':nowTimeStr, 'updateTime':nowTimeStr});
                    sqlArray.push(sqlStr);
                }
            }
            else
            {
                // 没有好友集合
                // 添加group
                const groupUUID = uuidv1();
                sqlStr = db.buildSql("INSERT", constant.TABLE_USER_FRIENDSHIP_GROUP, {'UUID':groupUUID, 'name':'好友', 'createTime':nowTimeStr, 'updateTime':nowTimeStr});
                sqlArray.push(sqlStr);
                // 添加好友位置
                sqlStr = db.buildSql("INSERT", constant.TABLE_USER_FRIENDSHIP_FRIEND, {'UUID':uuidv1(), 'userId':params['secondUserId'], 'friendGroupId':groupUUID, 'createTime':nowTimeStr, 'updateTime':nowTimeStr});
                sqlArray.push(sqlStr);
                // 添加集合记录
                const collectionUUID = uuidv1();
                sqlStr = db.buildSql("INSERT", constant.TABLE_USER_FRIENDSHIP_COLLECTION, {'UUID':collectionUUID, 'friendGroupId':groupUUID, 'createTime':nowTimeStr, 'updateTime':nowTimeStr});
                sqlArray.push(sqlStr);
                // 添加好友集合记录
                sqlStr = db.buildSql("INSERT", constant.TABLE_USER_FRIENDSHIP, {'UUID':uuidv1(), 'userId':params['firstUserId'], 'friendCollectionId':collectionUUID, 'createTime':nowTimeStr, 'updateTime':nowTimeStr});
                sqlArray.push(sqlStr);
            }


            sqlStr = db.buildSql("SELECT", constant.TABLE_USER_FRIENDSHIP, null, {'userId':params['secondUserId']});
            recordset = await db.querySqlAsync(sqlStr,null);
            console.log('>>>>>>>>');
            console.log(recordset);
            if (recordset[constant.DB_KEY_RECORD_SET] && recordset[constant.DB_KEY_ROWS_AFFECTED] > 0)
            {
                const collecitonId = recordset[constant.DB_KEY_RECORD_SET][0]['UUID'];
                sqlStr = "SELECT *, c.UUID as findGroupId FROM " + constant.TABLE_USER_FRIENDSHIP + " AS a JOIN " + constant.TABLE_USER_FRIENDSHIP_COLLECTION + " AS b ON a.friendCollectionId = b.UUID JOIN " + constant.TABLE_USER_FRIENDSHIP_GROUP + " AS c ON c.UUID = b.friendGroupId where a.userId = " + params['secondUserId'];
                recordset = await db.querySqlAsync(sqlStr, null);
                console.log('>>>>>>>>');
                console.log(recordset);
                if (recordset[constant.DB_KEY_RECORD_SET] && recordset[constant.DB_KEY_ROWS_AFFECTED] > 0)
                {
                    const groupId = recordset[constant.DB_KEY_RECORD_SET][0]['findGroupId'];
                    // 添加好友位
                    sqlStr = db.buildSql("INSERT", constant.TABLE_USER_FRIENDSHIP_FRIEND, {'UUID':uuidv1(), 'userId':params['firstUserId'], 'friendGroupId':groupId, 'createTime':nowTimeStr, 'updateTime':nowTimeStr});
                    sqlArray.push(sqlStr);
                }
                else {
                    // 有collecitonId 没有groupId,
                    // 添加group
                    const groupUUID = uuidv1();
                    sqlStr = db.buildSql("INSERT", constant.TABLE_USER_FRIENDSHIP_GROUP, {'UUID':groupUUID, 'name':'好友', 'createTime':nowTimeStr, 'updateTime':nowTimeStr});
                    sqlArray.push(sqlStr);
                    // 添加好友位置
                    sqlStr = db.buildSql("INSERT", constant.TABLE_USER_FRIENDSHIP_FRIEND, {'UUID':uuidv1(), 'userId':params['firstUserId'], 'friendGroupId':groupUUID, 'createTime':nowTimeStr, 'updateTime':nowTimeStr});
                    sqlArray.push(sqlStr);
                }
            }
            else
            {
                // 没有好友集合
                // 添加group
                const groupUUID = uuidv1();
                sqlStr = db.buildSql("INSERT", constant.TABLE_USER_FRIENDSHIP_GROUP, {'UUID':groupUUID, 'name':'好友', 'createTime':nowTimeStr, 'updateTime':nowTimeStr});
                sqlArray.push(sqlStr);
                // 添加好友位置
                sqlStr = db.buildSql("INSERT", constant.TABLE_USER_FRIENDSHIP_FRIEND, {'UUID':uuidv1(), 'userId':params['firstUserId'], 'friendGroupId':groupUUID, 'createTime':nowTimeStr, 'updateTime':nowTimeStr});
                sqlArray.push(sqlStr);
                // 添加集合记录
                const collectionUUID = uuidv1();
                sqlStr = db.buildSql("INSERT", constant.TABLE_USER_FRIENDSHIP_COLLECTION, {'UUID':collectionUUID, 'friendGroupId':groupUUID, 'createTime':nowTimeStr, 'updateTime':nowTimeStr});
                sqlArray.push(sqlStr);
                // 添加好友集合记录
                sqlStr = db.buildSql("INSERT", constant.TABLE_USER_FRIENDSHIP, {'UUID':uuidv1(), 'userId':params['secondUserId'], 'friendCollectionId':collectionUUID, 'createTime':nowTimeStr, 'updateTime':nowTimeStr});
                sqlArray.push(sqlStr);
            }

            // 添加好友事务
            db.transactionExcute(sqlArray, function (err, res) {
                if (err){
                    result.header.setErrCode(constant.ERR_CODE_DEFAULT_1);
                    result.header.errMsg = err +'';
                    callback(result);
                    console.log('create userFriendShipGroup error :' + err);
                }
                else
                {
                    callback(result);
                }
            });

        }
        else
        {
            result.header.setErrCode(constant.ERR_CODE_DEFAULT_1);
            result.header.errMsg = '接受异常，请重试';
        }
    }
    catch (err)
    {
        result.header.setErrCode(constant.ERR_CODE_DEFAULT_1);
        result.header.errMsg = err + '';
        callback(result);
    }


}

/* 根据userId获取其相关的好友邀请记录
*   'invitedUserId':       'int'
*   'pageIndex':            'int'  optional
*   'pageSize':             'int'  optional
* */
userFriendShipController.getReceiveInvitations = async function (params, callback) {
    let result = new MXRResponseModel();
    if (!MXRUtility.verifyParams(params, ['invitedUserId']))
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

    // const selectSql = db.buildSql("SELECT", constant.TABLE_USER_FRIENDSHIP_INVITATION, null, {'invitedUserId':params['invitedUserId']}, "ID");
    const invitedUserId = params['invitedUserId'], pageIndex = params['pageIndex'], pageSize = params['pageSize'];
    try {
        let recordSet = await userFriendShipController.db_selectReceiveInvitationListData(invitedUserId, pageIndex, pageSize);
        if (recordSet && Array.isArray(recordSet[constant.DB_KEY_RECORD_SET]))
        {
            result.body = recordSet[constant.DB_KEY_RECORD_SET];
            callback(result);
        }
        else
        {
            callback(result);
        }
    }
    catch (err) {
        result.header.setErrCode(constant.ERR_CODE_DEFAULT_1);
        result.header.errMsg = err + '';
        callback(result);
    }
};

/* 发送好友邀请
 *
 * 'userId':   'int'
 * 'invitedUserId:   'int'
 * 'content':       'string' optional
 */
userFriendShipController.sendFriendInvitation = async function (params, callback) {
    let result = new MXRResponseModel();
    if (!MXRUtility.verifyParams(params, ['userId', 'invitedUserId']))
    {
        result.header.setErrCode(constant.ERR_CODE_INVALID_PARAM);
        result.header.errMsg = constant.ERR_MSG_INVALID_PARAM;
        callback(result);
        console.log('In valid param');
        return;
    }
    const userId = params['userId'], otherUserId = params['invitedUserId'];
    result = new MXRResponseModel();
    try
    {
        let recordSet = await userFriendShipController.db_selectFriendData(userId, otherUserId);
        if (recordSet[constant.DB_KEY_RECORD_SET] && recordSet[constant.DB_KEY_ROWS_AFFECTED] > 0)
        {
            result.header.setErrCode(constant.ERR_CODE_INVALID_PARAM);
            result.header.errMsg = '已经是好友了';
            callback(result);
            return;
        }

        const nowTimeStr = MXRUtility.nowTimeString();
        let insertParams = {'UUID':uuidv1(),
            'userId':params['userId'],
            'invitedUserId':params['invitedUserId'],
            'content': (typeof params['content'] === 'string' ? params['content'] : ''),
            'createTime':nowTimeStr,
            'updateTime':nowTimeStr};
        const insertSql = db.buildSql("INSERT", constant.TABLE_USER_FRIENDSHIP_INVITATION, insertParams);
        db.querySql(insertSql, null, function (err, recordSet) {
            if (err)
            {
                result.header.setErrCode(constant.ERR_CODE_DEFAULT_1);
                result.header.errMsg = err + '';
                callback(result);
            }
            else {
                if (recordSet[constant.DB_KEY_ROWS_AFFECTED] <= 0)
                {
                    result.header.setErrCode(constant.ERR_CODE_DEFAULT_1);
                    result.header.errMsg = '发送邀请失败';
                }
                callback(result);
            }
        })
    }
    catch(err) {
        result.header.setErrCode(constant.ERR_CODE_DEFAULT_1);
        result.header.errMsg = err + '';
        callback(result);
    }
};

/*两人之间的关系 0:无关系 1:好友关系 2:用户A给用户B发送过好友邀请
 *
 * ‘userId' :        'int'
 * 'otherId' :       'int'
 * */
userFriendShipController.getFriendshipBetweenUsers = async function (params, callback) {
    let result = new MXRResponseModel();
    if (!MXRUtility.verifyParams(params, ['userId', 'otherUserId']))
    {
        result.header.setErrCode(constant.ERR_CODE_INVALID_PARAM);
        result.header.errMsg = constant.ERR_MSG_INVALID_PARAM;
        callback(result);
        console.log('In valid param');
        return;
    }
    const userId = params['userId'];
    const otherUserId = params['otherUserId'];

    try {
        let recordSet = await userFriendShipController.db_selectFriendData(userId, otherUserId);
        let friendshipJson = {'friendship': 0};
        if (recordSet[constant.DB_KEY_RECORD_SET] && recordSet[constant.DB_KEY_ROWS_AFFECTED] > 0) {
            friendshipJson = {'friendship': 1};
            result.body = friendshipJson;
            callback(result);
            return;
        }
        recordSet = await  userFriendShipController.db_selectSendInvitationData(userId, otherUserId);
        if (recordSet[constant.DB_KEY_RECORD_SET] && recordSet[constant.DB_KEY_ROWS_AFFECTED] > 0) {
            friendshipJson = {'friendship': 2};
            result.body = friendshipJson;
            callback(result);
            return;
        }
        friendshipJson = {'friendship': 0};
        result.body = friendshipJson;
        callback(result);

    } catch (err) {
        result.header.setErrCode(constant.ERR_CODE_DEFAULT_1);
        result.header.errMsg = err + '';
        callback(result);
    }
};

/* 获取用户的所有好友列表
 *   'userId'：       'int',
 * */
userFriendShipController.getFriendListUserInfo = async function (params, callback) {
    let result = new MXRResponseModel();
    if (!MXRUtility.verifyParams(params, ['userId']))
    {
        result.header.setErrCode(constant.ERR_CODE_INVALID_PARAM);
        result.header.errMsg = constant.ERR_MSG_INVALID_PARAM;
        callback(result);
        console.log('In valid param');
        return;
    }
    const userId = params['userId'];
    try {
        let recordSet = await userFriendShipController.db_selectFriendListUserInfoData(userId);
        result.body = recordSet[constant.DB_KEY_RECORD_SET];
        callback(result);
    }
    catch (err) {
        result.header.setErrCode(constant.ERR_CODE_DEFAULT_1);
        result.header.errMsg = '' + err;
        callback(result);
    }
}

/* 根据两个用户标识获取这两个人成为好友条件的记录。
*  ‘userId' :        'int'
*  'otherUserId' :       'int'
* */
userFriendShipController.db_selectFriendData = async function (userId, otherUserId) {
    const friendSql = "SELECT *, c.UUID as findGroupId FROM " + constant.TABLE_USER_FRIENDSHIP + " AS a JOIN " + constant.TABLE_USER_FRIENDSHIP_COLLECTION + " AS b ON a.friendCollectionId = b.UUID JOIN " + constant.TABLE_USER_FRIENDSHIP_GROUP + " AS c ON c.UUID = b.friendGroupId JOIN " + constant.TABLE_USER_FRIENDSHIP_FRIEND + " AS d on c.UUID = d.friendGroupId WHERE a.userId = " + userId + " AND d.userID = " + otherUserId;
    let recordSet = await db.querySqlAsync(friendSql);
    return recordSet;
};

/* 根据两个用户标识获取前者发送给后者的好友邀请记录（type 为 0 的数据）
 *  ‘userId' :        'int'
 *  'otherUserId' :       'int'
 * */
userFriendShipController.db_selectSendInvitationData = async function (userId, otherUserId) {
    let conditionJson = {'userId': userId,
        'invitedUserId': otherUserId,
        'type':0};
    const isSendInvitationSql = db.buildSql("SELECT", constant.TABLE_USER_FRIENDSHIP_INVITATION, null, conditionJson);
    let recordSet = await db.querySqlAsync(isSendInvitationSql);
    return recordSet;
};

/* 获取某个用户被邀请的记录列表
* userId：       'int'
* pageIndex:    'int'
* pageSize:     'int'
* */
userFriendShipController.db_selectReceiveInvitationListData = async function (invitedUserId, pageIndex, pageSize) {
    // SELECT *,  CONVERT(varchar(100), invitationT.createTime, 20) as createTime2, CONVERT(varchar(100), invitationT.updateTime, 20) FROM [userdata].[dbo].UserInfo
    // AS userT JOIN [mxr_IM].[dbo].T_User_FriendShip_Invitation
    // AS invitationT ON userT.userID = invitationT.invitedUserId where invitationT.invitedUserId = 122934
    const selectSql = "SELECT userT.*,invitationT.ID as testID, invitationT.UUID, invitationT.invitedUserId, invitationT.userId as myUserId, invitationT.content, invitationT.status, invitationT.type, CONVERT(varchar(100), invitationT.createTime, 20) as createTime2, CONVERT(varchar(100), invitationT.updateTime, 20) as updateTime2 FROM " + constant.TABLE_USER_INFO +
        " AS userT JOIN " + constant.TABLE_USER_FRIENDSHIP_INVITATION +
        " as invitationT ON userT.userID = invitationT.userId" +
        " WHERE invitationT.invitedUserId = " + invitedUserId + " and type = 0";
    const selectPageSql = db.buildPageSelectSql(selectSql, "testID DESC", pageIndex, pageSize);
    let  recordSet = await db.querySqlAsync(selectPageSql);
    return recordSet;

};

/* 获取邀请好友的一个表单记录
*   'invitationUUID':       'string',
*   'type'：                 'int',
* */
userFriendShipController.db_selectInvitationData = async function (invitationUUID, type) {
    if (type === null) type = 0;
    const selectInvitationSql = db.buildSql("SELECT", constant.TABLE_USER_FRIENDSHIP_INVITATION, null, {'UUID':invitationUUID,'type':type});
    let recordSet = await db.querySqlAsync(selectInvitationSql);
    return recordSet;
};

/* 获取用户的所有好友列表
*   'userId'：       'int',
* */
userFriendShipController.db_selectFriendListUserInfoData = async function (userId) {
    const userIDS = "(SELECT  d.userId FROM " + constant.TABLE_USER_FRIENDSHIP + " AS a JOIN " + constant.TABLE_USER_FRIENDSHIP_COLLECTION + " AS b ON a.friendCollectionId = b.UUID JOIN " + constant.TABLE_USER_FRIENDSHIP_GROUP + " AS c ON c.UUID = b.friendGroupId JOIN " + constant.TABLE_USER_FRIENDSHIP_FRIEND + " AS d on c.UUID = d.friendGroupId WHERE d.type = 0 and  a.userId = " + userId +")";
    const selectUserInfoListSql = "SELECT * FROM " + constant.TABLE_USER_INFO + " WHERE userID IN " + userIDS;
    let recordSet = await db.querySqlAsync(selectUserInfoListSql);
    return recordSet;
};

module.exports = userFriendShipController;
