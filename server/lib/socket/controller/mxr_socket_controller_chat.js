/**
 * Created by Martin on 2017/9/27.
 * 对聊天信息处理的方法
 */

// var socketController = new require('../mxr_chat_controller')();
const constant = require('../../constant');
const db = require('../../dbhelper/mxr_db');
const MXRResponseModel = require('../../express/model/mxr-base-response-model');
const MXRUtility = require('../../utility/mxr-utility');
const MXRChatController = require('../../express/controller/mxr_chat_controller');
const MXRSocketChatController = require('../mxr_socket_controller');
const socketController = new MXRSocketChatController();
const MXRSocketMessagePacket = require('../model/mxr_socket_message_model');

let chatRoomDic = {};   // 聊天室相关对象 {`${chatRoomId}`:[]}

function addHandleChatMid(){

    socketController.use(constant.SOCKET_MESSAGE_TYPE_JoinChatRoom, function(message, webSocket, sockets, next){
        // var socketMessage = JSON.parse(message);
        // var chatRoomSocketMessage = new MXRSocketMessagePacket.MXRChatRoomSocketMessage();
        // chatRoomSocketMessage.setData(socketMessage.params);
        // if (!chatRoomDic.hasOwnProperty(chatRoomSocketMessage.chatRoomId))
        // {
        //     chatRoomDic[chatRoomSocketMessage.chatRoomId] = [];
        // }
        // chatRoomDic[chatRoomSocketMessage.chatRoomId].push(chatRoomSocketMessage.getUserId());

        // if (!chatRoomDic[chatRoomSocketMessage.chatRoomId].hasOwnProperty(webSocket.uuid))
        // {
        //     chatRoomDic[chatRoomSocketMessage.chatRoomId][webSocket.uuid] = webSocket;
        // }
        // var response = new MXRResponseModel();
        // response.type = constant.SOCKET_MESSAGE_TYPE_JoinChatRoom;
        // response.body = message;
        // webSocket.send(response.toMXRString());
    });

    /*群聊
    * */
    socketController.use(constant.SOCKET_MESSAGE_TYPE_SendChatRoomMessage, function(message, webSocket, sockets, next){
        let socketMessage = JSON.parse(message);
        let chatRoomSocketMessage = new MXRSocketMessagePacket.MXRChatRoomSocketMessage();
        chatRoomSocketMessage.setData(socketMessage.params);

            MXRChatController.addChatRoomMessage(chatRoomSocketMessage.keyValues, function(response){
                response.type = constant.SOCKET_MESSAGE_TYPE_SendChatRoomMessage;
                // 增加消息到数据库成功
                if (response.isSuccess())
                {
                    // console.log(chatRoomSocketMessage.getChatRoomId());
                    // console.log(message);

                    MXRChatController.getUserIdListInRoom({'chatRoomId':chatRoomSocketMessage.getChatRoomId()}, function (result) {
                        let userIdDicArray = result.body;
                        // [ { userId: 122934 }, { userId: 36202 } ]
                        for (let key in userIdDicArray)
                        {
                            let socket = sockets[userIdDicArray[key].userId];
                            if (socket && socket.readyState == 1)
                            {
                                response.body = socketMessage.params;
                                socket.send(response.toMXRString());
                            }
                        }

                    })
                }
                else
                {
                    response.header.setErrCode(constant.ERR_CODE_DEFAULT_1);
                    response.header.errMsg = '插入消息失败';
                    webSocket.send(response.toMXRString());
                }
            })

    });

    /*P2P聊天
    * */
    socketController.use(constant.SOCKET_MESSAGE_TYPE_SendP2PChatMessage, function(message, webSocket, sockets, next){
        let socketMessage = JSON.parse(message);
        let p2pChatSocketMessage = new MXRSocketMessagePacket.MXRP2PChatSocketMessage();
        p2pChatSocketMessage.setData(socketMessage.params);

        const userId = p2pChatSocketMessage.getUserId(), receiveUSerId = p2pChatSocketMessage.getReceiveUserId();
        let socket = sockets[receiveUSerId];
        if (socket && socket.readyState == 1)
        {
            let response = new MXRResponseModel();
            response.type = constant.SOCKET_MESSAGE_TYPE_SendP2PChatMessage;
            response.body = socketMessage.params;
            socket.send(response.toMXRString());
        }
        return;

        MXRChatController.addP2PChatMessage(p2pChatSocketMessage.keyValues, function(response){
            response.type = constant.SOCKET_MESSAGE_TYPE_SendP2PChatMessage;
            // 增加消息到数据库成功
            if (response.isSuccess())
            {
                // console.log(chatRoomSocketMessage.getChatRoomId());
                // console.log(message);
                let userIdDicArray = [p2pChatSocketMessage.getUserId(), p2pChatSocketMessage.getReceiveUserId()];
                for (let key in userIdDicArray)
                {
                    let socket = sockets[userIdDicArray[key]];
                    if (socket && socket.readyState == 1)
                    {
                        response.body = socketMessage.params;
                        socket.send(response.toMXRString());
                    }
                }
            }
            else
            {
                response.header.setErrCode(constant.ERR_CODE_DEFAULT_1);
                response.header.errMsg = '插入消息失败';
                webSocket.send(response.toMXRString());
            }
        })

    });

}

module.exports = addHandleChatMid;
