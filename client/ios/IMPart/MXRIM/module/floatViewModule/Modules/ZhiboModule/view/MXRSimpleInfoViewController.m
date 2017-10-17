//
//  MXRSimpleInfoViewController.m
//  huashida_home
//
//  Created by Martin.Liu on 2017/9/12.
//  Copyright © 2017年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import "MXRSimpleInfoViewController.h"
#import "MXRSocketManager.h"
@interface MXRSimpleInfoViewController ()
@property (strong, nonatomic) IBOutlet UILabel *simpleInfoLabel;
- (IBAction)clickButtonAction:(id)sender;

@end

@implementation MXRSimpleInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSString *socketState = @"unkown";
    if (!SOCKETINSTANCE.webSocket) {
        socketState = @"close";
    }
    else if (SOCKETINSTANCE.webSocket.readyState == SR_OPEN)
    {
        socketState = @"connected!";
    }
    else if (SOCKETINSTANCE.webSocket.readyState == SR_CONNECTING)
    {
        socketState = @"connecting...";
    }
    else
    {
        socketState = @"close";
    }
    self.simpleInfoLabel.text = [NSString stringWithFormat:@"socket:%@", socketState];
    [self addObservers];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self removeObservers];
}

- (void)addObservers
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(socketOpen:) name:MXRNOTIFICATION_SOCKETOPEN object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(socketColose:) name:MXRNOTIFICATION_SOCKETCLOSE object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(socketConnecting:) name:MXRNOTIFICATION_CONNETING object:nil];
}

- (void)removeObservers
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MXRNOTIFICATION_SOCKETOPEN object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MXRNOTIFICATION_SOCKETCLOSE object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MXRNOTIFICATION_CONNETING object:nil];
}

- (void)socketOpen:(NSNotification *)noti
{
    self.simpleInfoLabel.text = @"socket:connected!";
}

- (void)socketColose:(NSNotification *)noti
{
    self.simpleInfoLabel.text = @"socket:close";
}

- (void)socketConnecting:(NSNotification *)noti
{
    self.simpleInfoLabel.text = @"socket:Connectionint...";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat)minimumHeightInMovableContainer
{
    return 100;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)clickButtonAction:(id)sender {
    [self setPresentationMode:MXRFloatPresentationMode_Socket];
}
@end
