//
//  MXRSocketManager.h
//  huashida_home
//
//  Created by Martin.Liu on 2017/9/26.
//  Copyright © 2017年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MXRConstant.h"
#import <SocketRocket/SRWebSocket.h>
#import "MXRSocketMessage.h"
#import "MXRSocketMacro.h"
#define SOCKETINSTANCE [MXRSocketManager sharedInstance]
#define MXRShowMessage(msg) [MXRConstant showAlertOnWindow:msg andShowTime:1.0]

@interface MXRSocketManager : NSObject<SRWebSocketDelegate>

+ (instancetype)sharedInstance;

@property (strong, nonatomic) SRWebSocket *webSocket;

@property (strong, nonatomic) NSString *host;
@property (strong, nonatomic) NSString *port;

@property (nonatomic, assign) BOOL isSocketSendingMessageEnable;       // 是否允许模型发送模型实时数据
@property (nonatomic, assign) BOOL isSocketReceiveMessageEnabel;       // 是否允许模型接收模型实时数据

- (void)connectWebSocketServer;

- (void)closeConnect;

- (void)broadcast:(MXRSocketMessage *)prams type:(NSString *)type;

- (void)uploadFileForZhibo:(NSString *)filePath shortPath:(NSString *)shortPath bookGUID:(NSString *)bookGUID type:(NSString *)type;


@end
