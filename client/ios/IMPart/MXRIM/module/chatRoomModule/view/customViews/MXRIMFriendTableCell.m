//
//  MXRIMFriendTableCell.m
//  huashida_home
//
//  Created by Martin.Liu on 2017/10/13.
//  Copyright © 2017年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import "MXRIMFriendTableCell.h"
#import "MXRIMUserInfo.h"
#import "UIImageView+WebCache.h"
@interface MXRIMFriendTableCell()

@property (strong, nonatomic) IBOutlet UIImageView *userImageView;
@property (strong, nonatomic) IBOutlet UILabel *userNickNameLabel;

@end

@implementation MXRIMFriendTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.userImageView.layer.masksToBounds = YES;
    self.userImageView.layer.cornerRadius = CGRectGetHeight(self.userImageView.frame) / 2;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setData:(id)data
{
    if ([data isKindOfClass:[MXRIMUserInfo class]]) {
        MXRIMUserInfo* model = data;
        [self.userImageView sd_setImageWithURL:[NSURL URLWithString:model.userIcon] placeholderImage:[UIImage imageNamed:@"default_head"]];
        self.userNickNameLabel.text = model.userNickName;
    }
}

@end
