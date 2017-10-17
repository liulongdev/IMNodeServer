//
//  MXRIMResponseModel.h
//  huashida_home
//
//  Created by Martin.Liu on 2017/9/29.
//  Copyright © 2017年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MXRChatRoom.h"
#import "NSObject+MXRModel.h"
@interface MXRIMResponseModel : NSObject

@end

@interface MXRChatRoomSortList : NSObject <MXRModelDelegate>

@property (nonatomic, strong) NSArray *hasJoinedChatRoomArray;
@property (nonatomic, strong) NSArray *otherChatRoomArray;

@end
