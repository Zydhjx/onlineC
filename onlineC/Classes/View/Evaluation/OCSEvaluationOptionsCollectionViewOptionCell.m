//
//  OCSEvaluationOptionsCollectionViewOptionCell.m
//  onlineC
//
//  Created by zyd on 2018/7/15.
//

#import "OCSEvaluationOptionsCollectionViewOptionCell.h"
#import "OCSEvaluationOptionModel.h"

#import "UICollectionViewCell+OCSExtension.h"
#import "UIColor+OCSExtension.h"

#import <Masonry.h>

@interface OCSEvaluationOptionsCollectionViewOptionCell ()

@property (strong, nonatomic) UILabel *textLabel;

@end

@implementation OCSEvaluationOptionsCollectionViewOptionCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (!self) { return nil; }
    
    [self setupSelf];
    [self addSubviews];
    [self layout];
    
    return self;
}

- (void)setupSelf {
    UIImage *unselectedImage = [[UIImage imageNamed:@"option_button_unselected_icon"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 20, 0, 20) resizingMode:UIImageResizingModeStretch];
    UIImage *selectedImage = [[UIImage imageNamed:@"option_button_selected_icon"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 20, 0, 20) resizingMode:UIImageResizingModeStretch];
    self.backgroundView = [[UIImageView alloc] initWithImage:unselectedImage];
    self.selectedBackgroundView = [[UIImageView alloc] initWithImage:selectedImage];
}

- (void)addSubviews {
    [self addSubview:self.textLabel];
}

- (void)layout {
    [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self);
        make.left.equalTo(self.mas_left).offset(5);
        make.right.equalTo(self.mas_right).offset(-5);
    }];
}

- (void)refreshWithModel:(OCSEvaluationOptionModel *)model {
    self.textLabel.text = model.text;
}

#pragma mark - getter methods

- (UILabel *)textLabel {
    if (!_textLabel) {
        UILabel *textLabel = [[UILabel alloc] init];
        textLabel.font = [UIFont systemFontOfSize:14.0f];
        textLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        textLabel.textAlignment = NSTextAlignmentCenter;
        _textLabel = textLabel;
    }
    return _textLabel;
}

@end
