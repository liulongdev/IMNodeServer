//
//  MXRSocketManager.m
//  huashida_home
//
//  Created by Martin.Liu on 2017/9/26.
//  Copyright © 2017年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import "MXRSocketManager.h"
#import <NSString+MAREX.h>
#import <NSObject+MARModel.h>
#import "MXRNetworkManager.h"

@implementation MXRSocketManager
@synthesize webSocket = _webSocket;

+ (instancetype)sharedInstance
{
    static dispatch_once_t pred = 0;
    static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [MXRSocketManager new];
    });
    return _sharedObject;
}

- (instancetype)init
{
    self = [super init];
    if (!self) return nil;
    self.host = SERVER_SOCKET_HOST;
    self.port = SERVER_SOCKET_PORT;
    self.isSocketReceiveMessageEnabel = YES;
    self.isSocketSendingMessageEnable = YES;
    return self;
}

- (void)connectWebSocketServer
{
    if (_webSocket && _webSocket.readyState == SR_OPEN) {
        return;
    }
    if (_webSocket && _webSocket.readyState != SR_OPEN) {
        [_webSocket close];
        _webSocket.delegate = nil;
        _webSocket = nil;
        [self performSelector:@selector(connectWebSocketServer) withObject:self afterDelay:1];
    }
    else
    {
        NSString *host = self.host;
        NSString *port = self.port;
        if (host.length == 0  || port.length == 0) {
            MXRShowMessage(@"请输入host和port");
            return;
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:MXRNOTIFICATION_CONNETING object:nil];
        NSString *url = [NSString stringWithFormat:@"ws://%@:%@", host, port];
        _webSocket = [[SRWebSocket alloc] initWithURL:[NSURL URLWithString:url]];
        _webSocket.delegate = self;
        [_webSocket open];
    }
}

- (void)closeConnect{
    [_webSocket close];
    _webSocket = nil;
}

- (void)broadcast:(MXRSocketMessage *)prams type:(NSString *)type
{
    if (!self.isSocketSendingMessageEnable) return;
    if (_webSocket.readyState == 1) {
        prams.type = type;
        [_webSocket send:[@{@"type":type,
                            @"params":[prams mar_modelToJSONString]
                            } mar_modelToJSONString]];
    }
}

#pragma mark - SRWebSocketDelegate
#pragma mark - SRWebSocketDelegate
- (void)webSocketDidOpen:(SRWebSocket *)webSocket
{
    NSLog(@">>>>>>>Websocket Connected");
    if ([[UserInformation modelInformation] getIsLogin]) {
        // 发送userid， 与socket绑定
        MXRSocketMessage *socketMessage = [[MXRSocketMessage alloc] initWithType:MXRSocketType_SendUserId];
        [self broadcast:socketMessage type:MXRSocketType_SendUserId];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:MXRNOTIFICATION_SOCKETOPEN object:nil];
    MXRShowMessage(@"webSocket connected !");
}

- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error
{
    NSLog(@">>>>>>>websocket failed with error %@", error);
    NSString *message = [NSString stringWithFormat:@"websocket failed with error %@", error];
    MXRShowMessage(message);
}

- (BOOL)webSocketShouldConvertTextFrameToString:(SRWebSocket *)webSocket
{
    return YES;
}

- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean
{
    [[NSNotificationCenter defaultCenter] postNotificationName:MXRNOTIFICATION_SOCKETCLOSE object:nil];
    NSLog(@">>>>>>>closed , reason:%@, wasClean : %d", reason, wasClean);
    NSString *msg = [NSString stringWithFormat:@"closed , reason:%@, wasClean : %d", reason, wasClean];
    MXRShowMessage(msg);
}

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message
{
    if (!SOCKETINSTANCE.isSocketReceiveMessageEnabel) return;
    NSLog(@">>>>>>>message : %@", message);
    [self handleReceiveMessage:message];
}

- (void)handleReceiveMessage:(id)message
{
    if ([message isKindOfClass:[NSString class]] || [message isKindOfClass:[NSData class]]) {
        id object = [message mar_jsonValueDecoded];
        if ([object isKindOfClass:[NSDictionary class]]) {
            if (object[@"type"]) {
//                if ([object[@"type"] rangeOfString:@"ADDUGC_"].location != NSNotFound) {
//                    NSDictionary *params = object[@"params"];
//                    MXRADDUGCModelM *addUGCInfo = [MXRADDUGCModelM mar_modelWithJSON:params];
//                    addUGCInfo.type = object[@"type"];
//                    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_ADDUGC object:addUGCInfo];
//                }
//                else if ([object[@"type"] isEqualToString:BroadCastType_SynchronizeDummy])
//                {
//                    NSDictionary *params = object[@"params"];
//                    MXRBookSocketMessage *bookSocketMessage = [MXRBookSocketMessage mar_modelWithJSON:params];
//                    UnitySendMessage("Game", "GetZhiBoData", [bookSocketMessage.content UTF8String]);
//                }
//                else
                if ([object[@"type"] rangeOfString:@"ChatRoom_"].location != NSNotFound) {
                    MXRNetworkResponse *response = [MXRNetworkResponse mxr_modelWithJSON:object];
                    [[NSNotificationCenter defaultCenter] postNotificationName:MXRNOTIFICATION_CHATROOMMESSAGE object:response];
                }
                if ([object[@"type"] isEqualToString:@"MXRSocketType_SendUserId"]) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:MXRNOTIFICATION_SOCKETOPENBYUSERID object:object];
                }
                if ([object[@"type"] rangeOfString:@"P2PChat_"].location != NSNotFound) {
                    MXRNetworkResponse *response = [MXRNetworkResponse mxr_modelWithJSON:object];
                    [[NSNotificationCenter defaultCenter] postNotificationName:MXRNOTIFICATION_P2PCHATMESSAGE object:response];
                }
                
            }
        }
    }
}


- (void)uploadFileForZhibo:(NSString *)filePath shortPath:(NSString *)shortPath bookGUID:(NSString *)bookGUID type:(NSString *)type
{
//    NSString *url = [NSString stringWithFormat:@"http://%@:%@/uploadFile", SERVER_EXPRESS_HOST, SERVER_EXPRESS_PORT];
//    NSURL *fileURL = [NSURL fileURLWithPath:filePath];
//    NSData *data = [NSData dataWithContentsOfURL:fileURL];
//    if (data) {
//        NSLog(@">>>> 准备上传文件");
//        [MXRNetworkManager mxr_upload:url name:@"file" fileName:[filePath lastPathComponent] username:@"Martin" fileMIMEType:nil data:data progress:nil success:^(NSURLResponse *URLResponse, id response) {
//            NSLog(@"upload success : %@", response);
//            NSDictionary * dic = [response mar_modelToJSONObject];
//            if ([dic isKindOfClass:[NSDictionary class]]) {
//                if (dic[@"Body"]) {
//                    NSString *fileServerUrl = dic[@"Body"][@"filePath"];
//                    if (fileServerUrl) {
//                        MXRADDUGCModelM *model = [[MXRADDUGCModelM alloc] initWithBookGuid:bookGUID content:shortPath fileLocalURL:filePath fileURL:fileServerUrl];
//                        [SOCKETINSTANCE broadcast:model type:type];
//                    }
//                }
//            }
//        } failure:^(NSURLResponse *URLResponse, NSError *error) {
//            NSLog(@">>>>> upload file error : %@", error);
//        }];
//    }
}

@end
