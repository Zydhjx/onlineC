//
//  OCSUserChatTextCell.m
//  onlineC
//
//  Created by zyd on 2018/7/17.
//

#import "OCSUserChatTextCell.h"
#import "OCSUserChatTextModel.h"

#import "UIColor+OCSExtension.h"

#import <Masonry.h>

@interface OCSUserChatTextCell ()

@property (strong, nonatomic) UIImageView *headPortraitView;
@property (strong, nonatomic) UIImageView *messageBackgroundView;
@property (strong, nonatomic) UILabel *messageLabel;

@end

@implementation OCSUserChatTextCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (!self) { return nil; }
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self addSubviews];
    [self layout];
    
    return self;
}

- (void)addSubviews {
    [self addSubview:self.headPortraitView];
    [self addSubview:self.messageBackgroundView];
    [self.messageBackgroundView addSubview:self.messageLabel];
}

- (void)layout {
    [self.headPortraitView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(15);
        make.right.equalTo(self.mas_right).offset(-15);
        make.size.mas_equalTo(CGSizeMake(45, 45));
    }];
    [self.messageBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(5);
        make.right.equalTo(self.headPortraitView.mas_left).offset(0);
        make.bottom.equalTo(self.mas_bottom).offset(0);
        make.left.greaterThanOrEqualTo(self.mas_left).offset(26);
    }];
    [self.messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.messageBackgroundView.mas_top).offset(20);
        make.left.equalTo(self.messageBackgroundView.mas_left).offset(20);
        make.bottom.equalTo(self.messageBackgroundView.mas_bottom).offset(-20);
        make.right.equalTo(self.messageBackgroundView.mas_right).offset(-25);
    }];
}

- (void)refreshWithModel:(OCSUserChatTextModel *)model {
    self.messageLabel.text = model.sensitiveWordContent;
}

#pragma mark - getter methods

- (UIImageView *)headPortraitView {
    if (!_headPortraitView) {
        UIImageView *headPortraitView = [[UIImageView alloc] init];
        headPortraitView.image = [UIImage imageNamed:@"user_avatar_icon"];
        _headPortraitView = headPortraitView;
    }
    return _headPortraitView;
}

- (UIImageView *)messageBackgroundView {
    if (!_messageBackgroundView) {
        UIImageView *messageBackgroundView = [[UIImageView alloc] init];
        messageBackgroundView.image = [[UIImage imageNamed:@"bubble_blue_icon"] resizableImageWithCapInsets:UIEdgeInsetsMake(40, 20, 20, 20) resizingMode:UIImageResizingModeStretch];
        _messageBackgroundView.userInteractionEnabled = YES;
        _messageBackgroundView = messageBackgroundView;
    }
    return _messageBackgroundView;
}

- (UILabel *)messageLabel {
    if (!_messageLabel) {
        UILabel *messageLabel = [[UILabel alloc] init];
        messageLabel.numberOfLines = 0;
        messageLabel.font = [UIFont systemFontOfSize:14.0f];
        messageLabel.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
        _messageLabel = messageLabel;
    }
    return _messageLabel;
}

@end
