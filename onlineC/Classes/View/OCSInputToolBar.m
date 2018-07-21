//
//  OCSInputToolBar.m
//  onlineC
//
//  Created by zyd on 2018/7/12.
//

#import "OCSInputToolBar.h"

#import "UIView+OCSFrame.h"
#import "UIColor+OCSExtension.h"
#import "YYTextView+OCSExtension.h"

#import <Masonry.h>
#import <YYText.h>

CGFloat const OCSInputToolBarHeight = 44.0f;

@interface OCSInputToolBar () <YYTextViewDelegate>

@property (strong, nonatomic) UIButton *moreMediaButton;
@property (strong, nonatomic) UIButton *sendButton;
@property (strong, nonatomic) YYTextView *textView;
@property (strong, nonatomic) UIView *topSeparator;
@property (assign, nonatomic) NSUInteger maxInputLength;

@end

@implementation OCSInputToolBar

- (void)dealloc {
    [self.textView removeObserver:self forKeyPath:@"contentSize"];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (!self) { return nil; }
    
    self.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    
    // 添加子视图
    [self addSubviews];
    [self layout];
    [self addObservers];
    
    return self;
}

- (void)addSubviews {
    [self addSubview:self.moreMediaButton];
    [self addSubview:self.sendButton];
    [self addSubview:self.topSeparator];
    [self addSubview:self.textView];
}

- (void)layout {
    [self.topSeparator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.height.equalTo(@.5f);
    }];
    [self.moreMediaButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(44.0f, 44.0f));
    }];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topSeparator.mas_bottom).offset(6.0f);
        make.left.equalTo(self.moreMediaButton.mas_right);
        make.bottom.equalTo(self.mas_bottom).offset(-6.0f);
        make.right.equalTo(self.sendButton.mas_left);
    }];
    [self.sendButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.right.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(44.0f, 44.0f));
    }];
}

- (void)addObservers {
    [self.textView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
}

#pragma mark - button events

- (void)handleMoreMediaButtonEvent:(UIButton *)button {
    [self.textView endEditing:YES];
    
    if (self.moreMediaButtonCallback) {
        self.moreMediaButtonCallback();
    }
}

- (void)handleSendButtonEvent:(UIButton *)button {
    if (self.sendButtonCallback) {
        self.sendButtonCallback(self.textView.text);
    }
    
    self.textView.text = nil;
}

#pragma mark - YYTextViewDelegate

- (void)textViewDidBeginEditing:(YYTextView *)textView {
    if (self.textViewDidBeginEditing) {
        self.textViewDidBeginEditing();
    }
}

- (void)textViewDidChange:(YYTextView *)textView {
    if ([textView restrictTextLengthWithMaxAllowableInput:self.maxInputLength]) {
        return;
    }
}

#pragma mark - NSKeyValueObserving

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if (![keyPath isEqualToString:@"contentSize"]) {
        return;
    }
    
    CGFloat newHeight = [[change valueForKey:NSKeyValueChangeNewKey] CGSizeValue].height;
    CGFloat oldHeight = [[change valueForKey:NSKeyValueChangeOldKey] CGSizeValue].height;
    NSLog(@"new:%lf, old:%lf", newHeight, oldHeight);
    // 高度不变或初始状态
    if (newHeight == oldHeight || oldHeight == 0) {
        return;
    }
    
    CGFloat height = self.height + newHeight - oldHeight;
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(height));
    }];
    
    self.sizeDidChange ? self.sizeDidChange() : nil;
}

#pragma mark - getter methods

- (UIButton *)moreMediaButton {
    if (!_moreMediaButton) {
        UIButton *moreMediaButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [moreMediaButton setImage:[UIImage imageNamed:@"more_media_button_icon"] forState:UIControlStateNormal];
        [moreMediaButton addTarget:self action:@selector(handleMoreMediaButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
        _moreMediaButton = moreMediaButton;
    }
    return _moreMediaButton;
}

- (UIButton *)sendButton {
    if (!_sendButton) {
        UIButton *sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [sendButton setImage:[UIImage imageNamed:@"send_button_icon"] forState:UIControlStateNormal];
        [sendButton addTarget:self action:@selector(handleSendButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
        _sendButton = sendButton;
    }
    return _sendButton;
}

- (YYTextView *)textView {
    if (!_textView) {
        YYTextView *textView = [[YYTextView alloc] init];
        textView.backgroundColor = [UIColor colorWithHexString:@"#F7F7F7"];
        textView.font = [UIFont systemFontOfSize:14.0f];
        textView.textColor = [UIColor colorWithHexString:@"#333333"];
        textView.layer.cornerRadius = 5.0f;
        textView.layer.masksToBounds = YES;
        textView.layer.borderWidth = 1.0f;
        textView.layer.borderColor = [UIColor colorWithHexString:@"#E0E0E0"].CGColor;
        textView.delegate = self;
        _textView = textView;
    }
    return _textView;
}

- (UIView *)topSeparator {
    if (!_topSeparator) {
        UIView *topSeparator = [[UIView alloc] initWithFrame:CGRectZero];
        topSeparator.backgroundColor = UIColor.lightGrayColor;
        topSeparator.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _topSeparator = topSeparator;
    }
    return _topSeparator;
}

- (NSUInteger)maxInputLength {
    if (_maxInputLength == 0) {
        _maxInputLength = 500;
    }
    return _maxInputLength;
}

@end
