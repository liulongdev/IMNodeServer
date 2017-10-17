//
//  MXRPresentationModeDelegate.h
//  huashida_home
//
//  Created by Martin.Liu on 2017/9/12.
//  Copyright © 2017年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, MXRFloatPresentationMode) {
    MXRFloatPresentationMode_Normal = 0,
    MXRFloatPresentationMode_Socket,// 
};

@protocol MXRPresentationModeDelegate <NSObject>

- (void)presentationDelegateChangePresentationModeToMode:(MXRFloatPresentationMode)mode;

@end
