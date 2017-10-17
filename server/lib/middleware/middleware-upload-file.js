/**
 * Created by Martin on 2017/9/11.
 * 对上传文件的中间层进行在封装
 */

var fs = require('fs');
var multer  = require('multer');
var upload  = null;

function MXRUploadFile(options){
    upload = multer(options);
}

MXRUploadFile.prototype.single = function (name) {
    if (upload)
    {
        return [upload.single(name), uploadFile_middleware];
    }
    return handleEmpty;
}

function handleEmpty(req, res, next) {
    console.log('error : multer is empty');
    next();
}

function uploadFile_middleware(req, res, next) {
    if (req.file)
    {
        mxr_rename_file(req.file, next);
    }
}

function mxr_rename_file(file, next)
{
    var extension = '';
    if (file.mimetype && file.mimetype === 'image/png')
    {
        extension = 'png';
    }
    else if (file.mimetype && file.mimetype === 'audio/mpeg')
    {
        extension = 'mp3';
    }
    // else if (file.mimetype && file.mimetype === 'video/mpeg')
    // {
    //     extension = 'mpeg';
    // }
    // else if()
    // {}

    var fileExt = extension ? '.' + extension : '';
    var renameFilePath = file.path + fileExt;
    // 异步的
    fs.rename(file.path, renameFilePath, function (error) {
        if (error)
        {
            console.log('>>>>>> rename error : '+error);
            next();
        }
        else
        {
            console.log('>>>>>> rename file success path : '+renameFilePath);
            file.uplodSuccessFilePath = renameFilePath;
            next();
        }
    })
}

function MXRUploadFileInstance (options) {
    if (options === undefined) {
        return new MXRUploadFile({})
    }

    if (typeof options === 'object' && options !== null) {
        return new MXRUploadFile(options)
    }

    throw new TypeError('Expected object for argument options')
}

// module.exports = uploadFile_middleware;
module.exports = MXRUploadFileInstance