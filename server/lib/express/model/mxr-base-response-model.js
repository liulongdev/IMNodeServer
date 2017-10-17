/**
 * Created by Martin on 2017/9/11.
 */

class MXRResponseModel
{
    constructor() {
        this.header = new MXRResponseHeaderModel();
        this.body = '';
        this.notCoder = 1;
        this.type = '';
    }

    isSuccess() {
        return this.header.errCode == 0;
    }

    toMXRString() {
        var json = {Header:{ErrCode:this.header.errCode, ErrMsg:this.header.errMsg}, Body: this.body, notCoder: this.notCoder, type: this.type};
        return JSON.stringify(json);
    }
}

class MXRResponseHeaderModel{
    constructor() {
        this.errCode = 0;
        this.errMsg = '';
    }

    setErrCode(errCode) {
        this.errCode = errCode;
    }
}
//
// function MXRResponseModel() {
//     this.header = new MXRResponseHeaderModel();
//     this.body = '';
//     this.notCoder = 1;
//     this.type = '';
// }
//
// function MXRResponseHeaderModel()
// {
//     this.errorCode = 0;
//     this.errMsg = '';
// }
// MXRResponseHeaderModel.prototype.errCode = 0;
// MXRResponseHeaderModel.prototype.errMsg = '';
// MXRResponseHeaderModel.prototype.setErrCode = function (errCode) {
//     this.errCode = errCode;
// }
//
// MXRResponseModel.prototype.header = new MXRResponseHeaderModel();
// MXRResponseModel.prototype.body = '';
// MXRResponseModel.prototype.notCoder = 1;  // test
// MXRResponseModel.prototype.type = '';  // test
// MXRResponseModel.prototype.isSuccess = function () {
//     return this.header.errCode == 0;
// }
//
// MXRResponseModel.prototype.toMXRString = function(){
//     var json = {Header:{errCode:this.header.errorCode, errMsg:this.header.errMsg}, Body: this.body, notCoder: this.notCoder, type: this.type};
//     return JSON.stringify(json);
// }

module.exports = MXRResponseModel