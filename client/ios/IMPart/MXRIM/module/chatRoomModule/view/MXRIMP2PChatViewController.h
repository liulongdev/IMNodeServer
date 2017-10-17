//
//  MXRIMP2PChatViewController.h
//  huashida_home
//
//  Created by Martin.Liu on 2017/10/13.
//  Copyright © 2017年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import "JSQMessagesViewController.h"
#import "MXRIMUserInfo.h"
@interface MXRIMP2PChatViewController : JSQMessagesViewController
@property (nonatomic, assign) NSInteger friendUserId;
@property (nonatomic, strong) MXRIMUserInfo *userInfo;
@end
