//
//  MXRIMUserInfo.h
//  huashida_home
//
//  Created by Martin.Liu on 2017/9/30.
//  Copyright © 2017年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+MXRModel.h"

@interface MXRIMUserInfo : NSObject

@property (nonatomic, assign) NSInteger userID;
@property (nonatomic, strong) NSString *userNickName;
@property (nonatomic, strong) NSString *userIcon;
@property (nonatomic, assign) NSInteger userSex;
@property (nonatomic, strong) NSString *userFullName;
@property (nonatomic, strong) NSString *userEmail;
@property (nonatomic, strong) NSString *userDescription;
@property (nonatomic, strong) NSString *userPhone;
@property (nonatomic, assign) NSInteger userLevel;
@property (nonatomic, assign) NSInteger userGrade;
@property (nonatomic, assign) NSInteger userStatus;

@property (nonatomic, readonly) NSString *userSexString;


@end
