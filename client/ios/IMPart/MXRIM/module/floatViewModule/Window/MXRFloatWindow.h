//
//  MXRFloatWindow.h
//  huashida_home
//
//  Created by Martin.Liu on 2017/9/12.
//  Copyright © 2017年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MXRFloatWindowTouchesHandling.h"
@interface MXRFloatWindow : UIWindow

/**
 Whenever we receive a touch event, window needs to ask delegate if this event should be captured.
 */
@property (nonatomic, weak, nullable) id<MXRFloatWindowTouchesHandling> touchesDelegate;

@end
