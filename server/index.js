/**
 * Created by Martin on 2017/8/30.
 */
// 全局处理错误
process.on('uncaughtException', function (err) {
    console.error(err);
});

const constant = require('./lib/constant');
const MXRChatController = require('./lib/express/controller/mxr_chat_controller');

const MXRSocketMessagePacket = require('./lib/socket/model/mxr_socket_message_model');
/*注册增加对聊天室信息的处理的中间件*/
const addHandleChatMid = require('./lib/socket/controller/mxr_socket_controller_chat');
addHandleChatMid();

//在线用户
let wsSockets = {};

let WebSocketServer = require('ws').Server,
    wss = new WebSocketServer({port: 8181});

const MXRSocketController = require('./lib/socket/mxr_socket_controller');
const socketController = MXRSocketController();
wss.on('connection', function (ws, req) {
    const ip = req.connection.remoteAddress;
    const uuid = (require('crypto').randomBytes(16)).toString('hex');
    let userId = undefined;
    ws.uuid = uuid;
    wsSockets[uuid] = ws;
    // wsSockets.push({
    //     'uuid':uuid,
    //     'ws':ws,
    // });
    ws.uuid = uuid;
    console.log('client connected '+ip);
    ws.on('message', function (message) {
        if (ws.readyState === 1) {
            let socketMessage = new MXRSocketMessagePacket.MXRSocketMessage();
            socketMessage.setData(JSON.parse(message).params);
            if (socketMessage.getUserId())
            {
                if (socketMessage.getType() == constant.SOCKET_MESSAGE_TYPE_SendUserId)
                {
                    console.log(socketMessage.getUserId() + '绑定到socket上');
                    delete wsSockets[uuid];
                    userId = socketMessage.getUserId()
                    ws.userId = userId;
                    wsSockets[userId] = ws;
                    ws.send(message);
                    return;
                }
            }
            var handleEnd = socketController.handelMessage(message, ws, wsSockets);
            if (!handleEnd)
            {
                broadcast(message, ws);
            }
        }
        else
        {
            ws.close();
        }
    });

    ws.on('close', function (ws) {
        closeSocket();
    });

    function closeSocket() {
        let socket = wsSockets[uuid];
        if (socket && socket.readyState !== 1)
        {
            broadcast(JSON.stringify({'type':'sendMsg','params':uuid+'断开连接' + ', userId:' + userId}));
            delete wsSockets[uuid];
        }
        socket = wsSockets[userId];
        if (socket && socket.readyState !== 1)
        {
            broadcast(JSON.stringify({'type':'sendMsg','params':uuid+'断开连接' + ', userId:' + userId}));
            delete wsSockets[userId];
        }
        // for(var i = 0; i < wsSockets.length; i++) {
        //     if(wsSockets[i].uuid == uuid) {
        //         broadcast(JSON.stringify({'type':'sendMsg','params':uuid+'断开连接'}));
        //         wsSockets.splice(i, 1);
        //     }
        //     if (wsSockets[i] && wsSockets[i].ws.readyState !== 1)
        //     {
        //         wsSockets.splice(i, 1);
        //     }
        // }
    }
});

function broadcast(msg, socket) {
    // console.log(msg);
    for (let key in wsSockets)
    {
        let ws = wsSockets[key];
        if (ws.readyState === 1 && ws !== socket) {
            ws.send(msg);
        }
    }
    // wsSockets.forEach(function (obj) {
    //     var ws = obj.ws;
    //     if (ws.readyState === 1 && ws !== socket) {
    //         ws.send(msg);
    //     }
    // });
};


/*
 * express
 * DEBUG=express:* node fileserver.js   可以看到express的一些debug的信息
 * */
const express = require('express');
const app = express();

const mxr_express_IM = require('./lib/express/mxr_express_IM');

const host = '192.168.2.3';
const port = '3000';
const serverURL = 'http://' + host + ':' + port;

const bodyParser = require('body-parser');
app.use(bodyParser());
app.use(express.static(__dirname));

const MXRUploadFileInstance = require('./lib/middleware/middleware-upload-file');
const uploadTempFile = MXRUploadFileInstance({ dest: './resource/uploads/bookmodule/temp' });
// var uploadChatImageFile = MXRUploadFileInstance({ dest: './resource/uploads/chat/images' });
const MXRResponseModel = require('./lib/express/model/mxr-base-response-model');

app.post('/uploadFile', uploadTempFile.single('file'), function (req, res, next) {
    // req.body contains the text fields
    console.log('file:'+JSON.stringify(req.file));
    // console.log('body:'+req.body);
    if (req.file.uplodSuccessFilePath)
    {
        let result = new MXRResponseModel();
        result.body = {filePath:serverURL + '/' + req.file.uplodSuccessFilePath};
        res.end(result.toMXRString());
        // 上传成功
    }
    else
    {
        let result = new MXRResponseModel();
        result.header.setErrCode(constant.ERR_CODE_DEFAULT_1);
        result.header.errMsg = 'happened error';
        // 上传失败
        res.status(501);
        res.end(result.toMXRString());
    }
    console.log('filePathSuccess:'+req.file.uplodSuccessFilePath);
});

// 有问题， 用uploadFile 上传图片会传错地方 需要查看
// app.post('/uploadChatImage', uploadChatImageFile.single('chatFile'), function (req, res, next) {
//     // req.body contains the text fields
//     console.log('file:'+JSON.stringify(req.file));
//     // console.log('body:'+req.body);
//     if (req.file.uplodSuccessFilePath)
//     {
//         var result = new MXRResponseModel();
//         result.body = {filePath:serverURL + '/' + req.file.uplodSuccessFilePath};
//         res.end(result.toMXRString());
//         // 上传成功
//     }
//     else
//     {
//         var result = new MXRResponseModel();
//         result.header.errorCode = 1;
//         result.header.errMsg = 'happened error';
//         // 上传失败
//         res.status(501);
//         res.end(result.toMXRString());
//     }
//     console.log('filePathSuccess:'+req.file.uplodSuccessFilePath);
// })

// 聊天相关的服务接口
mxr_express_IM(app);

app.use(function(err, req, res, next) {
    console.error(err.stack);
    res.status(500).send('Something broke!');
});

let server = app.listen(3000, function () {
    const host = server.address().address;
    const port = server.address().port;
    console.log('Example app listening at http://%s:%s', host, port);
});