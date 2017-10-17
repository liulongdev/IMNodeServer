//
//  MXRReceiveInvitationsViewController.m
//  huashida_home
//
//  Created by Martin.Liu on 2017/10/12.
//  Copyright © 2017年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import "MXRReceiveInvitationsViewController.h"
#import "MXRReceiveInvitationCell.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "MXRChatModuleNetworkManager.h"
#import "MXRReceiveInvitationModel.h"
#import "UIButton+MXRLoading.h"
@interface MXRReceiveInvitationsViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSMutableArray<MXRReceiveInvitationModel *> *receiveInvitationArray;
@end

@implementation MXRReceiveInvitationsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBarItem.title = @"加我的";
    [self loadRecieveInvitationsData];
    // Do any additional setup after loading the view.
}

- (void)loadRecieveInvitationsData
{
    MXRGetReceiveInvitationsR *getReceiveInvitationsR = [MXRGetReceiveInvitationsR new];
    getReceiveInvitationsR.invitedUserId = [[UserInformation modelInformation].userID integerValue];
    getReceiveInvitationsR.pageIndex = 1;
    getReceiveInvitationsR.pageSize = 1000;
    __weak __typeof(self) weakSelf = self;
    [MXRChatModuleNetworkManager getReceiveInvatations:getReceiveInvitationsR success:^(MXRNetworkResponse *response) {
        NSLog(@"get receive invitations response body : %@", response.body);
        NSArray *array = [NSArray mxr_modelArrayWithClass:[MXRReceiveInvitationModel class] json:response.body];
        [weakSelf.receiveInvitationArray addObjectsFromArray:array];
        [weakSelf.tableView reloadData];
    } failure:^(id error) {
        DLOG(@"get receive invitations error >>>>> %@", error);
    }];
    
    
    MXRGetFriendListUserInfoR *getFriendListuserInfoR = [MXRGetFriendListUserInfoR new];
    getFriendListuserInfoR.userId = [[UserInformation modelInformation].userID integerValue];
    [MXRChatModuleNetworkManager getFriendListUserInfo:getFriendListuserInfoR success:^(MXRNetworkResponse *response) {
        NSLog(@"get friend list : %@ , errMsg: %@", response.body, response.errMsg);
    } failure:^(id error) {
        NSLog(@"get friend list error : %@", error);
    }];
    
}

- (NSMutableArray *)receiveInvitationArray
{
    if (!_receiveInvitationArray) {
        _receiveInvitationArray = [NSMutableArray array];
    }
    return _receiveInvitationArray;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.receiveInvitationArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MXRReceiveInvitationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MXRReceiveInvitationCell"];
    [self configCell:cell forIndexPath:indexPath];
    return cell;
}

- (void)configCell:(MXRReceiveInvitationCell *)cell forIndexPath:(NSIndexPath *)indexPath
{
    if ([cell isKindOfClass:[cell class]]) {
        if (self.receiveInvitationArray.count > indexPath.row) {
            MXRReceiveInvitationModel *receiveInvitationModel = [self.receiveInvitationArray objectAtIndex:indexPath.row];
            [cell setData:receiveInvitationModel];
            NSString *UUID = receiveInvitationModel.UUID;
            __weak __typeof(self) weakSelf = self;
            [cell.receiveBtn addAction:^(id sender) {
                [weakSelf _acceptInvitationWithUUID:UUID];
            } forState:UIControlEventTouchUpInside];
        }
    }
}

- (void)_acceptInvitationWithUUID:(NSString *)UUID
{
    MXRAcceptFriendInvitationR *acceptFriendInvitationR = [MXRAcceptFriendInvitationR new];
    acceptFriendInvitationR.invitationUUID = UUID;
    acceptFriendInvitationR.invitedUserId = [[UserInformation modelInformation].userID integerValue];
    __weak __typeof(self) weakSelf = self;
    [MXRChatModuleNetworkManager acceptFriendInvitation:acceptFriendInvitationR success:^(MXRNetworkResponse *response) {
        if (response.isSuccess) {
            [weakSelf loadRecieveInvitationsData];
        }
        NSLog(@"accept invitation : %@ , errMsg: %@", response.body, response.errMsg);
    } failure:^(id error) {
        NSLog(@"accept invitation error >>>> %@", error);
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [tableView fd_heightForCellWithIdentifier:@"MXRReceiveInvitationCell" configuration:^(id cell) {
        [self configCell:cell forIndexPath:indexPath];
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
