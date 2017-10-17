//
//  MXRIMP2PChatViewController.m
//  huashida_home
//
//  Created by Martin.Liu on 2017/10/13.
//  Copyright © 2017年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import "MXRIMP2PChatViewController.h"
#import "JSQMessages.h"
#import "JSQMessagesViewAccessoryButtonDelegate.h"
#import "MXRChatModuleNetworkManager.h"
#import "MXRChatSocketMessage.h"
#import "MXRChatMessage.h"
#import "MXRChatRoomUserInfoListViewController.h"
#import "Masonry.h"
#import "MJRefresh.h"
#import "UIButton+MXRLoading.h"

@interface MXRIMP2PChatViewController ()<JSQMessagesComposerTextViewPasteDelegate, JSQMessagesViewAccessoryButtonDelegate>

@property (strong, nonatomic) NSString *chatRoomId;

@property (strong, nonatomic) NSMutableOrderedSet<MXRP2PChatMessage *> *messages;
@property (strong, nonatomic) JSQMessagesBubbleImage *outgoingBubbleImageData;
@property (strong, nonatomic) JSQMessagesBubbleImage *incomingBubbleImageData;

@end

@implementation MXRIMP2PChatViewController
{
    BOOL _needLoadNewMessage;
    BOOL _isLoadingNewMessage;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.collectionView.accessoryDelegate = self;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_topLayoutGuide);
    }];
    MJRefreshStateHeader *header = [MJRefreshStateHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadLocalEarlierChatMessageData)];
    header.lastUpdatedTimeLabel.hidden = YES;
    self.collectionView.mj_header = header;
    /**
     *  You can set custom avatar sizes
     */
    //    self.collectionView.collectionViewLayout.incomingAvatarViewSize = CGSizeZero;
    //
    //
    //    self.collectionView.collectionViewLayout.outgoingAvatarViewSize = CGSizeZero;
    
    
    //    self.showLoadEarlierMessagesHeader = YES;
    self.automaticallyScrollsToMostRecentMessage = YES;
    
    [JSQMessagesCollectionViewCell registerMenuAction:@selector(delete:)];
    
    [self addObservers];
    
    if (SOCKETINSTANCE.webSocket.readyState == SR_OPEN) {
        [self socketSendJointChatRoom:nil];
    }
    else
        [SOCKETINSTANCE connectWebSocketServer];
    
    [self loadAllChatMessagesData];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadLastChatRoomMessageDate];
    [self addObserversWillAppear];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self removeObserversWillDisappear];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addObservers
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(socketSendJointChatRoom:) name:MXRNOTIFICATION_SOCKETOPEN object:nil];
}

- (void)addObserversWillAppear
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveChatRoomMessage:) name:MXRNOTIFICATION_P2PCHATMESSAGE object:nil];
}

- (void)removeObserversWillDisappear
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MXRNOTIFICATION_P2PCHATMESSAGE object:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    /**
     *  Enable/disable springy bubbles, default is NO.
     *  You must set this from `viewDidAppear:`
     *  Note: this feature is mostly stable, but still experimental
     */
    //    self.collectionView.collectionViewLayout.springinessEnabled = YES;
}

- (void)socketSendJointChatRoom:(NSNotification *)noti
{
    return;
    //    SOCKETINSTANCE
    MXRChatRoomSocketMessage *chatRoomSocketMessage = [[MXRChatRoomSocketMessage alloc] initWithChatRoomId:self.chatRoomId contentType:0 content:nil type:MXRSocketType_ChatRoom_JoinChatRoom];
    [SOCKETINSTANCE broadcast:chatRoomSocketMessage type:MXRSocketType_ChatRoom_JoinChatRoom];
}

- (void)receiveChatRoomMessage:(NSNotification *)noti
{
    MXRNetworkResponse *response = noti.object;
    NSLog(@"receiveChatRoomMessage : %@ %@", response.errMsg, response.body);
//    MXRP2PChatSocketMessage *p2pChatSocketMessage = [MXRP2PChatSocketMessage mxr_modelWithJSON:response.body];
    
    if (_isLoadingNewMessage) {
        _needLoadNewMessage = YES;
    }
    else
        [self loadLastChatRoomMessageDate];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)loadLocalEarlierChatMessageData
{
    NSDate *date = nil;
    if (self.messages.count <= 0) {
        date = [NSDate date];
    }
    else
    {
        MXRP2PChatMessage *message = [self.messages firstObject];
        date = message.date;
    }
    NSInteger count = 20;
    NSArray *messageArray = [MXRP2PChatMessage sortedChatMessageArrayWithCreateTime:date withCount:count];
    if (messageArray.count > 0) {
        NSMutableOrderedSet *tempSet = [NSMutableOrderedSet orderedSetWithArray:messageArray];
        [tempSet addObjectsFromArray:self.messages.array];
        self.messages = tempSet;
        [self.collectionView reloadData];
        [self.collectionView.mj_header endRefreshing];
    }
    if (messageArray.count < count) {
        [self loadEarlierChatRoomMessagesData];
    }
}

- (void)loadLastChatRoomMessageDate
{
    if (self.messages.count <= 0) {
        _isLoadingNewMessage = NO;
        [self loadLocalEarlierChatMessageData];
    }
    else
    {
        self.showTypingIndicator = YES;
        MXRP2PChatMessage *message = [self.messages lastObject];
        
        MXRGetLastP2PChatMessageR *getLastP2PChatMeesageR = [MXRGetLastP2PChatMessageR new];
        getLastP2PChatMeesageR.senderId = [[UserInformation modelInformation].userID integerValue];
        getLastP2PChatMeesageR.receiverId = self.friendUserId;
        getLastP2PChatMeesageR.afterDateTime = message.date;
        
        __weak __typeof(self) weakSelf = self;
        [MXRChatModuleNetworkManager getLastP2PChatMessages:getLastP2PChatMeesageR success:^(MXRNetworkResponse *response) {
            __strong __typeof(weakSelf) strongSelf = weakSelf;
            if (!strongSelf) return ;
            NSLog(@"get last messages : %@ , \n%@", response, response.body);
            NSArray *chatMessageArray = [NSArray mxr_modelArrayWithClass:[MXRP2PChatMessage class] json:response.body];
            NSMutableArray *tempArray = [NSMutableArray arrayWithArray:chatMessageArray];
            //        [weakSelf.messages addObjectsFromArray:tempArray];
            [strongSelf.messages addObjectsFromArray:tempArray];
            [strongSelf finishReceivingMessage];
            if (strongSelf->_needLoadNewMessage) {
                strongSelf->_needLoadNewMessage = NO;
                [strongSelf loadLastChatRoomMessageDate];
            }
            else
            {
                strongSelf->_isLoadingNewMessage = NO;
                strongSelf.showTypingIndicator = NO;
            }
        } failure:^(id error) {
            __strong __typeof(weakSelf) strongSelf = weakSelf;
            if (!strongSelf) return ;
            strongSelf->_needLoadNewMessage = NO;
            strongSelf->_isLoadingNewMessage = NO;
            strongSelf.showTypingIndicator = NO;
            NSLog(@"get last messages error : %@", error);
        }];
        
        return;
        MXRGetLastChatRoomMessageR *getLastChatRoomMessagesR = [MXRGetLastChatRoomMessageR new];
        getLastChatRoomMessagesR.chatRoomId = self.chatRoomId;
        getLastChatRoomMessagesR.afterDateTime = message.date;
        [MXRChatModuleNetworkManager getLastChatMessages:getLastChatRoomMessagesR success:^(MXRNetworkResponse *response) {
            __strong __typeof(weakSelf) strongSelf = weakSelf;
            if (!strongSelf) return ;
            NSLog(@"get last messages : %@ , \n%@", response, response.body);
            NSArray *chatMessageArray = [NSArray mxr_modelArrayWithClass:[MXRP2PChatMessage class] json:response.body];
            NSMutableArray *tempArray = [NSMutableArray arrayWithCapacity:chatMessageArray.count];
            for (MXRChatMessage *chatMessage in chatMessageArray) {
                [tempArray addObject:[chatMessage buildJSQMessage]];
            }
            //        [weakSelf.messages addObjectsFromArray:tempArray];
            [strongSelf.messages addObjectsFromArray:tempArray];
            [strongSelf finishReceivingMessage];
            if (strongSelf->_needLoadNewMessage) {
                strongSelf->_needLoadNewMessage = NO;
                [strongSelf loadLastChatRoomMessageDate];
            }
            else
            {
                strongSelf->_isLoadingNewMessage = NO;
                strongSelf.showTypingIndicator = NO;
            }
        } failure:^(id error) {
            __strong __typeof(weakSelf) strongSelf = weakSelf;
            if (!strongSelf) return ;
            strongSelf->_needLoadNewMessage = NO;
            strongSelf->_isLoadingNewMessage = NO;
            strongSelf.showTypingIndicator = NO;
            NSLog(@"get last messages error : %@", error);
        }];
    }
}

- (void)loadAllChatMessagesData
{
    __weak __typeof(self) weakSelf = self;
    MXRGetEarlierP2PChatMessageR *getEarlierP2PChatMessageR = [MXRGetEarlierP2PChatMessageR new];
    getEarlierP2PChatMessageR.senderId =  [[UserInformation modelInformation].userID integerValue];
    getEarlierP2PChatMessageR.receiverId = self.friendUserId;
    getEarlierP2PChatMessageR.deadlineDateTime = [NSDate date];
    getEarlierP2PChatMessageR.pageIndex = 1;
    getEarlierP2PChatMessageR.pageSize = 10000;
    [MXRChatModuleNetworkManager getEarlierP2PChatMessages:getEarlierP2PChatMessageR success:^(MXRNetworkResponse *response) {
        if (response.isSuccess) {
            NSArray *chatMessageArray = [NSArray mxr_modelArrayWithClass:[MXRP2PChatMessage class] json:response.body];
            
            for (id message in chatMessageArray) {
                BOOL saveed = [message updateToDB];
                NSLog(@"saved : %d", saveed);
            }
            [weakSelf.messages removeAllObjects];
            [weakSelf loadLocalEarlierChatMessageData];
        }
        NSLog(@"get earlier p2p message : %@, errMsg : %@", response.body, response.errMsg);
        
    } failure:^(id error) {
        NSLog(@"get earlier p2p message error >>> %@", error);
        [weakSelf finishReceivingMessage];
        [weakSelf.collectionView.mj_header endRefreshing];
    }];
}

- (void)loadEarlierChatRoomMessagesData
{
    NSDate *date = nil;
    if (self.messages.count <= 0) {
        date = [NSDate date];
    }
    else
    {
        MXRP2PChatMessage *message = [self.messages firstObject];
        date = message.date;
    }
    __weak __typeof(self) weakSelf = self;
    MXRGetEarlierP2PChatMessageR *getEarlierP2PChatMessageR = [MXRGetEarlierP2PChatMessageR new];
    getEarlierP2PChatMessageR.senderId =  [[UserInformation modelInformation].userID integerValue];
    getEarlierP2PChatMessageR.receiverId = self.friendUserId;
    getEarlierP2PChatMessageR.deadlineDateTime = date;
    [MXRChatModuleNetworkManager getEarlierP2PChatMessages:getEarlierP2PChatMessageR success:^(MXRNetworkResponse *response) {
        if (response.isSuccess) {
            NSArray *chatMessageArray = [NSArray mxr_modelArrayWithClass:[MXRP2PChatMessage class] json:response.body];
            
            for (id message in chatMessageArray) {
                BOOL saveed = [message updateToDB];
                NSLog(@"saved : %d", saveed);
            }
            
            NSMutableOrderedSet *tempSet = [NSMutableOrderedSet orderedSetWithArray:chatMessageArray];
            [tempSet addObjectsFromArray:weakSelf.messages.array];
            weakSelf.messages = tempSet;
            [weakSelf finishReceivingMessage];
            [weakSelf.collectionView.mj_header endRefreshing];
        }
        NSLog(@"get earlier p2p message : %@, errMsg : %@", response.body, response.errMsg);
        
    } failure:^(id error) {
        NSLog(@"get earlier p2p message error >>> %@", error);
        [weakSelf finishReceivingMessage];
        [weakSelf.collectionView.mj_header endRefreshing];
    }];
}

- (void)loadEarlierMessages
{
    [self.collectionView.mj_header endRefreshing];
}

#pragma mark - Custom menu actions for cells

- (void)didReceiveMenuWillShowNotification:(NSNotification *)notification
{
    /**
     *  Display custom menu actions for cells.
     */
    UIMenuController *menu = [notification object];
    menu.menuItems = @[ [[UIMenuItem alloc] initWithTitle:@"Custom Action" action:@selector(customAction:)] ];
    
    [super didReceiveMenuWillShowNotification:notification];
}



- (void)didPressSendButton:(UIButton *)button
           withMessageText:(NSString *)text
                  senderId:(NSString *)senderId
         senderDisplayName:(NSString *)senderDisplayName
                      date:(NSDate *)date
{
    /**
     *  Sending a message. Your implementation of this method should do *at least* the following:
     *
     *  1. Play sound (optional)
     *  2. Add new id<JSQMessageData> object to your data source
     *  3. Call `finishSendingMessage`
     */
    
    MXRP2PChatMessage *p2pChatMessage = [[MXRP2PChatMessage alloc] initWithSenderId:[UserInformation modelInformation].userID ?: @"0" senderDisplayName:[UserInformation modelInformation].userNickName ?: @"123" date:[NSDate new]  text:text];
    p2pChatMessage.receiverId = self.friendUserId;
    p2pChatMessage.receiveUserName = self.userInfo.userNickName;
    [p2pChatMessage prepareToSend];
    [self.messages addObject:p2pChatMessage];
    
    [self sendP2PChatMessage:p2pChatMessage];
    
    [self finishSendingMessageAnimated:YES];
}

- (void)updateMessageWithUUID:(NSString *)UUID status:(MXRIMMessageStatus)status
{
    MXRP2PChatMessage *tmpMessage = [MXRP2PChatMessage new];
    tmpMessage.messageUUID = UUID;
    NSInteger index = [self.messages indexOfObject:tmpMessage];
    if (index != NSNotFound) {
        tmpMessage = [self.messages objectAtIndex:index];
        if (tmpMessage.status == MXRIMMessageStatusResending) {
            [self.messages sortUsingComparator:^NSComparisonResult(MXRP2PChatMessage *  _Nonnull obj1, MXRP2PChatMessage *  _Nonnull obj2) {
                return [obj1.date compare:obj2.date];
            }];
        }
        tmpMessage.status = status;
        [tmpMessage updateToDB];
        [self.collectionView reloadData];
    }
}

- (void)didPressAccessoryButton:(UIButton *)sender
{
    return;
    [self.inputToolbar.contentView.textView resignFirstResponder];
    
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"Media messages", nil)
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                                         destructiveButtonTitle:nil
                                              otherButtonTitles:NSLocalizedString(@"Send photo", nil), NSLocalizedString(@"Send location", nil), NSLocalizedString(@"Send video", nil), NSLocalizedString(@"Send video thumbnail", nil), NSLocalizedString(@"Send audio", nil), nil];
    
    [sheet showFromToolbar:self.inputToolbar];
}

- (NSMutableOrderedSet<MXRP2PChatMessage *> *)messages
{
    if (!_messages) {
        _messages = [[NSMutableOrderedSet alloc] init];
    }
    return _messages;
}

- (NSInteger)friendUserId
{
    return _friendUserId ? _friendUserId : self.userInfo.userID;
}

- (JSQMessagesBubbleImage *)incomingBubbleImageData
{
    if ((!_incomingBubbleImageData)) {
        JSQMessagesBubbleImageFactory *bubbleFactory = [[JSQMessagesBubbleImageFactory alloc] init];
        
        _incomingBubbleImageData= [bubbleFactory incomingMessagesBubbleImageWithColor:[UIColor jsq_messageBubbleGreenColor]];
    }
    return _incomingBubbleImageData;
}

- (JSQMessagesBubbleImage *)outgoingBubbleImageData
{
    if (!_outgoingBubbleImageData) {
        JSQMessagesBubbleImageFactory *bubbleFactory = [[JSQMessagesBubbleImageFactory alloc] init];
        _outgoingBubbleImageData = [bubbleFactory outgoingMessagesBubbleImageWithColor:[UIColor jsq_messageBubbleLightGrayColor]];
    }
    return _outgoingBubbleImageData;
}

#pragma mark - JSQMessages CollectionView DataSource

- (NSString *)senderId {
    return [UserInformation modelInformation].userID;
}

- (NSString *)senderDisplayName {
    return [UserInformation modelInformation].userNickName;
}


- (id<JSQMessageData>)collectionView:(JSQMessagesCollectionView *)collectionView messageDataForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.messages objectAtIndex:indexPath.item];
}

- (void)collectionView:(JSQMessagesCollectionView *)collectionView didDeleteMessageAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.messages.count > indexPath.item) {
        MXRIMMessage *message = [self.messages objectAtIndex:indexPath.item];
        message.status = MXRIMMessageStatusDelete;
        [message updateToDB];
        MXRDeleteP2PChatMessageR *deleteP2PChatMessageR = [MXRDeleteP2PChatMessageR new];
        deleteP2PChatMessageR.messageUUID = message.messageUUID;
        [MXRChatModuleNetworkManager deleteP2PChatMessage:deleteP2PChatMessageR success:^(MXRNetworkResponse *response) {
            if (response.isSuccess) {
                [MXRConstant showAlert:@"删除成功" andShowTime:1.f];
            }
            else
            {
                [MXRConstant showAlert:@"删除失败" andShowTime:1.f];
            }
        } failure:^(id error) {
            [MXRConstant showAlert:@"删除失败" andShowTime:1.f];
        }];
//        [message deleteToDB];
        [self.messages removeObjectAtIndex:indexPath.item];
    }
}

- (id<JSQMessageBubbleImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView messageBubbleImageDataForItemAtIndexPath:(NSIndexPath *)indexPath
{
    /**
     *  You may return nil here if you do not want bubbles.
     *  In this case, you should set the background color of your collection view cell's textView.
     *
     *  Otherwise, return your previously created bubble image data objects.
     */
    
    MXRP2PChatMessage *message = [self.messages objectAtIndex:indexPath.item];
    
    if ([message.senderId isEqualToString:self.senderId]) {
        return self.outgoingBubbleImageData;
    }
    return self.incomingBubbleImageData;
}

- (id<JSQMessageAvatarImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView avatarImageDataForItemAtIndexPath:(NSIndexPath *)indexPath
{
    /**
     *  Return `nil` here if you do not want avatars.
     *  If you do return `nil`, be sure to do the following in `viewDidLoad`:
     *
     *  self.collectionView.collectionViewLayout.incomingAvatarViewSize = CGSizeZero;
     *  self.collectionView.collectionViewLayout.outgoingAvatarViewSize = CGSizeZero;
     *
     *  It is possible to have only outgoing avatars or only incoming avatars, too.
     */
    
    /**
     *  Return your previously created avatar image data objects.
     *
     *  Note: these the avatars will be sized according to these values:
     *
     *  self.collectionView.collectionViewLayout.incomingAvatarViewSize
     *  self.collectionView.collectionViewLayout.outgoingAvatarViewSize
     *
     *  Override the defaults in `viewDidLoad`
     */
    
    JSQMessagesAvatarImageFactory *avatarFactory = [[JSQMessagesAvatarImageFactory alloc] initWithDiameter:kJSQMessagesCollectionViewAvatarSizeDefault];
    NSString *senderDisplayName = [self.messages objectAtIndex:indexPath.row].senderDisplayName;
    if (senderDisplayName.length > 3) {
        senderDisplayName = [senderDisplayName substringToIndex:3];
    }
    
    JSQMessagesAvatarImage *jsqImage = [avatarFactory avatarImageWithUserInitials:senderDisplayName ?: @""
                                                                  backgroundColor:[UIColor colorWithWhite:0.85f alpha:1.0f]
                                                                        textColor:[UIColor colorWithWhite:0.60f alpha:1.0f]
                                                                             font:[UIFont systemFontOfSize:14.0f]];
    return jsqImage;
    
    
    //    MXRP2PChatMessage *message = [self.demoData.messages objectAtIndex:indexPath.item];
    //
    //    if ([message.senderId isEqualToString:self.senderId]) {
    //        if (![NSUserDefaults outgoingAvatarSetting]) {
    //            return nil;
    //        }
    //    }
    //    else {
    //        if (![NSUserDefaults incomingAvatarSetting]) {
    //            return nil;
    //        }
    //    }
    //
    //
    //    return [self.demoData.avatars objectForKey:message.senderId];
}

- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForCellTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
    /**
     *  This logic should be consistent with what you return from `heightForCellTopLabelAtIndexPath:`
     *  The other label text delegate methods should follow a similar pattern.
     *
     *  Show a timestamp for every 3rd message
     */
    if (indexPath.item % 3 == 0) {
        MXRP2PChatMessage *message = [self.messages objectAtIndex:indexPath.item];
        return [[JSQMessagesTimestampFormatter sharedFormatter] attributedTimestampForDate:message.date];
    }
    
    return nil;
}

- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForMessageBubbleTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
    MXRP2PChatMessage *message = [self.messages objectAtIndex:indexPath.item];
    
    /**
     *  iOS7-style sender name labels
     */
    if ([message.senderId isEqualToString:self.senderId]) {
        return nil;
    }
    
    if (indexPath.item - 1 > 0) {
        MXRP2PChatMessage *previousMessage = [self.messages objectAtIndex:indexPath.item - 1];
        if ([[previousMessage senderId] isEqualToString:message.senderId]) {
            return nil;
        }
    }
    
    /**
     *  Don't specify attributes to use the defaults.
     */
    return [[NSAttributedString alloc] initWithString:message.senderDisplayName];
}

- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForCellBottomLabelAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

#pragma mark - UICollectionView DataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.messages count];
}

- (UICollectionViewCell *)collectionView:(JSQMessagesCollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    /**
     *  Override point for customizing cells
     */
    JSQMessagesCollectionViewCell *cell = (JSQMessagesCollectionViewCell *)[super collectionView:collectionView cellForItemAtIndexPath:indexPath];
    
    /**
     *  Configure almost *anything* on the cell
     *
     *  Text colors, label text, label colors, etc.
     *
     *
     *  DO NOT set `cell.textView.font` !
     *  Instead, you need to set `self.collectionView.collectionViewLayout.messageBubbleFont` to the font you want in `viewDidLoad`
     *
     *
     *  DO NOT manipulate cell layout information!
     *  Instead, override the properties you want on `self.collectionView.collectionViewLayout` from `viewDidLoad`
     */
    
    MXRP2PChatMessage *msg = [self.messages objectAtIndex:indexPath.item];
    
    if (!msg.isMediaMessage) {
        
        //        if ([msg.senderId isEqualToString:self.senderId]) {
        cell.textView.textColor = [UIColor blackColor];
        //        }
        //        else {
        //            cell.textView.textColor = [UIColor whiteColor];
        //        }
        
        cell.textView.linkTextAttributes = @{ NSForegroundColorAttributeName : cell.textView.textColor,
                                              NSUnderlineStyleAttributeName : @(NSUnderlineStyleSingle | NSUnderlinePatternSolid) };
    }
    [cell.accessoryButton removeAllActionBlocks];
    switch (msg.status) {
        case MXRIMMessageStatusSending:
        case MXRIMMessageStatusResending:
            {
                cell.accessoryButton.hidden = NO;
                [cell.accessoryButton setImage:nil forState:UIControlStateNormal];
                cell.accessoryButton.loadingViewColor = [UIColor lightGrayColor];
                [cell.accessoryButton startLoading];
            }
            break;
        case MXRIMMessageStatusSendFailure:
        {
            cell.accessoryButton.hidden = NO;
            [cell.accessoryButton setImage:[UIImage imageNamed:@"icon_IM_resend_message"] forState:UIControlStateNormal];
            __weak __typeof(self) weakSelf = self;
            [cell.accessoryButton addAction:^(id sender) {
                [msg prepareToResend];
                [weakSelf.collectionView reloadData];
                [weakSelf sendP2PChatMessage:msg];
            } forState:UIControlEventTouchUpInside];
        }
            break;
        default:
            cell.accessoryButton.hidden = YES;
            break;
    }
//    cell.accessoryButton.hidden = ![self shouldShowAccessoryButtonForMessage:msg];
    
    return cell;
}

- (void)sendP2PChatMessage:(MXRP2PChatMessage *)p2pChatMessage
{
    [p2pChatMessage updateToDB];
    MXRP2PChatSocketMessage *p2pchatSocketMessage = [p2pChatMessage buildP2pChatSocketMessage];

    NSString *tmpMessageUUID = p2pChatMessage.messageUUID;
    __weak __typeof(self) weakSelf = self;
    MXRAddP2PChatMessageR *addP2PChatMessageR = [p2pChatMessage buildAddP2PChatMessageR];
    [MXRChatModuleNetworkManager addP2PchatMessage:addP2PChatMessageR success:^(MXRNetworkResponse *response) {
        if (response.isSuccess) {
            [SOCKETINSTANCE broadcast:p2pchatSocketMessage type:MXRSocketType_P2PChat_SendChatMessage];
            NSString* messageUUID = response.body;
            [weakSelf updateMessageWithUUID:messageUUID status:MXRIMMessageStatusNormal];
        }
        else
        {
            [weakSelf updateMessageWithUUID:tmpMessageUUID status:MXRIMMessageStatusSendFailure];
        }
        NSLog(@"add p2p message success : %@ , errMsg: %@", response.body, response.errMsg);
    } failure:^(id error) {
        NSLog(@"add p2p message error :>>>>> %@", error);
        [weakSelf updateMessageWithUUID:tmpMessageUUID status:MXRIMMessageStatusSendFailure];
    }];
}

- (BOOL)shouldShowAccessoryButtonForMessage:(id<JSQMessageData>)message
{
    return ([message isMediaMessage] && NO);
}

#pragma mark - UICollectionView Delegate

#pragma mark - Custom menu items

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender
{
    if (action == @selector(customAction:)) {
        return YES;
    }

    if (action == @selector(delete:)) {
        if (self.messages.count > indexPath.item){
            MXRP2PChatMessage *message = [self.messages objectAtIndex:indexPath.item];
            // 只能删除自己发的消息  优化：可以再加上时间限制等
            if ([message.senderId isEqual:[UserInformation modelInformation].userID]) {
                return YES;
            }
        }
        return NO;
    }
    
    return [super collectionView:collectionView canPerformAction:action forItemAtIndexPath:indexPath withSender:sender];
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender
{
    if (action == @selector(customAction:)) {
        [self customAction:sender];
        return;
    }
    
    [super collectionView:collectionView performAction:action forItemAtIndexPath:indexPath withSender:sender];
}

- (void)customAction:(id)sender
{
    NSLog(@"Custom action received! Sender: %@", sender);
    
    [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Custom Action", nil)
                                message:nil
                               delegate:nil
                      cancelButtonTitle:NSLocalizedString(@"OK", nil)
                      otherButtonTitles:nil]
     show];
}

#pragma mark - JSQMessages collection view flow layout delegate

#pragma mark - Adjusting cell label heights

- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView
                   layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForCellTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
    /**
     *  Each label in a cell has a `height` delegate method that corresponds to its text dataSource method
     */
    
    /**
     *  This logic should be consistent with what you return from `attributedTextForCellTopLabelAtIndexPath:`
     *  The other label height delegate methods should follow similarly
     *
     *  Show a timestamp for every 3rd message
     */
    if (indexPath.item % 3 == 0) {
        return kJSQMessagesCollectionViewCellLabelHeightDefault;
    }
    
    return 0.0f;
}

- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView
                   layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForMessageBubbleTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
    /**
     *  iOS7-style sender name labels
     */
    MXRP2PChatMessage *currentMessage = [self.messages objectAtIndex:indexPath.item];
    if ([[currentMessage senderId] isEqualToString:self.senderId]) {
        return 0.0f;
    }
    
    if (indexPath.item - 1 > 0) {
        MXRP2PChatMessage *previousMessage = [self.messages objectAtIndex:indexPath.item - 1];
        if ([[previousMessage senderId] isEqualToString:[currentMessage senderId]]) {
            return 0.0f;
        }
    }
    
    return kJSQMessagesCollectionViewCellLabelHeightDefault;
}

- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView
                   layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForCellBottomLabelAtIndexPath:(NSIndexPath *)indexPath
{
    return 0.0f;
}

#pragma mark - Responding to collection view tap events

- (void)collectionView:(JSQMessagesCollectionView *)collectionView
                header:(JSQMessagesLoadEarlierHeaderView *)headerView didTapLoadEarlierMessagesButton:(UIButton *)sender
{
    NSLog(@"Load earlier messages!");
}

- (void)collectionView:(JSQMessagesCollectionView *)collectionView didTapAvatarImageView:(UIImageView *)avatarImageView atIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Tapped avatar!");
}

- (void)collectionView:(JSQMessagesCollectionView *)collectionView didTapMessageBubbleAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Tapped message bubble!");
}

- (void)collectionView:(JSQMessagesCollectionView *)collectionView didTapCellAtIndexPath:(NSIndexPath *)indexPath touchLocation:(CGPoint)touchLocation
{
    NSLog(@"Tapped cell at %@!", NSStringFromCGPoint(touchLocation));
}

#pragma mark - JSQMessagesComposerTextViewPasteDelegate methods

- (BOOL)composerTextView:(JSQMessagesComposerTextView *)textView shouldPasteWithSender:(id)sender
{
    if ([UIPasteboard generalPasteboard].image) {
        // If there's an image in the pasteboard, construct a media item with that image and `send` it.
        JSQPhotoMediaItem *item = [[JSQPhotoMediaItem alloc] initWithImage:[UIPasteboard generalPasteboard].image];
        MXRP2PChatMessage *message = [[JSQMessage alloc] initWithSenderId:self.senderId
                                                 senderDisplayName:self.senderDisplayName
                                                              date:[NSDate date]
                                                             media:item];
        
        [self finishSendingMessage];
        return NO;
    }
    return YES;
}

#pragma mark - JSQMessagesViewAccessoryDelegate methods

- (void)messageView:(JSQMessagesCollectionView *)view didTapAccessoryButtonAtIndexPath:(NSIndexPath *)path
{
    NSLog(@"Tapped accessory button!");
}

@end
