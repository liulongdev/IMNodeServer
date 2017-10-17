//
//  MXRIMFriendListViewController.m
//  huashida_home
//
//  Created by Martin.Liu on 2017/10/13.
//  Copyright © 2017年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import "MXRIMFriendListViewController.h"
#import "MXRIMFriendTableCell.h"
#import "MXRChatModuleNetworkManager.h"
#import "MXRIMUserInfo.h"
#import "MXRIMP2PChatViewController.h"
@interface MXRIMFriendListViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *friendArray;
@end

@implementation MXRIMFriendListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBarItem.title = @"好友";
    // Do any additional setup after loading the view.
    [self loadFriendListData];
}

- (void)loadFriendListData
{
    MXRGetFriendListUserInfoR *getFriendListUserInfoR = [MXRGetFriendListUserInfoR new];
    getFriendListUserInfoR.userId = [[UserInformation modelInformation].userID integerValue];
    __weak __typeof(self) weakSelf = self;
    [MXRChatModuleNetworkManager getFriendListUserInfo:getFriendListUserInfoR success:^(MXRNetworkResponse *response) {
        NSArray *friendArray = [NSArray mxr_modelArrayWithClass:[MXRIMUserInfo class] json:response.body];
        [weakSelf.friendArray addObjectsFromArray:friendArray];
        [weakSelf.tableView reloadData];
        NSLog(@"get friend list : %@ , errMsg : %@", response.body, response.errMsg);
    } failure:^(id error) {
        NSLog(@"get friend list error >>>>>  %@", error);
    }];
}

- (NSMutableArray *)friendArray
{
    if (!_friendArray) {
        _friendArray = [NSMutableArray array];
    }
    return _friendArray;
    
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

#pragma mark - UITableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.friendArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MXRIMFriendTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MXRIMFriendTableCell"];
    if (self.friendArray.count > indexPath.row) {
        MXRIMUserInfo *userInfo = [self.friendArray objectAtIndex:indexPath.row];
        [cell setData:userInfo];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.friendArray.count > indexPath.row) {
        MXRIMUserInfo *userInfo = [self.friendArray objectAtIndex:indexPath.row];
        MXRIMP2PChatViewController *IMP2PChatVC = [[MXRIMP2PChatViewController alloc] init];
        IMP2PChatVC.friendUserId = userInfo.userID;
        IMP2PChatVC.userInfo = userInfo;
        [self.navigationController pushViewController:IMP2PChatVC animated:YES];
    }
    
    
}

@end
