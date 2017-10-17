//
//  MXRChatRoomUserInfoListViewController.m
//  huashida_home
//
//  Created by Martin.Liu on 2017/9/30.
//  Copyright © 2017年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import "MXRChatRoomUserInfoListViewController.h"
#import "MXRChatRoomUserInfoCell.h"
#import "MXRChatModuleNetworkManager.h"
#import "MXRIMUserInfo.h"
#import "MJRefresh.h"
#import "MXRIMUserInfoDetailViewController.h"

@interface MXRChatRoomUserInfoListViewController () <UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *userInfoArray;
@property (nonatomic, strong) MXRGetUserInfoListInRoomR *getUserInfoListR;
@property (nonatomic, assign) NSInteger currentPageIndex;
@end

@implementation MXRChatRoomUserInfoListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self UIGlobal];
    [self loadMembersData];
}

- (void)UIGlobal
{
    MJRefreshBackStateFooter *footer = [MJRefreshBackStateFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMembersData)];
    self.tableView.mj_footer = footer;
    
}

- (void)loadMembersData
{
    __weak __typeof(self) weakSelf = self;
    self.getUserInfoListR.pageIndex = self.currentPageIndex + 1;
    [MXRChatModuleNetworkManager getUserListInfoRoom:self.getUserInfoListR success:^(MXRNetworkResponse *response) {
        NSArray *userInfoList = [NSArray mxr_modelArrayWithClass:[MXRIMUserInfo class] json:response.body];
        if (userInfoList.count > 0) {
            weakSelf.currentPageIndex ++;
        }
        if (userInfoList.count >= weakSelf.getUserInfoListR.pageSize) {
            [weakSelf.tableView.mj_footer endRefreshing];
        }
        else
            [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
        [weakSelf.userInfoArray addObjectsFromArray:userInfoList];
        [weakSelf.tableView reloadData];
        NSLog(@"get userInfo list : %@", response.body);
        
    } failure:^(id error) {
        NSLog(@"get userinfo list error : %@", error);
        [weakSelf.tableView.mj_footer endRefreshing];
    }];
}

- (NSMutableArray *)userInfoArray
{
    if (!_userInfoArray) {
        _userInfoArray = [NSMutableArray array];
    }
    return _userInfoArray;
}

- (MXRGetUserInfoListInRoomR *)getUserInfoListR
{
    if (!_getUserInfoListR) {
        _getUserInfoListR = [MXRGetUserInfoListInRoomR new];
        _getUserInfoListR.pageSize = 10;
        _getUserInfoListR.pageIndex = 0;
        _getUserInfoListR.chatRoomId = self.chatRoomId;
    }
    return _getUserInfoListR;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.userInfoArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MXRChatRoomUserInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MXRChatRoomUserInfoCell" forIndexPath:indexPath];
    if (self.userInfoArray.count > indexPath.row) {
        MXRIMUserInfo *userInfo = self.userInfoArray[indexPath.row];
        [cell setData:userInfo];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.userInfoArray.count > indexPath.row) {
        MXRIMUserInfo *userInfo = self.userInfoArray[indexPath.row];
        MXRIMUserInfoDetailViewController *userInfoDetailVC = [[UIStoryboard storyboardWithName:@"chatModule" bundle:nil] instantiateViewControllerWithIdentifier:@"MXRIMUserInfoDetailViewController"];
        if ([userInfoDetailVC isKindOfClass:[MXRIMUserInfoDetailViewController class]]) {
            userInfoDetailVC.userInfo = userInfo;
            [self.navigationController pushViewController:userInfoDetailVC animated:YES];
        }
    }
    
}

@end
