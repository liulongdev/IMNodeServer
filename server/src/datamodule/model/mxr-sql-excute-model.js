/**
 * Created by Martin on 2017/9/19.
 */

var MXRSqlResultModel = require('./mxr-sql-result-model');
var Connection = require('tedious').Connection;
var Request = require('tedious').Request;

class MXRSqlExcuteModel{
    constructor(options)
    {
        this.options = options;
    }

    getSql(sql){
        var connection = new Connection(config);
        connection.on('connect', connected);
        connection.on('infoMessage', infoError);
        connection.on('errorMessage', infoError);
        connection.on('end', end);
        connection.on('debug', debug);
        
    }

}

function connected(err) {
    if (err) {
        console.log(err);
        process.exit(1);
    }

    console.log('connect success');

    process.stdin.resume();

    process.stdin.on('data', function (chunk) {
        exec(chunk);
    });

    process.stdin.on('end', function () {
        process.exit(0);
    });

    //生成sql执行语句,并指定接收数据完毕后执行的回调函数
    var request = new Request('select top 100 * from UserAccount order by userID ASC',function(err,rowCount){
        //判断有没有出错
        if(err){
            console.log(err);
        }
        else rows['rowCount'] = rowCount; //rowCount是语句执行影响行数
        console.log(rows);
        if (rows[0])
        {
            var user = new MXRUserModel();
            user.setData(rows[0]);

            console.log('user : ' + JSON.stringify(user.userKeyValues));
            console.log('userID: ' + user.userID());
        }
        else
        {
            console.log('not find user');
        }


        connection.close();               //记得关闭连接
    });
    var rows = {};
    var n = 0;
    //查询数据返回,select才有返回,每次一行记录
    request.on('row',function(columns){
        console.log('>> observer row');
        rows[n] = {};
        //遍历出列名和值
        columns.forEach(function(s){
            rows[n][s.metadata.colName] = s.value;   //列名和值
        });
        n++;
    });
    //执行状态返回
    request.on('doneProc',function(r,m,status){
        //成功返回0,一般不会用到,在Request的回调判断err即可
        console.log('>> observer doneProc');
        if(status)
            rows = request;
        console.log('>>>> doneProc status' + status);
    });
    //执行语句
    connection.execSql(request);

}

MXRSqlExcuteModel.prototype.options = null;
