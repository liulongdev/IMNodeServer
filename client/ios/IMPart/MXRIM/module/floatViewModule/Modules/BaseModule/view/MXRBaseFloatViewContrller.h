//
//  MXRBaseFloatViewContrller.h
//  huashida_home
//
//  Created by Martin.Liu on 2017/9/12.
//  Copyright © 2017年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MXRFloatMovableViewController.h"
#import "MXRPresentationModeDelegate.h"

@interface MXRBaseFloatViewContrller : UIViewController<MXRFloatMovableViewController>

@property (nonatomic, weak) id<MXRPresentationModeDelegate> delegate;
@property (nonatomic, assign) MXRFloatPresentationMode presentationMode;
@end
