//
//  OCSEvaluationStarView.m
//  onlineC
//
//  Created by zyd on 2018/7/15.
//

#import "OCSEvaluationStarView.h"
#import "OCSStarBar.h"

#import "UIColor+OCSExtension.h"

#import <Masonry.h>

@interface OCSEvaluationStarView ()

@property (strong, nonatomic) UILabel *textLabel;
@property (strong, nonatomic) OCSStarBar *starBar;
@property (copy, nonatomic) NSString *tempSatisfactionType;
@property (copy, nonatomic) NSDictionary *textKeyedBySatisfactionType;

@end

@implementation OCSEvaluationStarView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (!self) { return nil; }
    
    [self addSubviews];
    [self layout];
    
    return self;
}

- (void)addSubviews {
    [self addSubview:self.starBar];
    [self addSubview:self.textLabel];
}

- (void)layout {
    [self.starBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.centerX.equalTo(self);
        make.width.equalTo(@152);
        make.height.equalTo(@24);
    }];
    [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self);
        make.top.equalTo(self.starBar.mas_bottom).offset(6);
    }];
}

- (void)setSatisfactionType:(NSString *)satisfactionType {
    self.tempSatisfactionType = satisfactionType;
    NSInteger index = satisfactionType.integerValue;
    [self.starBar markStar:self.textKeyedBySatisfactionType.count - index];
    self.textLabel.text = [self.textKeyedBySatisfactionType valueForKey:satisfactionType];
}

#pragma mark - getter methods

- (OCSStarBar *)starBar {
    if (!_starBar) {
        __weak __typeof(self) weakSelf = self;
        OCSStarBar *starBar = OCSStarBar.new;
        [starBar setOnStart:^(NSInteger index) {
            __strong __typeof(weakSelf) strongSelf = weakSelf;
            NSString *satisfactionType = [NSString stringWithFormat:@"0%ld", strongSelf.textKeyedBySatisfactionType.count - index];
            NSString *text = [strongSelf.textKeyedBySatisfactionType valueForKey:satisfactionType];
            strongSelf.textLabel.text = text;
            strongSelf.tempSatisfactionType = satisfactionType;
            if (strongSelf.callback) {
                // 不满意或非常不满意才显示
                strongSelf.callback(index > 2, text);
            }
        }];
        _starBar = starBar;
    }
    return _starBar;
}

- (UILabel *)textLabel {
    if (!_textLabel) {
        UILabel *textLabel = UILabel.new;
        textLabel.font = [UIFont systemFontOfSize:12.0f];
        textLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        textLabel.textAlignment = NSTextAlignmentCenter;
        _textLabel = textLabel;
    }
    return _textLabel;
}

- (NSString *)satisfactionType {
    return self.tempSatisfactionType;
}

- (NSString *)tempSatisfactionType {
    if (!_tempSatisfactionType) {
        _tempSatisfactionType = @"06";
    }
    return _tempSatisfactionType;
}

- (NSDictionary *)textKeyedBySatisfactionType {
    if (!_textKeyedBySatisfactionType) {
        _textKeyedBySatisfactionType = @{@"01": @"非常满意",
                                         @"02": @"满意",
                                         @"03": @"一般",
                                         @"04": @"不满意",
                                         @"05": @"非常不满意",
                                         @"06": @"不评价"};
    }
    return _textKeyedBySatisfactionType;
}

@end
