//
//  OCSWelcomeCell.m
//  onlineC
//
//  Created by zyd on 2018/7/13.
//

#import "OCSWelcomeCell.h"
#import "OCSWelcomeModel.h"

#import "UIColor+OCSExtension.h"

#import <Masonry.h>

@interface OCSWelcomeCell ()

@property (strong, nonatomic) UIImageView *headPortraitView;
@property (strong, nonatomic) UIImageView *messageBackgroundView;
@property (strong, nonatomic) UILabel *messageLabel;

@end

@implementation OCSWelcomeCell

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

- (void)refreshWithModel:(OCSWelcomeModel *)model {
    self.messageLabel.text = model.resultText;
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

- (UILabel *)messageLabel {
    if (!_messageLabel) {
        UILabel *messageLabel = [[UILabel alloc] init];
        messageLabel.font = [UIFont systemFontOfSize:14.0f];
        messageLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        _messageLabel = messageLabel;
    }
    return _messageLabel;
}

@end
