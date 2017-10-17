//
//  MXRChatRoom.h
//  huashida_home
//
//  Created by Martin.Liu on 2017/9/21.
//  Copyright © 2017年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+MXRModel.h"

@interface MXRChatRoom : NSObject<MXRModelDelegate>

@property (nonatomic, strong) NSString *chatRoomId;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, assign) NSInteger userMaxNum;
//@property (nonatomic, strong) NSString *chatRoomIcon;
@property (nonatomic, strong) NSDate *createDate;
@property (nonatomic, strong) NSDate *updateDate;

@end
