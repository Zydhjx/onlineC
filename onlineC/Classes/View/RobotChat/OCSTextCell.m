//
//  OCSTextCell.m
//  onlineC
//
//  Created by zyd on 2018/7/16.
//

#import "OCSTextCell.h"
#import "OCSTextModel.h"

#import "UIColor+OCSExtension.h"

#import <Masonry.h>
#import <YYLabel.h>

@interface OCSTextCell ()

@property (strong, nonatomic) UIImageView *headPortraitView;
@property (strong, nonatomic) UIImageView *messageBackgroundView;
@property (strong, nonatomic) YYLabel *messageLabel;

@end

@implementation OCSTextCell

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
        make.left.equalTo(self.mas_left).offset(15);
        make.size.mas_equalTo(CGSizeMake(45, 45));
    }];
    [self.messageBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(5);
        make.left.equalTo(self.headPortraitView.mas_right).offset(0);
        make.bottom.equalTo(self.mas_bottom).offset(0);
        make.right.lessThanOrEqualTo(self.mas_right).offset(-26);
    }];
    [self.messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.messageBackgroundView.mas_top).offset(20);
        make.left.equalTo(self.messageBackgroundView.mas_left).offset(25);
        make.bottom.equalTo(self.messageBackgroundView.mas_bottom).offset(-20);
        make.right.equalTo(self.messageBackgroundView.mas_right).offset(-20);
    }];
}

- (void)refreshWithModel:(OCSTextModel *)model {
    self.messageLabel.attributedText = model.content;
}

#pragma mark - getter methods

- (UIImageView *)headPortraitView {
    if (!_headPortraitView) {
        UIImageView *headPortraitView = [[UIImageView alloc] init];
        headPortraitView.image = [UIImage imageNamed:@"customer_service_icon"];
        _headPortraitView = headPortraitView;
    }
    return _headPortraitView;
}

- (UIImageView *)messageBackgroundView {
    if (!_messageBackgroundView) {
        UIImageView *messageBackgroundView = [[UIImageView alloc] init];
        messageBackgroundView.image = [[UIImage imageNamed:@"bubble_white_icon"] resizableImageWithCapInsets:UIEdgeInsetsMake(40, 20, 20, 20) resizingMode:UIImageResizingModeStretch];
        _messageBackgroundView = messageBackgroundView;
    }
    return _messageBackgroundView;
}

- (YYLabel *)messageLabel {
    if (!_messageLabel) {
        YYLabel *messageLabel = [[YYLabel alloc] init];
        messageLabel.numberOfLines = 0;
        // 131为除label外的宽度
        messageLabel.preferredMaxLayoutWidth = [UIScreen mainScreen].bounds.size.width - 131;
        _messageLabel = messageLabel;
    }
    return _messageLabel;
}

@end
