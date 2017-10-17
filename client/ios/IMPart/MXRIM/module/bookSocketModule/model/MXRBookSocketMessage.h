//
//  MXRBookSocketMessage.h
//  huashida_home
//
//  Created by Martin.Liu on 2017/9/8.
//  Copyright © 2017年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MXRSocketMessage.h"

@interface MXRBookSocketMessage : MXRSocketMessage
@property (nonatomic, strong) NSString *bookGUID;
@property (nonatomic, strong) NSString *content;
@end

// 添加UGC
@interface MXRADDUGCModelM : MXRBookSocketMessage
//@property (nonatomic, strong) NSString *content;
//@property (nonatomic, strong) NSString *bookGUID;
@property (nonatomic, strong) NSString *fileLocalURL;
@property (nonatomic, strong) NSString *fileURL;

- (instancetype)initWithBookGuid:(NSString *)bookGUID content:(NSString *)content fileLocalURL:(NSString *)fileLocalURL fileURL:(NSString *)fileURL;

- (instancetype)initWithBookGuid:(NSString *)bookGUID content:(NSString *)content;

@end

// 模型同步
@interface MXRDummyM : MXRBookSocketMessage

@end
