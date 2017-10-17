//
//  MXRBookSocketMessage.m
//  huashida_home
//
//  Created by Martin.Liu on 2017/9/8.
//  Copyright © 2017年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import "MXRBookSocketMessage.h"

@implementation MXRBookSocketMessage

@end

@implementation MXRADDUGCModelM

- (instancetype)initWithBookGuid:(NSString *)bookGUID content:(NSString *)content fileLocalURL:(NSString *)fileLocalURL fileURL:(NSString *)fileURL
{
    self = [super init];
    if (!self) return nil;
    self.bookGUID = bookGUID;
    self.content = content;
    self.fileLocalURL = fileLocalURL;
    self.fileURL = fileURL;
    return self;
}

- (instancetype)initWithBookGuid:(NSString *)bookGUID content:(NSString *)content
{
    return [self initWithBookGuid:bookGUID content:content fileLocalURL:nil fileURL:nil];
}

@end

@implementation MXRDummyM

@end
