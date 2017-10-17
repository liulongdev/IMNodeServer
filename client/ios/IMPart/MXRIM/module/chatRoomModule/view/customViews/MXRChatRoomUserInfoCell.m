//
//  MXRChatRoomUserInfoCell.m
//  
//
//  Created by Martin.Liu on 2017/9/30.
//

#import "MXRChatRoomUserInfoCell.h"
#import "UIImageView+WebCache.h"
#import "MXRIMUserInfo.h"

@interface MXRChatRoomUserInfoCell()
@property (strong, nonatomic) IBOutlet UIImageView *userImageView;
@property (strong, nonatomic) IBOutlet UILabel *userNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *userGenderLabel;

@end

@implementation MXRChatRoomUserInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.userImageView.layer.masksToBounds = YES;
    self.userImageView.layer.cornerRadius = CGRectGetHeight(self.userImageView.frame)/2;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setData:(id)data
{
    if ([data isKindOfClass:[MXRIMUserInfo class]]) {
        MXRIMUserInfo *userInfo = data;
        [self.userImageView sd_setImageWithURL:[NSURL URLWithString:userInfo.userIcon] placeholderImage:[UIImage imageNamed:@"default_head"]];
        self.userNameLabel.text = userInfo.userNickName;
        self.userGenderLabel.text = userInfo.userSexString;
    }
}

@end
