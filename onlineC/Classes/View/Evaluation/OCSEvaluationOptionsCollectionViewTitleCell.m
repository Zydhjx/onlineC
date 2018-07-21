//
//  OCSEvaluationOptionsCollectionViewTitleCell.m
//  onlineC
//
//  Created by zyd on 2018/7/15.
//

#import "OCSEvaluationOptionsCollectionViewTitleCell.h"
#import "OCSEvaluationTitleModel.h"

#import "UIColor+OCSExtension.h"

#import <Masonry.h>

@interface OCSEvaluationOptionsCollectionViewTitleCell ()

@property (strong, nonatomic) UILabel *textLabel;

@end

@implementation OCSEvaluationOptionsCollectionViewTitleCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (!self) { return nil; }
    
    [self addSubviews];
    [self layout];
    
    return self;
}

- (void)addSubviews {
    [self addSubview:self.textLabel];
}

- (void)layout {
    [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

- (void)refreshWithModel:(OCSEvaluationTitleModel *)model {
    self.textLabel.text = model.text;
}

#pragma mark - getter methods

- (UILabel *)textLabel {
    if (!_textLabel) {
        UILabel *textLabel = [[UILabel alloc] init];
        textLabel.font = [UIFont systemFontOfSize:14.0f];
        textLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        _textLabel = textLabel;
    }
    return _textLabel;
}

@end
