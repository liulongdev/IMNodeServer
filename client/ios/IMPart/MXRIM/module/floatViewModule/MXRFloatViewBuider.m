//
//  MXRFloatViewBuider.m
//  huashida_home
//
//  Created by Martin.Liu on 2017/9/12.
//  Copyright © 2017年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import "MXRFloatViewBuider.h"
#import "MXRFloatWindowTouchesHandling.h"
#import "MXRPresentationModeDelegate.h"
#import "MXRFloatWindow.h"
#import "MXRFloatContainerViewController.h"
#import "MXRSimpleInfoViewController.h"
#import "MXRZhiBoConfigViewController.h"
static const NSUInteger kMXRSimpleVCHeight = 100.0;
static const NSUInteger kMXRZhiboVCHeight = 400;

@interface MXRFloatViewBuider()<MXRPresentationModeDelegate, MXRFloatWindowTouchesHandling>

@property (nonatomic, strong) MXRFloatWindow *floatWindow;
@property (nonatomic, assign) MXRFloatPresentationMode presentationMode;


@end

@implementation MXRFloatViewBuider
{
    MXRFloatContainerViewController *_containerViewController;
    UIViewController *_currentLocationViewController;   // 保存present时的VC，用来计算用户行为是否有效。
    
    MXRZhiBoConfigViewController *_zhiboConfigVC;
    MXRSimpleInfoViewController *_simpleInfoVC;
}

- (MXRFloatWindow *)floatWindow
{
    if (!_floatWindow) {
        _floatWindow = [[MXRFloatWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _floatWindow.hidden = NO;
        _floatWindow.touchesDelegate = self;
    }
    return _floatWindow;
}

- (void)showWindow:(BOOL)show
{
    if (show) {
        if (_floatWindow) {
            _floatWindow.hidden = NO;
        }
        else
        {
            _containerViewController = [[MXRFloatContainerViewController alloc] init];
            self.floatWindow.rootViewController = _containerViewController;
            [_containerViewController dismissCurrentViewController];
            [self setPresentationMode:MXRFloatPresentationMode_Normal];
        }
    }
    else
    {
        _floatWindow.hidden = YES;
    }
}

- (void)setPresentationMode:(MXRFloatPresentationMode)presentationMode
{
    _presentationMode = presentationMode;
    switch (presentationMode) {
        case MXRFloatPresentationMode_Normal:
        {
            
            [_containerViewController dismissCurrentViewController];
            _simpleInfoVC = nil;
            _currentLocationViewController = nil;
            _zhiboConfigVC = nil;
            _simpleInfoVC = [MXRSimpleInfoViewController new];
            _simpleInfoVC.delegate = self;
            _currentLocationViewController = _simpleInfoVC;
            [_containerViewController presentViewController:_simpleInfoVC
                                                   withSize:CGSizeMake(kMXRSimpleVCHeight,
                                                                       kMXRSimpleVCHeight)];
        }
            break;
        case MXRFloatPresentationMode_Socket:
        {
            [_containerViewController dismissCurrentViewController];
            _simpleInfoVC = nil;
            _currentLocationViewController = nil;
            _zhiboConfigVC     = nil;
            _zhiboConfigVC = [MXRZhiBoConfigViewController new];
            _zhiboConfigVC.delegate = self;
            _currentLocationViewController = _zhiboConfigVC;
            [_containerViewController presentViewController:_zhiboConfigVC withSize:CGSizeMake(FLT_MAX, kMXRZhiboVCHeight)];
            
        }
            break;
    }
}

#pragma mark - MXRPresentationModeDelegate
- (void)presentationDelegateChangePresentationModeToMode:(MXRFloatPresentationMode)mode
{
    self.presentationMode = mode;
}


#pragma mark - MXRFloatWindowTouchesHandling
- (BOOL)mxr_window:(UIWindow *)window shouldReceiveTouchAtPoint:(CGPoint)point
{
    if (_currentLocationViewController) {
        return CGRectContainsPoint(_currentLocationViewController.view.bounds,
                                   [_currentLocationViewController.view convertPoint:point
                                                                            fromView:window]);
    }
    return NO;
}

@end
