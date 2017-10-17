/**
 * Created by Martin on 2017/9/19.
 */

var dbConfig = {
    user: 'sa',
    password: '$MXR02%',
    server: '192.168.0.43',
    database: 'mxr_IM',
    port: 1433,
    options: {
        // encrypt: true // Use this if you're on Windows Azure
    },
    pool: {
        min: 0,
        max: 10,
        idleTimeoutMillis: 3000
    }
};

var dbConfig1 = {
    user: 'sa',
    password: '%Martin@',
    server: '112.87.238.213',
    database: 'mxr_IM',
    port: 1433,
    options: {
        // encrypt: true // Use this if you're on Windows Azure
    },
    pool: {
        min: 0,
        max: 10,
        idleTimeoutMillis: 3000
    }
};

module.exports = dbConfig1;