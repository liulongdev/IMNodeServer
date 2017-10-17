/**
 * Created by Martin on 2017/9/27.
 * socket处理数据自定义的中间件管理类
 */

const singleton = Symbol();

function MXRSocketController() {
    if (!(this instanceof MXRSocketController)) {
        if (!this[singleton])
        {
            this[singleton] = new MXRSocketController();
        }
        return this[singleton]
    }
}

MXRSocketController.prototype.socket = null;
MXRSocketController.prototype.sockets = null;
MXRSocketController.prototype.use = use;
MXRSocketController.prototype.stack = [];
MXRSocketController.prototype.next = function () {
    this.isNext = true;
};

MXRSocketController.prototype.handelMessage = function(message, socket, sockets) {
    var isHandleEnd = false;
    socket.isNext = false;
    const length = this.stack.length;
    var messageJson = JSON.parse(message);
    var path = messageJson.type;
    for (var i = 0; i < length; i++)
    {
        var funWrapper = this.stack[i];
        if (funWrapper.path == path)
        {
            funWrapper.fn(message, socket, sockets, function next() {socket.isNext = true});
            if (!socket.isNext)
            {
                isHandleEnd = true;
                break;
            }
        }
    }
    return isHandleEnd;
}


function use(type, fn){
    if (typeof fn !== 'function' || fn.length === 0) {
        var arg = fn;
        throw new TypeError('socket.use() requires middleware functions');
    }
    var midFunWrap = SocketMidFunWrap(type, fn);
    if (midFunWrap.isValid())
    {
        this.stack.push(midFunWrap)
    }
    else
    {
        throw new TypeError('socket.use() requires valid functions' + fn);
    }
}

function SocketMidFunWrap(path, fn) {
    if (!(this instanceof SocketMidFunWrap)) {
        return new SocketMidFunWrap(path, fn);
    }
    this.path = path;
    this.fn = fn;
}

SocketMidFunWrap.prototype.isValid = function isValid() {
    if ((typeof this.path !== 'string' || this.path.length == 0) || typeof this.fn !== 'function'){
        return false;
    }
    return true;
}

module.exports = MXRSocketController;
