/**
 * Created by Martin on 2017/9/27.
 */

class MXRSocketMessage {

    constructor() {
        this.keyValues = {};
    }

    setData(data) {
        if (typeof data === 'string')
        {
            Object.assign(this.keyValues, JSON.parse(data));
        }
        else
            Object.assign(this.keyValues, data);
    }

    getType() {
        return this.keyValues['type'];
    }

    setType(type) {
        this.keyValues['type'] = type;
    }

    getUserId() {
        return this.keyValues['userId'];
    }

    setUserId(userId) {
        this.keyValues['userId'] = userId;
    }
}

class MXRChatRoomSocketMessage extends  MXRSocketMessage {
    getChatRoomId() {
        return this.keyValues['chatRoomId'];
    }

    getContent() {
        return this.keyValues['content'];
    }

    getContentType() {
        return this.keyValues['contentType'];
    }
}

class MXRP2PChatSocketMessage extends  MXRSocketMessage {
    getReceiveUserId() {
        return this.keyValues['receiveUserId'];
    }

    getContent() {
        return this.keyValues['content'];
    }

    getContentType() {
        return this.keyValues['contentType'];
    }
}

module.exports.MXRSocketMessage = MXRSocketMessage;
module.exports.MXRChatRoomSocketMessage = MXRChatRoomSocketMessage;
module.exports.MXRP2PChatSocketMessage = MXRP2PChatSocketMessage;