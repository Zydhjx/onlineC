//
//  OCSSessionEndCell.m
//  onlineC
//
//  Created by zyd on 2018/7/20.
//

#import "OCSSessionEndCell.h"
#import "OCSSessionEndModel.h"

#import "UIColor+OCSExtension.h"

#import <Masonry.h>

@interface OCSSessionEndCell ()

@property (strong, nonatomic) UILabel *messageLabel;

@end

@implementation OCSSessionEndCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (!self) { return nil; }
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self addSubviews];
    [self layout];
    
    return self;
}

- (void)addSubviews {
    [self addSubview:self.messageLabel];
}

- (void)layout {
    [self.messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(20);
        make.left.right.equalTo(self);
        make.bottom.equalTo(self.mas_bottom).offset(-20);
    }];
}

- (void)refreshWithModel:(OCSSessionEndModel *)model {
    self.messageLabel.attributedText = model.content;
}

#pragma mark - getter methods

- (UILabel *)messageLabel {
    if (!_messageLabel) {
        UILabel *messageLabel = [[UILabel alloc] init];
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = NSTextAlignmentCenter;
        _messageLabel = messageLabel;
    }
    return _messageLabel;
}

@end
