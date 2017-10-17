//
//  MXRFloatMovableViewController.h
//  huashida_home
//
//  Created by Martin.Liu on 2017/9/12.
//  Copyright © 2017年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MXRFloatMovableViewController <NSObject>
/**
 Container will move view controller (either by pan or pinch).
 */
- (void)containerWillMove:(nonnull UIViewController *)container;

/**
 Should view should stretch on pinch?
 */
- (BOOL)shouldStretchInMovableContainer;

/**
 @return minimum height that view controllers must have
 */
- (CGFloat)minimumHeightInMovableContainer;
@end
