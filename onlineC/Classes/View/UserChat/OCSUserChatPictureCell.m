//
//  OCSUserChatPictureCell.m
//  onlineC
//
//  Created by zyd on 2018/7/22.
//

#import "OCSUserChatPictureCell.h"
#import "OCSUserChatPictureModel.h"

#import "UIColor+OCSExtension.h"

#import <Masonry.h>

@interface OCSUserChatPictureCell ()

@property (strong, nonatomic) UIImageView *headPortraitView;
@property (strong, nonatomic) UIImageView *messageBackgroundView;
@property (strong, nonatomic) UIImageView *messageImageView;

@end

@implementation OCSUserChatPictureCell

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
    [self.messageBackgroundView addSubview:self.messageImageView];
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
    [self.messageImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.messageBackgroundView.mas_top).offset(15);
        make.left.equalTo(self.messageBackgroundView.mas_left).offset(20);
        make.bottom.equalTo(self.messageBackgroundView.mas_bottom).offset(-15);
        make.right.equalTo(self.messageBackgroundView.mas_right).offset(-15);
    }];
}

- (void)refreshWithModel:(OCSUserChatPictureModel *)model {
    self.messageImageView.image = model.uploadImage;
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

- (UIImageView *)messageImageView {
    if (!_messageImageView) {
        UIImageView *messageImageView = [[UIImageView alloc] init];
        messageImageView.backgroundColor = UIColor.redColor;
        _messageImageView = messageImageView;
    }
    return _messageImageView;
}

@end
