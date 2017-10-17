//
//  MXRChatRoomListViewController.m
//  huashida_home
//
//  Created by Martin.Liu on 2017/9/21.
//  Copyright © 2017年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import "MXRChatRoomListViewController.h"
#import "MXRChatModuleNetworkManager.h"
#import "MXRChatRoomViewController.h"
#import "UIButton+MXRLoading.h"
#import "MXRReceiveInvitationsViewController.h"
#import "MXRIMTabBarViewController.h"

@interface MXRChatRoomListViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *chatRoomArray;
@property (nonatomic, strong) MXRChatRoomSortList *chatRoomSortList;
@end

@implementation MXRChatRoomListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadChatRoomListData];
}

- (NSMutableArray *)chatRoomArray
{
    if (!_chatRoomArray) {
        _chatRoomArray = [NSMutableArray array];
    }
    return _chatRoomArray;
}

- (void)loadChatRoomListData
{
    __weak __typeof(self) weakSelf = self;
//    [MXRChatModuleNetworkManager getChatRoomListSuccess:^(MXRNetworkResponse *response) {
//        NSLog(@">>>>> get chat room list data : %@ \n%@", response, response.body);
//        NSArray *chatRoomList = [NSArray mxr_modelArrayWithClass:[MXRChatRoom class] json:response.body];
//        [weakSelf.chatRoomArray addObjectsFromArray:chatRoomList];
//        [weakSelf.tableView reloadData];
//
//    } failure:^(id error) {
//        NSLog(@">>>>> get chat room list error : %@", error);
//    }];
    
    MXRGetChatRoomSortListR *getChatRoomSortListR = [MXRGetChatRoomSortListR new];
    getChatRoomSortListR.userId = [[UserInformation modelInformation].userID integerValue];
    [MXRChatModuleNetworkManager getChatRoomSortList:getChatRoomSortListR success:^(MXRNetworkResponse *response) {
        if (response.isSuccess) {
            MXRChatRoomSortList *chatRoomSortList = [MXRChatRoomSortList mxr_modelWithJSON:response.body];
            weakSelf.chatRoomSortList = chatRoomSortList;
            NSLog(@"聊天室信息： %@", chatRoomSortList);
        }
        else
            NSLog(@"聊天室信息error ：%@", response.errMsg);
    } failure:^(id error) {
        NSLog(@"聊天室信息error ：>>> %@", error);
    }];
}

- (void)setChatRoomSortList:(MXRChatRoomSortList *)chatRoomSortList
{
    _chatRoomSortList = chatRoomSortList;
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableview Delegte
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.chatRoomSortList != nil ? 2 : 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 60;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSString *title = @"我加入的聊天群";
    if (section == 1) {
        title = @"其他聊天群";
    }
    
    UIView *view = [UIView new];
    CGFloat height = [self tableView:self.tableView heightForHeaderInSection:section];
    view.frame = CGRectMake(0, 0, SCREEN_WIDTH_DEVICE, height);
    
    UILabel *titleLabel = [UILabel new];
    titleLabel.text = title;
    titleLabel.frame = CGRectMake(15, 0, SCREEN_WIDTH_DEVICE - 30, height);;
    titleLabel.textColor = RGBHEX(0x666666);
    [view addSubview:titleLabel];
    return view;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.chatRoomSortList.hasJoinedChatRoomArray.count;
    }
    return self.chatRoomSortList.otherChatRoomArray.count;
//    return self.chatRoomArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"chatRoomCell" forIndexPath:indexPath];
    MXRChatRoom *chatRoom = nil;
    
    UILabel *label = [cell viewWithTag:1];
    UIButton *button = [cell viewWithTag:2];
    [button removeAllActionBlocks];
    if (indexPath.section == 0) {
        chatRoom = self.chatRoomSortList.hasJoinedChatRoomArray[indexPath.row];
        button.hidden = YES;
    }
    else
    {
        chatRoom = self.chatRoomSortList.otherChatRoomArray[indexPath.row];
        __weak __typeof(self) weakSelf = self;
        [button addAction:^(id sender) {
            MXRJoinInChatRoomR *joinInChatRoomR = [MXRJoinInChatRoomR new];
            joinInChatRoomR.userId = [[UserInformation modelInformation].userID integerValue];
            joinInChatRoomR.chatRoomId = chatRoom.chatRoomId;
            [MXRChatModuleNetworkManager joinInChatRoom:joinInChatRoomR success:^(MXRNetworkResponse *response) {
                if (response.isSuccess) {
                    [weakSelf loadChatRoomListData];
                }
            } failure:^(id error) {
                NSLog(@"加入聊天室发生错误: %@", error);
            }];
        } forState:UIControlEventTouchUpInside];
        button.hidden = NO;
    }
    
    label.text = chatRoom.name;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section != 0) {
        return;
    }
    MXRChatRoomViewController *chatRoomVC = [[MXRChatRoomViewController alloc] init];
    MXRChatRoom *chatRoom = self.chatRoomSortList.hasJoinedChatRoomArray[indexPath.row];
    chatRoomVC.chatRoomId = chatRoom.chatRoomId;
    chatRoomVC.title = chatRoom.name;
    [self.navigationController pushViewController:chatRoomVC animated:YES];
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
