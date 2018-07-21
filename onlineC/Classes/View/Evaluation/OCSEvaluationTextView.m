//
//  OCSEvaluationTextView.m
//  onlineC
//
//  Created by zyd on 2018/7/15.
//

#import "OCSEvaluationTextView.h"

#import "UIColor+OCSExtension.h"

#import <Masonry.h>
#import <YYText.h>

@interface OCSEvaluationTextView ()

@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) YYTextView *textView;

@end

@implementation OCSEvaluationTextView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (!self) { return nil; }
    
    [self addSubviews];
    [self layout];
    
    return self;
}

- (void)addSubviews {
    [self addSubview:self.titleLabel];
    [self addSubview:self.textView];
}

- (void)layout {
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.height.equalTo(@20);
    }];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(6);
        make.left.right.bottom.equalTo(self);
    }];
}

- (void)setTitle:(NSString *)title {
    self.titleLabel.text = title;
}

#pragma mark - getter methods

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        UILabel *titleLabel = UILabel.new;
        titleLabel.font = [UIFont systemFontOfSize:14.0f];
        titleLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        _titleLabel = titleLabel;
    }
    return _titleLabel;
}

- (YYTextView *)textView {
    if (!_textView) {
        YYTextView *textView = YYTextView.new;
        textView.placeholderText = @"输入评价内容信息。";
        textView.placeholderTextColor = [UIColor colorWithHexString:@"#CCCCCC"];
        textView.placeholderFont = [UIFont systemFontOfSize:14.0f];
        textView.backgroundColor = [UIColor colorWithHexString:@"#F7F7F7"];
        textView.layer.cornerRadius = 2.0f;
        textView.layer.masksToBounds = YES;
        textView.layer.borderWidth = 1.0f;
        textView.layer.borderColor = [UIColor colorWithHexString:@"#E0E0E0"].CGColor;
        _textView = textView;
    }
    return _textView;
}

- (NSString *)appraiseContent {
    return self.textView.text;
}

@end
