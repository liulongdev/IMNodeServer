//
//  MXRIMUserInfoDetailViewController.m
//  huashida_home
//
//  Created by Martin.Liu on 2017/9/30.
//  Copyright © 2017年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import "MXRIMUserInfoDetailViewController.h"
#import "UIImageView+WebCache.h"
#import "MXRChatModuleNetworkManager.h"
@interface MXRIMUserInfoDetailViewController ()
@property (strong, nonatomic) IBOutlet UIImageView *userImageView;
@property (strong, nonatomic) IBOutlet UILabel *friendStateTitle;
@property (strong, nonatomic) IBOutlet UIButton *invitationBtn;
@property (strong, nonatomic) IBOutlet UILabel *userInfoDetailLabel;

- (IBAction)clickInvitationBtnAction:(id)sender;
@end

@implementation MXRIMUserInfoDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self UIGlobal];

    if ([[UserInformation modelInformation].userID integerValue] != self.userInfo.userID) {
        [self getFriendshipData];
    }
}

- (void)UIGlobal
{
    self.userImageView.layer.masksToBounds = YES;
    self.userImageView.layer.cornerRadius = CGRectGetHeight(self.userImageView.frame)/2;
    self.friendStateTitle.hidden = YES;
    self.invitationBtn.hidden = YES;
    
    [self.userImageView sd_setImageWithURL:[NSURL URLWithString:self.userInfo.userIcon] placeholderImage:[UIImage imageNamed:@"default_head"]];
    NSMutableString *userDetailStr = [NSMutableString string];
    [userDetailStr appendString:[@"nickname:" stringByAppendingString:self.userInfo.userNickName ?: @""]];
    [userDetailStr appendString:[@"\nsex:" stringByAppendingString:self.userInfo.userSexString]];
    [userDetailStr appendString:[@"\ndescription:" stringByAppendingString:self.userInfo.userDescription ?: @""]];
    self.userInfoDetailLabel.text = userDetailStr;
    
}

- (void)getFriendshipData
{
    MXRGetUsersFriendShipR *getUsersFriendShipR = [MXRGetUsersFriendShipR new];
    getUsersFriendShipR.userId = [[UserInformation modelInformation].userID integerValue];
    getUsersFriendShipR.otherUserId = self.userInfo.userID;
    __weak __typeof(self) weakSelf = self;
    [MXRChatModuleNetworkManager getFriendshipBetweenUsers:getUsersFriendShipR success:^(MXRNetworkResponse *response) {
        if (response.isSuccess) {
            if ([response.body[@"friendship"] integerValue] == 0) {
                weakSelf.friendStateTitle.hidden = NO;
                [weakSelf.invitationBtn setTitle:@"发送邀请" forState:UIControlStateNormal];
                weakSelf.invitationBtn.hidden = NO;
                weakSelf.invitationBtn.userInteractionEnabled = YES;
            }
            else if ([response.body[@"friendship"] integerValue] == 2)
            {
                weakSelf.friendStateTitle.hidden = NO;
                [weakSelf.invitationBtn setTitle:@"已发送邀请" forState:UIControlStateNormal];
                weakSelf.invitationBtn.hidden = NO;
                weakSelf.invitationBtn.userInteractionEnabled = NO;
            }
            NSLog(@"friendship : %ld", (long)[response.body[@"friendship"] integerValue]);
        }
        NSLog(@"get userFriendship : %@", response.body);
    } failure:^(id error) {
        NSLog(@"get user friendship error >>>>> %@", error);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)clickInvitationBtnAction:(id)sender {
    MXRSendFriendInvitationR *sendFriendInvitationR = [MXRSendFriendInvitationR new];
    sendFriendInvitationR.userId = [[UserInformation modelInformation].userID integerValue];
    sendFriendInvitationR.invitedUserId = self.userInfo.userID;
    sendFriendInvitationR.content = @"你好";
    __weak __typeof(self) weakSelf = self;
    [MXRChatModuleNetworkManager sendFriendInvitation:sendFriendInvitationR success:^(MXRNetworkResponse *response) {
        if (response.isSuccess) {
            NSLog(@"发送邀请成功");
            weakSelf.friendStateTitle.hidden = NO;
            [weakSelf.invitationBtn setTitle:@"已发送邀请" forState:UIControlStateNormal];
            weakSelf.invitationBtn.hidden = NO;
            weakSelf.invitationBtn.userInteractionEnabled = NO;
        }
        else
        {
            NSLog(@"send friend invatation error : %@", response.errMsg);
        }
    } failure:^(id error) {
        NSLog(@"send friend invitation error >> %@", error);
    }];
}
@end
