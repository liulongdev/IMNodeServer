/**
 * Created by Martin on 2017/9/19.
 */

class MXRSqlResultModel{
    constructor(){
    }
}

MXRSqlResultModel.prototype.result = 0;
MXRSqlResultModel.prototype.data = {};
MXRSqlResultModel.prototype.rowCount = 0;
MXRSqlResultModel.errMsg = '';

module.exports = MXRSqlResultModel;