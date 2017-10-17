//
//  MXRReceiveInvitationModel.h
//  huashida_home
//
//  Created by Martin.Liu on 2017/10/12.
//  Copyright © 2017年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import "MXRIMUserInfo.h"

@interface MXRReceiveInvitationModel : MXRIMUserInfo <MXRModelDelegate>
@property (nonatomic, strong) NSString *UUID;
@property (nonatomic, assign) NSInteger userId;
@property (nonatomic, assign) NSInteger invitedUserId;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, strong) NSDate *createTime;
@property (nonatomic, strong) NSDate *updateTime;

@end
