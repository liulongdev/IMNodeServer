//
//  MXRReceiveInvitationCell.m
//  huashida_home
//
//  Created by Martin.Liu on 2017/10/12.
//  Copyright © 2017年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import "MXRReceiveInvitationCell.h"
#import "MXRReceiveInvitationModel.h"
#import "UIImageView+WebCache.h"
@interface MXRReceiveInvitationCell()
@property (strong, nonatomic) IBOutlet UIImageView *userImageView;
@property (strong, nonatomic) IBOutlet UILabel *userNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *invitationDescriptionLabel;

@end

@implementation MXRReceiveInvitationCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setData:(id)data
{
    if ([data isKindOfClass:[MXRReceiveInvitationModel class]]) {
        MXRReceiveInvitationModel *model = data;
        [self.userImageView sd_setImageWithURL:[NSURL URLWithString:model.userIcon] placeholderImage:[UIImage imageNamed:@"default_head"]];
        self.userNameLabel.text = model.userNickName;
        self.invitationDescriptionLabel.text = model.content; 
    }
}

@end
