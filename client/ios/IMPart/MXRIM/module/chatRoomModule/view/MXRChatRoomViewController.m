//
//  MXRChatRoomViewController.m
//  huashida_home
//
//  Created by Martin.Liu on 2017/9/20.
//  Copyright © 2017年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import "MXRChatRoomViewController.h"
#import "JSQMessages.h"
#import "JSQMessagesViewAccessoryButtonDelegate.h"
#import "MXRChatModuleNetworkManager.h"
#import "MXRChatSocketMessage.h"
#import "MXRChatMessage.h"
#import "MXRChatRoomUserInfoListViewController.h"
#import "Masonry.h"
#import "MJRefresh.h"
@interface MXRChatRoomViewController ()<JSQMessagesComposerTextViewPasteDelegate, JSQMessagesViewAccessoryButtonDelegate>

@property (strong, nonatomic) NSMutableArray<id<JSQMessageData>> *messages;
@property (strong, nonatomic) JSQMessagesBubbleImage *outgoingBubbleImageData;
@property (strong, nonatomic) JSQMessagesBubbleImage *incomingBubbleImageData;

@end

@implementation MXRChatRoomViewController
{
    BOOL _needLoadNewMessage;
    BOOL _isLoadingNewMessage;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.title = @"JSQMessages";
    
//    self.inputToolbar.contentView.textView.pasteDelegate = self;
    
    /**
     *  Set up message accessory button delegate and configuration
     */
    self.collectionView.accessoryDelegate = self;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_topLayoutGuide);
    }];
    MJRefreshStateHeader *header = [MJRefreshStateHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadEarlierChatRoomMessagesData)];
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
    [self loadEarlierChatRoomMessagesData];
    [self addObservers];
    
    if (SOCKETINSTANCE.webSocket.readyState == SR_OPEN) {
        [self socketSendJointChatRoom:nil];
    }
    else
        [SOCKETINSTANCE connectWebSocketServer];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"全员" style:UIBarButtonItemStyleDone target:self action:@selector(clickAllMember:)];
    
}

- (void)clickAllMember:(id)sender
{
//    if (self.showTypingIndicator) {
//        [self finishReceivingMessageAnimated:YES];
//    }
//    else
//        self.showTypingIndicator = !self.showTypingIndicator;
//    return;
    MXRChatRoomUserInfoListViewController *userInfoListVC = [[UIStoryboard storyboardWithName:@"chatModule" bundle:nil] instantiateViewControllerWithIdentifier:@"MXRChatRoomUserInfoListViewController"];
    if ([userInfoListVC isKindOfClass:[MXRChatRoomUserInfoListViewController class]]) {
        userInfoListVC.chatRoomId = self.chatRoomId;
        [self.navigationController pushViewController:userInfoListVC animated:YES];
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@">>>>>>>>\n\n\n\n\n dealloc \n\n\n\n<<<<<<");
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self addObserversWillAppear];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self removeObserversWillDisappear];
}

- (void)addObservers
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(socketSendJointChatRoom:) name:MXRNOTIFICATION_SOCKETOPEN object:nil];
}

- (void)addObserversWillAppear
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveChatRoomMessage:) name:MXRNOTIFICATION_CHATROOMMESSAGE object:nil];
}

- (void)removeObserversWillDisappear
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MXRNOTIFICATION_CHATROOMMESSAGE object:nil];
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
//    SOCKETINSTANCE
    MXRChatRoomSocketMessage *chatRoomSocketMessage = [[MXRChatRoomSocketMessage alloc] initWithChatRoomId:self.chatRoomId contentType:0 content:nil type:MXRSocketType_ChatRoom_JoinChatRoom];
    [SOCKETINSTANCE broadcast:chatRoomSocketMessage type:MXRSocketType_ChatRoom_JoinChatRoom];
}

- (void)receiveChatRoomMessage:(NSNotification *)noti
{
    MXRNetworkResponse *response = noti.object;
    NSLog(@"receiveChatRoomMessage : %@ %@", response.errMsg, response.body);
    MXRChatRoomSocketMessage *chatRoomSocketMessage = [MXRChatRoomSocketMessage mxr_modelWithJSON:response.body];
    if ([chatRoomSocketMessage.chatRoomId isEqualToString:self.chatRoomId]) {
        if (_isLoadingNewMessage) {
            _needLoadNewMessage = YES;
        }
        else
            [self loadLastChatRoomMessageDate];
    }
}

- (void)loadLastChatRoomMessageDate
{
    if (self.messages.count <= 0) {
        _isLoadingNewMessage = NO;
        [self loadEarlierChatRoomMessagesData];
    }
    else
    {
        self.showTypingIndicator = YES;
        JSQMessage *message = [self.messages lastObject];
        MXRGetLastChatRoomMessageR *getLastChatRoomMessagesR = [MXRGetLastChatRoomMessageR new];
        getLastChatRoomMessagesR.chatRoomId = self.chatRoomId;
        getLastChatRoomMessagesR.afterDateTime = message.date;
        __weak __typeof(self) weakSelf = self;
        [MXRChatModuleNetworkManager getLastChatMessages:getLastChatRoomMessagesR success:^(MXRNetworkResponse *response) {
            __strong __typeof(weakSelf) strongSelf = weakSelf;
            if (!strongSelf) return ;
            NSLog(@"get last messages : %@ , \n%@", response, response.body);
            NSArray *chatMessageArray = [NSArray mxr_modelArrayWithClass:[MXRChatMessage class] json:response.body];
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

- (void)loadEarlierChatRoomMessagesData
{
    NSDate *date = nil;
    if (self.messages.count <= 0) {
        date = [NSDate date];
    }
    else
    {
        JSQMessage *message = [self.messages firstObject];
        date = message.date;
    }
    __weak __typeof(self) weakSelf = self;
    MXRGetEarlierChatRoomMessageR *getEarlierChatRoomMessageR = [MXRGetEarlierChatRoomMessageR new];
    getEarlierChatRoomMessageR.chatRoomId = self.chatRoomId;
    getEarlierChatRoomMessageR.deadlineDateTime = date;
    [MXRChatModuleNetworkManager getEarlierChatRoomMessages:getEarlierChatRoomMessageR success:^(MXRNetworkResponse *response) {
        NSLog(@"get earlier messages : %@ , \n%@", response, response.body);
        NSArray *chatMessageArray = [NSArray mxr_modelArrayWithClass:[MXRChatMessage class] json:response.body];
        NSMutableArray *tempArray = [NSMutableArray arrayWithCapacity:chatMessageArray.count];
        for (MXRChatMessage *chatMessage in chatMessageArray) {
            [tempArray addObject:[chatMessage buildJSQMessage]];
        }
        //        [weakSelf.messages addObjectsFromArray:tempArray];
        [tempArray addObjectsFromArray:self.messages];
        weakSelf.messages = tempArray;
        [weakSelf finishReceivingMessage];
        [weakSelf.collectionView.mj_header endRefreshing];
    } failure:^(id error) {
        NSLog(@"get earlier messages error : %@", error);
        [weakSelf finishReceivingMessage];
        [weakSelf.collectionView.mj_header endRefreshing];
    }];
    
//    [MXRChatModuleNetworkManager getChatMessagesWithRoomId:self.chatRoomId success:^(MXRNetworkResponse *response) {
//        NSLog(@"get messages : %@ , \n%@", response, response.body);
//        NSArray *chatMessageArray = [NSArray mxr_modelArrayWithClass:[MXRChatMessage class] json:response.body];
//        NSMutableArray *tempArray = [NSMutableArray arrayWithCapacity:chatMessageArray.count];
//        for (MXRChatMessage *chatMessage in chatMessageArray) {
//            [tempArray addObject:[chatMessage buildJSQMessage]];
//        }
////        [weakSelf.messages addObjectsFromArray:tempArray];
//        weakSelf.messages = tempArray;
//        [weakSelf finishReceivingMessage];
//
//    } failure:^(id error) {
//        NSLog(@"get messages error : %@", error);
//    }];
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
    
    // [JSQSystemSoundPlayer jsq_playMessageSentSound];
    
//    JSQMessage *message = [[JSQMessage alloc] initWithSenderId:senderId
//                                             senderDisplayName:senderDisplayName
//                                                          date:date
//                                                          text:text];
    
    MXRChatRoomSocketMessage *chatRoomSocketMessage = [[MXRChatRoomSocketMessage alloc] initWithChatRoomId:self.chatRoomId contentType:0 content:text type:MXRSocketType_ChatRoom_SendChatRoomMessage];
    [SOCKETINSTANCE broadcast:chatRoomSocketMessage type:MXRSocketType_ChatRoom_SendChatRoomMessage];
    
//    [self.messages addObject:message];
    
    [self finishSendingMessageAnimated:YES];
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



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSMutableArray *)messages
{
    if (!_messages) {
        _messages = [NSMutableArray array];
    }
    return _messages;
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
    [self.messages removeObjectAtIndex:indexPath.item];
}

- (id<JSQMessageBubbleImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView messageBubbleImageDataForItemAtIndexPath:(NSIndexPath *)indexPath
{
    /**
     *  You may return nil here if you do not want bubbles.
     *  In this case, you should set the background color of your collection view cell's textView.
     *
     *  Otherwise, return your previously created bubble image data objects.
     */
    
    JSQMessage *message = [self.messages objectAtIndex:indexPath.item];
    
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
    NSString *senderDisplayName = self.messages[indexPath.row].senderDisplayName;
    if (senderDisplayName.length > 3) {
        senderDisplayName = [senderDisplayName substringToIndex:3];
    }
    
    JSQMessagesAvatarImage *jsqImage = [avatarFactory avatarImageWithUserInitials:senderDisplayName ?: @""
                                                                  backgroundColor:[UIColor colorWithWhite:0.85f alpha:1.0f]
                                                                        textColor:[UIColor colorWithWhite:0.60f alpha:1.0f]
                                                                             font:[UIFont systemFontOfSize:14.0f]];
    return jsqImage;
    
    
//    JSQMessage *message = [self.demoData.messages objectAtIndex:indexPath.item];
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
        JSQMessage *message = [self.messages objectAtIndex:indexPath.item];
        return [[JSQMessagesTimestampFormatter sharedFormatter] attributedTimestampForDate:message.date];
    }
    
    return nil;
}

- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForMessageBubbleTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
    JSQMessage *message = [self.messages objectAtIndex:indexPath.item];
    
    /**
     *  iOS7-style sender name labels
     */
    if ([message.senderId isEqualToString:self.senderId]) {
        return nil;
    }
    
    if (indexPath.item - 1 > 0) {
        JSQMessage *previousMessage = [self.messages objectAtIndex:indexPath.item - 1];
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
    
    JSQMessage *msg = [self.messages objectAtIndex:indexPath.item];
    
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
    
    cell.accessoryButton.hidden = ![self shouldShowAccessoryButtonForMessage:msg];
    
    return cell;
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
    JSQMessage *currentMessage = [self.messages objectAtIndex:indexPath.item];
    if ([[currentMessage senderId] isEqualToString:self.senderId]) {
        return 0.0f;
    }
    
    if (indexPath.item - 1 > 0) {
        JSQMessage *previousMessage = [self.messages objectAtIndex:indexPath.item - 1];
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
        JSQMessage *message = [[JSQMessage alloc] initWithSenderId:self.senderId
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
