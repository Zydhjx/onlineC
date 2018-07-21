//
//  OCSMessageCell.m
//  onlineC
//
//  Created by zyd on 2018/7/11.
//

#import "OCSMessageCell.h"

@interface OCSMessageCell ()

@property (strong, nonatomic) UIImageView *headPortraitView;
@property (strong, nonatomic) UIView *messageView;
@property (strong, nonatomic) UILabel *messageLabel;

@end

@implementation OCSMessageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (!self) { return nil; }
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self addSubviews];
    
    return self;
}

- (void)addSubviews {
    [self addSubview:self.headPortraitView];
    [self addSubview:self.messageView];
    [self.messageView addSubview:self.messageLabel];
}

- (void)refreshWithModel:(id)model {
//    self.textLabel.text = model;
//    self.messageLabel.text = model;
}

#pragma mark - getter methods

- (UIImageView *)headPortraitView {
    if (!_headPortraitView) {
        UIImage *image = [UIImage imageNamed:@"customer_service_icon"];
        UIImageView *headPortraitView = [[UIImageView alloc] initWithImage:image];
        headPortraitView.frame = CGRectMake(0, 0, 40, 40);
        _headPortraitView = headPortraitView;
    }
    return _headPortraitView;
}

- (UIView *)messageView {
    if (!_messageView) {
        UIView *messageView = [[UIView alloc] init];
        messageView.frame = CGRectMake(50, 0, 300, 60);
        messageView.layer.contents = (__bridge id)[UIImage imageNamed:@"bubble_white_icon"].CGImage;
        messageView.layer.contentsScale = [UIScreen mainScreen].scale;
        _messageView = messageView;
    }
    return _messageView;
}

- (UILabel *)messageLabel {
    if (!_messageLabel) {
        UILabel *messageLabel = [[UILabel alloc] init];
        messageLabel.frame = CGRectMake(0, 0, 300, 60);
        _messageLabel = messageLabel;
    }
    return _messageLabel;
}

@end
