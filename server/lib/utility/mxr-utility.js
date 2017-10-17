/**
 * Created by Martin on 2017/9/21.
 */

var MXRUtility = {};

/*返回现在时刻的时间字符串，格式为 yyyy-MM-dd hh:mm:ss*/
MXRUtility.nowTimeString = function() {
    var date = new Date();
    var time = date.getFullYear() + "-" + (date.getMonth() < 10 ? '0' + (date.getMonth()+1) : (date.getMonth()+1)) + "-" + (date.getDate() < 10 ? '0' + date.getDate() : date.getDate()) + " " + (date.getHours() < 10 ? '0' + date.getHours() : date.getHours()) + ":" + (date.getMinutes() < 10 ? '0' + date.getMinutes() : date.getMinutes()) + ":" + (date.getSeconds() < 10 ? '0' + date.getSeconds() : date.getSeconds());
    // var time = date.getUTCFullYear() + "-" + (date.getUTCMonth() < 10 ? '0' + (date.getUTCMonth()+1) : (date.getUTCMonth()+1)) + "-" + (date.getUTCDate() < 10 ? '0' + date.getUTCDate() : date.getUTCDate()) + " " + (date.getUTCHours() < 10 ? '0' + date.getUTCHours() : date.getUTCHours()) + ":" + (date.getUTCMinutes() < 10 ? '0' + date.getUTCMinutes() : date.getUTCMinutes()) + ":" + (date.getUTCSeconds() < 10 ? '0' + date.getUTCSeconds() : date.getUTCSeconds());
    return time;
}

/*判断params的属性集合是否包含keyArray里面所有值*/
MXRUtility.verifyParams = function (params, keyArray) {
    for (let index in keyArray)
    {
        if (!params.hasOwnProperty(keyArray[index]))
        {
            return false;
        }
    }
    return true;
}

module.exports = MXRUtility;