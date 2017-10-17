//
//  MXRZhiBoConfigViewController.m
//  huashida_home
//
//  Created by Martin.Liu on 2017/9/12.
//  Copyright © 2017年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import "MXRZhiBoConfigViewController.h"
#import <SocketRocket/SocketRocket.h>
#import <MARCategory.h>
#import "MXRSocketManager.h"
#import "AppDelegate.h"
@interface MXRZhiBoConfigViewController ()
@property (strong, nonatomic) IBOutlet UITextField *hostTF;
@property (strong, nonatomic) IBOutlet UITextField *portTF;
@property (strong, nonatomic) IBOutlet UIButton *connectBtn;
@property (strong, nonatomic) IBOutlet UILabel *connectStateLabel;
@property (strong, nonatomic) IBOutlet UISwitch *receiveSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *sendSwitch;


@property (weak, nonatomic) IBOutlet UIButton *liveBtn;
@property (weak, nonatomic) IBOutlet UIButton *playLiveBtn;
@property (weak, nonatomic) IBOutlet UIButton *callBtn;
@property (weak, nonatomic) IBOutlet UIButton *stopCallBtn;
/** 录屏广播视图
@property(nonatomic, strong)RPBroadcastController * broadcastViewController;
 */
@property (nonatomic, assign) BOOL isLiving;

- (IBAction)switchValueChanged:(id)sender;
- (IBAction)clickConnectBtnAction:(id)sender;
- (IBAction)clickBackAction:(id)sender;

@end

@implementation MXRZhiBoConfigViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isLiving = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (SOCKETINSTANCE.webSocket.readyState == SR_OPEN) {
        [self.connectBtn setTitle:@"关闭" forState:UIControlStateNormal];
        self.connectStateLabel.text = @"已连接";
    }
    self.hostTF.text = SOCKETINSTANCE.host;
    self.portTF.text = SOCKETINSTANCE.port;
    self.receiveSwitch.on = SOCKETINSTANCE.isSocketReceiveMessageEnabel;
    self.sendSwitch.on = SOCKETINSTANCE.isSocketSendingMessageEnable;
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
    [self.connectBtn setTitle:@"关闭" forState:UIControlStateNormal];
    self.connectStateLabel.text = @"已连接";
}

- (void)socketColose:(NSNotification *)noti
{
    self.connectStateLabel.text = @"断开";
    [self.connectBtn setTitle:@"连接" forState:UIControlStateNormal];
}

- (void)socketConnecting:(NSNotification *)noti
{
    self.connectStateLabel.text = @"连接...";
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (CGFloat)minimumHeightInMovableContainer
{
    return MAX(SCREEN_HEIGHT_DEVICE, SCREEN_WIDTH_DEVICE)/2;
}

- (IBAction)switchValueChanged:(id)sender {
    if (self.sendSwitch == sender) {
        SOCKETINSTANCE.isSocketSendingMessageEnable = self.sendSwitch.on;
    }
    else if (self.receiveSwitch == sender){
        SOCKETINSTANCE.isSocketReceiveMessageEnabel = self.receiveSwitch.on;
    }
}

- (IBAction)clickConnectBtnAction:(id)sender {
    if (![self.connectBtn.titleLabel.text isEqualToString:@"连接"]) {
        [SOCKETINSTANCE closeConnect];
        return;
    }
    SOCKETINSTANCE.host = self.hostTF.text ?: @"";
    SOCKETINSTANCE.port = self.portTF.text ?: @"";
    
    [SOCKETINSTANCE connectWebSocketServer];
}

- (IBAction)clickBackAction:(id)sender {
    [self setPresentationMode:MXRFloatPresentationMode_Normal];
}



@end
