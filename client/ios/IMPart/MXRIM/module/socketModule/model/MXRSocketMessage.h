//
//  MXRSocketMessage.h
//  huashida_home
//
//  Created by Martin.Liu on 2017/9/21.
//  Copyright © 2017年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MXRSocketMessage : NSObject
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *userId;

- (instancetype)initWithType:(NSString *)type;

@end
