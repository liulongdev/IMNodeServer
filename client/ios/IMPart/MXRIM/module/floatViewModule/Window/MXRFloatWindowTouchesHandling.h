//
//  MXRFloatWindowTouchesHandling.h
//  huashida_home
//
//  Created by Martin.Liu on 2017/9/12.
//  Copyright © 2017年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MXRFloatWindowTouchesHandling <NSObject>

- (BOOL)mxr_window:(nullable UIWindow *)window shouldReceiveTouchAtPoint:(CGPoint)point;

@end
