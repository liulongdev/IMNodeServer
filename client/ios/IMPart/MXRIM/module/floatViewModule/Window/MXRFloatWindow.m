//
//  MXRFloatWindow.m
//  huashida_home
//
//  Created by Martin.Liu on 2017/9/12.
//  Copyright © 2017年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import "MXRFloatWindow.h"

@implementation MXRFloatWindow

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        self.windowLevel = UIWindowLevelStatusBar + 100;
    }
    return self;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    if ([_touchesDelegate mxr_window:self shouldReceiveTouchAtPoint:point]) {
        return [super pointInside:point withEvent:event];
    }
    
    return NO;
}

- (BOOL)_canAffectStatusBarAppearance
{
    return NO;
}

- (BOOL)_canBecomeKeyWindow
{
    return NO;
}

@end
