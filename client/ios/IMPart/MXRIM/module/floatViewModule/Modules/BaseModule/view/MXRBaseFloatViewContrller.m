//
//  MXRBaseFloatViewContrller.m
//  huashida_home
//
//  Created by Martin.Liu on 2017/9/12.
//  Copyright © 2017年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import "MXRBaseFloatViewContrller.h"

@interface MXRBaseFloatViewContrller ()

@end

@implementation MXRBaseFloatViewContrller

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lightGrayColor];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setPresentationMode:(MXRFloatPresentationMode)presentationMode
{
    _presentationMode = presentationMode;
    if (self.delegate && [self.delegate respondsToSelector:@selector(presentationDelegateChangePresentationModeToMode:)]) {
        [self.delegate presentationDelegateChangePresentationModeToMode:_presentationMode];
    }
}

- (void)containerWillMove:(UIViewController *)container
{
    // No extra behavior
}

- (BOOL)shouldStretchInMovableContainer
{
    return YES;
}

- (CGFloat)minimumHeightInMovableContainer
{
    return 200;
}

@end
