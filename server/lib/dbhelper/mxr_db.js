/**
 * Created by Martin on 2017/10/13.
 */

const mssql = require("mssql");
const conf = require("./dbconfig.js");
const async = require('async');

var restoreDefaults = function () {
    conf;
};

var getConnection = function(callback){//连接数据库
    if(!callback){
        callback = function(){};
    }
    var con = new mssql.ConnectionPool(conf, function(err) {
        if (err) {
            throw err;
        }
        callback(con);
    });
}

var querySql = function (sql, params, callBack) {//写sql语句自由查询
    getConnection(function(connection){
        var ps = new mssql.PreparedStatement(connection);
        if (params && params != "") {
            for (var index in params) {
                if (typeof params[index] == "number") {
                    ps.input(index, mssql.Int);
                } else if (typeof params[index] == "string") {
                    ps.input(index, mssql.NVarChar);
                }
            }
        }
        ps.prepare(sql, function (err) {
            if (err)
                console.log(err);
            if (params == null) params = '';
            ps.execute(params, function (err, recordset) {
                callBack(err, recordset);
                ps.unprepare(function (err) {
                    if (err)
                        console.log(err);
                });
            });
        });
    });
    restoreDefaults();
};

var querySqlAsync = function (sql, params) {
    return new Promise((resolve, reject) => {
        getConnection(function(connection){
            var ps = new mssql.PreparedStatement(connection);
            if (params && params != "") {
                for (var index in params) {
                    if (typeof params[index] == "number") {
                        ps.input(index, mssql.Int);
                    } else if (typeof params[index] == "string") {
                        ps.input(index, mssql.NVarChar);
                    }
                }
            }

            ps.prepare(sql, function (err) {
                if (err)
                {
                    console.log(err);
                    reject(err);
                }
                if (params == null) param = '';
                ps.execute(params, function (err, recordset) {
                    ps.unprepare(function (err) {
                        if (err)
                            console.log(err);
                    });
                    resolve(recordset);
                });
            });
        });
        restoreDefaults();
    })
}

var select = function (tableName, topNumber, whereSql, params, orderSql, callBack) {//查询该表所有符合条件的数据并可以指定前几个
    getConnection(function(connection) {
        var ps = new mssql.PreparedStatement(connection);
        var sql = "select * from " + tableName + " ";
        if (topNumber && topNumber != "") {
            sql = "select top(" + topNumber + ") * from " + tableName + " ";
        }
        if (whereSql && whereSql != "")
        {
            sql += whereSql + " ";
        }

        if (params && params != "") {
            for (var index in params) {
                if (typeof params[index] == "number") {
                    ps.input(index, mssql.Int);
                } else if (typeof params[index] == "string") {
                    ps.input(index, mssql.NVarChar);
                }
            }
        }
        if (orderSql && orderSql != "")
        {
            sql += orderSql;
        }
        console.log(sql);
        ps.prepare(sql, function (err) {
            if (err)
                console.log(err);
            ps.execute(params, function (err, recordset) {
                callBack(err, recordset);
                ps.unprepare(function (err) {
                    if (err)
                        console.log(err);
                });
            });
        });
    });
    restoreDefaults();
};

var selectAll = function (tableName, callBack) {//查询该表所有数据
    getConnection(function(connection){
        var ps = new mssql.PreparedStatement(connection);
        var sql = "select * from " + tableName + " ";
        ps.prepare(sql, function (err) {
            if (err)
                console.log(err);
            ps.execute("", function (err, recordset) {
                callBack(err, recordset);
                ps.unprepare(function (err) {
                    if (err)
                        console.log(err);
                });
            });
        });
    });
    restoreDefaults();
};

var add = function (addObj, tableName, callBack) {//添加数据
    getConnection(function(connection){
        var ps = new mssql.PreparedStatement(connection);
        var sql = "insert into " + tableName + "(";
        if (addObj && addObj != "") {
            for (var index in addObj) {
                if (typeof addObj[index] == "number") {
                    ps.input(index, mssql.Int);
                } else if (typeof addObj[index] == "string") {
                    ps.input(index, mssql.NVarChar);
                }
                sql += index + ",";
            }
            sql = sql.substring(0, sql.length - 1) + ") values(";
            for (var index in addObj) {
                if (typeof addObj[index] == "number") {
                    sql += addObj[index] + ",";
                } else if (typeof addObj[index] == "string") {
                    sql += "'" + addObj[index] + "'" + ",";
                }
            }
        }
        sql = sql.substring(0, sql.length - 1) + ")";
        ps.prepare(sql, function (err) {
            if (err)
                console.log(err);
            ps.execute(addObj, function (err, recordset) {
                callBack(err, recordset);
                ps.unprepare(function (err) {
                    if (err)
                        console.log(err);
                });
            });
        });
    });
    restoreDefaults();
};

var update = function (updateObj, whereObj, tableName, callBack) {//更新数据
    getConnection(function(connection){
        var ps = new mssql.PreparedStatement(connection);
        var sql = "update " + tableName + " set ";
        if (updateObj && updateObj != "") {
            for (var index in updateObj) {
                if (typeof updateObj[index] == "number") {
                    ps.input(index, mssql.Int);
                    sql += index + "=" + updateObj[index] + ",";
                } else if (typeof updateObj[index] == "string") {
                    ps.input(index, mssql.NVarChar);
                    sql += index + "=" + "'" + updateObj[index] + "'" + ",";
                }
            }
        }
        sql = sql.substring(0, sql.length - 1) + " where ";
        if (whereObj && whereObj != "") {
            for (var index in whereObj) {
                if (typeof whereObj[index] == "number") {
                    ps.input(index, mssql.Int);
                    sql += index + "=" + whereObj[index] + " and ";
                } else if (typeof whereObj[index] == "string") {
                    ps.input(index, mssql.NVarChar);
                    sql += index + "=" + "'" + whereObj[index] + "'" + " and ";
                }
            }
        }
        sql = sql.substring(0, sql.length - 5);
        ps.prepare(sql, function (err) {
            if (err)
                console.log(err);
            ps.execute(updateObj, function (err, recordset) {
                callBack(err, recordset);
                ps.unprepare(function (err) {
                    if (err)
                        console.log(err);
                });
            });
        });
    });
    restoreDefaults();
};

var del = function (whereSql, params, tableName, callBack) {//删除数据
    getConnection(function(connection){
        var ps = new mssql.PreparedStatement(connection);
        var sql = "delete from " + tableName + " ";
        if (params && params != "") {
            for (var index in params) {
                if (typeof params[index] == "number") {
                    ps.input(index, mssql.Int);
                } else if (typeof params[index] == "string") {
                    ps.input(index, mssql.NVarChar);
                }
            }
        }
        sql += whereSql;
        ps.prepare(sql, function (err) {
            if (err)
                console.log(err);
            ps.execute(params, function (err, recordset) {
                callBack(err, recordset);
                ps.unprepare(function (err) {
                    if (err)
                        console.log(err);
                });
            });
        });
    });
    restoreDefaults();
};

var buildSql = function (operation, tableName, params, whereSql, orderBy) {  // , orderBy, groupby, having
    operation = operation.toUpperCase();
    var sql = null;
    if (operation == "SELECT") {  //'DELETE' 'INSERT' 'UPDATE'
        if (params == null) {
            sql = "SELECT * FROM " + tableName;
        }
        else {
            sql = "SELECT "
            var isArray = Array.isArray(params);
            for (var key in params) {
                if (isArray)
                    sql += params[key] + ", ";
                else
                    sql += key + ", ";
            }
            if (sql == "SELECT ")
                sql = "SELECT * FROM ";
            else
                sql = sql.substring(0, sql.length - 2)
            sql += " FROM " + tableName;
        }
        if (whereSql)
        {
            if (typeof whereSql == 'string')
            {
                if (whereSql.toUpperCase().indexOf('WHERE') > -1)
                    sql += " " + whereSql;
                else
                    sql += " WHERE " + whereSql;
            }
            else
            {

                var statement = '';
                for (var key in whereSql)
                {
                    if (typeof whereSql[key] == 'number' || (typeof whereSql[key] == 'string' && whereSql[key].toUpperCase().indexOf('SELECT') > -1)) {
                        statement += ' ' + key + '=' + whereSql[key] + " and";
                    }
                    else{
                        statement += " "  + key + "='" +  whereSql[key] + "' and";
                    }
                }
                if (statement.length > 0){
                    statement = statement.substring(0, statement.length - 4);
                    sql += " WHERE" + statement;
                }
            }
        }
        if (orderBy)
        {
            if (typeof orderBy == 'string')
            {
                if (orderBy.toUpperCase().indexOf('ORDER BY') > -1)
                    sql += " " + orderBy;
                else
                    sql += " ORDER BY " + orderBy;
            }
            else
            {
                var orderByStr = " ORDER BY ";
                var statement = '';
                for (var key in orderBy)
                {
                    if (typeof whereSql[key]) {
                        statement += key + ' ' + orderBy[key] + ", ";
                    }
                }
                if (statement.length > 0){
                    statement = statement.substring(0, statement.length - 2);
                    sql += " ORDER BY " + statement;
                }
            }
        }
    }
    else if(operation == "DELETE")
    {
        sql = "DELETE FROM " + tableName;
        if (whereSql || params)
        {
            if (whereSql == null) {
                whereSql = params
            }
            if (typeof whereSql == 'string')
            {
                if (whereSql.toUpperCase().indexOf('WHERE') > -1)
                    sql += " " + whereSql;
                else
                    sql += " WHERE " + whereSql;
            }
            else
            {
                var statement = '';
                for (var key in whereSql)
                {
                    if (typeof whereSql[key] == 'number' || (typeof whereSql[key] == 'string' && whereSql[key].toUpperCase().indexOf('SELECT') > -1)) {
                        statement += ' ' + key + '=' + whereSql[key] + " and";
                    }
                    else {
                        statement += " "  + key + "='" +  whereSql[key] + "' and";
                    }
                }
                if (statement.length > 0)
                    statement = statement.substring(0, statement.length - 4);
                sql += " WHERE" + statement;
            }
        }
    }
    else if (operation == 'UPDATE')
    {
        sql = "UPDATE " + tableName + " set ";
        if (params) {
            for (var index in params) {
                if (typeof params[index] == 'number' || (typeof params[index] == 'string' && params[index].toUpperCase().indexOf('SELECT') > -1)) {
                    sql +=  index + "=" + params[index] + ", ";
                } else {
                    sql +=  index + "=" + "'" + params[index] + "'" + ", ";
                }
            }
            sql = sql.substring(0, sql.length - 2);
        }
        if (whereSql)
        {
            if (typeof whereSql == 'string')
            {
                if (whereSql.toUpperCase().indexOf('WHERE') > -1)
                    sql += " " + whereSql;
                else
                    sql += " WHERE " + whereSql;
            }
            else
            {
                var statement = '';
                for (var key in whereSql)
                {

                    if (typeof whereSql[key] == 'number' || (typeof whereSql[key] == 'string' && whereSql[key].toUpperCase().indexOf('SELECT') > -1)) {
                        statement += ' ' + key + '=' + whereSql[key] + " and";
                    }
                    else {
                        statement += " "  + key + "='" +  whereSql[key] + "' and";
                    }
                }
                if (statement.length > 0)
                    statement = statement.substring(0, statement.length - 4);
                sql += " WHERE" + statement;
            }
        }
    }
    else if (operation == "INSERT") {
        sql = "INSERT INTO " + tableName + "("

        if (params) {
            for (var key in params) {
                sql += key + ", ";
            }
            sql = sql.substring(0, sql.length - 2) + ") values(";
            for (var index in params) {
                if (typeof params[index] == 'number' || (typeof params[index] == 'string' && params[index].toUpperCase().indexOf('SELECT') > -1)) {
                    sql += params[index] + ", ";
                }
                else  {
                    sql += "'" + params[index] + "'" + ", ";
                }
            }
        }
        sql = sql.substring(0, sql.length - 2) + ")";
        if (whereSql)
        {
            if (typeof whereSql == 'string')
            {
                if (whereSql.toUpperCase().indexOf('WHERE') > -1)
                    sql += " " + whereSql;
                else
                    sql += " WHERE " + whereSql;
            }
            else
            {
                var statement = '';
                for (var key in whereSql)
                {

                    if (typeof whereSql[key] == 'number' || (typeof whereSql[key] == 'string' && whereSql[key].toUpperCase().indexOf('SELECT') > -1)) {
                        statement += ' ' + key + '=' + whereSql[key] + " and";
                    }
                    else {
                        statement += " "  + key + "='" +  whereSql[key] + "' and";
                    }
                }
                if (statement.length > 0)
                    statement = statement.substring(0, statement.length - 4);
                sql += " WHERE" + statement;
            }
        }
    }
    sql += ";"
    return sql;
}

function buildPageSelectSql(table, orderBy, pageIndex, pageSize) {
    var order = "";
    if (orderBy) {
        if (typeof orderBy == 'string') {
            if (orderBy.toUpperCase().indexOf('ORDER BY') > -1)
                order += " " + orderBy;
            else
                order += " ORDER BY " + orderBy;
        }
        else {
            var orderByStr = " ORDER BY ";
            var statement = '';
            for (var key in orderBy) {
                if (typeof whereSql[key]) {
                    statement += key + ' ' + orderBy[key] + ", ";
                }
            }
            if (statement.length > 0) {
                statement = statement.substring(0, statement.length - 2);
                order += " ORDER BY " + statement;
            }
        }
    }
    if (table.indexOf("SELECT") > -1)
    {
        table = "("+table+")a";
    }
    var pageSelectSql = "SELECT * FROM " +
        "(SELECT row_number() OVER(" + order + ")rownumber, * FROM " + table + ")a " +
        "WHERE rownumber >=" + ((pageIndex - 1) * pageSize + 1) + " and rownumber <= " + pageIndex * pageSize;
    return pageSelectSql;
}

function transactionExcute(sqlArray, callBack)
{
    console.log('\n\n\n\n<<< 需要开启事务的sql语句');
    console.log(sqlArray);
    console.log('>>>\n\n\n\n');
    getConnection(function(connection) {
        const transaction = new mssql.Transaction(connection);
        transaction.begin(function (err) {
            if (err){
                console.log('事务开启失败' + err);
                callBack(err, null);
                return;
            }

            var rolledBack = false;

            transaction.on('rollback', function (aborted) {
                console.log('开始回滚， aborted : ', aborted);
                rolledBack = true;
            });

            transaction.on('commit', function () {
                console.log('监听提交');
                rolledBack = true;
            })

            var request = transaction.request();
            var taskArray = [];
            // var 修饰会出现错误？
            for (let key in sqlArray)
            {
                var task = function (subCallback) {
                    request.query(sqlArray[key], function (err, recordset) {
                        if (err) {
                            console.log('事务中的第'+ key +'条出现错误：' + err);
                            subCallback(err, null);
                            return;
                        }
                        console.log("事务中的第" + key + "条执行成功");
                        console.log(recordset)
                        subCallback(null, recordset);
                    });
                };
                taskArray.push(task);
            }

            async.series(taskArray, function (err, result) {
                if (err) {
                    console.log('即将回滚，出现错误: ', err);
                    if (!rolledBack) {
                        // 如果sql语句错误会自动回滚，如果程序错误手动执行回滚，不然事务会一直挂起.
                        transaction.rollback((function (err) {
                            if (err) {
                                console.log('回滚出错： ', err);
                                return;
                            }
                            console.log('回滚成功>>');
                        }))
                    }
                    callBack(err, null);
                }
                else
                {
                    console.log('事务没有错误，执行提交');
                    transaction.commit(function (err) {
                        if (err) {
                            console.log('commit err : ', err);
                            callBack(err, null);
                            return;
                        }
                        else {
                            console.log('提交成功');
                        }
                        callBack(null, null);
                    })
                }
            })

        })
    });
    restoreDefaults();
}

module.exports.config = conf;
module.exports.del = del;
module.exports.select = select;
module.exports.update = update;
module.exports.querySql = querySql;
module.exports.querySqlAsync = querySqlAsync;
module.exports.selectAll = selectAll;
module.exports.restoreDefaults = restoreDefaults;
module.exports.add = add;
module.exports.buildSql = buildSql;
module.exports.buildPageSelectSql = buildPageSelectSql;
module.exports.transactionExcute = transactionExcute;