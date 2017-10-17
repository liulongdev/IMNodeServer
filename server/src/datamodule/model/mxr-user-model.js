/**
 * Created by Martin on 2017/9/19.
 */

class MXRUserModel{

    constructor(){
        this.userKeyValues = {};
    }

    setData(data) {
        if (typeof data === 'string')
        {
            Object.assign(this.userKeyValues, JSON.parse(data));
        }
        else
            Object.assign(this.userKeyValues, data);
    }

    userID(){
        return this.userKeyValues['userID'];
    }

    setUserID(userID){
        this.userKeyValues['userID'] = userID;
    }

    userName() {
        return this.userKeyValues['userName'];
    }

    setUserName(userName) {
        this.userKeyValues['userName'] = userName;
    }

    userPhone() {
        return this.userKeyValues['userPhone'];
    }

    setUserPhone(userPhone){
        this.userKeyValues['userPhone'] = userPhone;
    }

    userEmail(){
        return this.userKeyValues['userEmail'];
    }

    setUserEmail(userEmail){
        this.userKeyValues['userEmail'] =  userEmail;
    }

    userPwd(){
        return this.userKeyValues['userPwd'];
    }

    setUserPwd(userPwd){
        this.userKeyValues['userPwd'] = userPwd;
    }

    createData(){
        return this.userKeyValues['createData'];
    }

    setCreateData(createData){
        this.userKeyValues['createData'] = createData;
    }

    createDate(){
        return this.userKeyValues['createDate'];
    }

    setCreateDate(createDate){
        this.userKeyValues['createDate'] = createDate;
    }

    isActivated(){
        return this.userKeyValues['isActivated'];
    }

    setIsActivated(isActivated){
        this.userKeyValues['isActivated']=  isActivated;
    }

    userType(){
        return this.userKeyValues['userType'];
    }

    setUserType(userType){
        this.userKeyValues['userType'] = userType;
    }

    userSource(){
        return this.userKeyValues['userSource'];
    }

    setUserSource(userSource){
        return this.userKeyValues['userSource'] = userSource;
    }
    userIdentity(){
        return this.userKeyValues['userIdentity'];
    }

    setUserIdentity(userIdentity){
        this.userKeyValues['userIdentity'] =  userIdentity;
    }

}

module.exports = MXRUserModel;