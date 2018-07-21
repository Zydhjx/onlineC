//
//  OCSMoreMediaCollectionViewCell.m
//  onlineC
//
//  Created by zyd on 2018/7/17.
//

#import "OCSMoreMediaCollectionViewCell.h"
#import "OCSMoreMediaModel.h"

#import "UICollectionViewCell+OCSExtension.h"
#import "UIColor+OCSExtension.h"

#import <Masonry.h>

@interface OCSMoreMediaCollectionViewCell ()

@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UILabel *textLabel;

@end

@implementation OCSMoreMediaCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (!self) { return nil; }
    
    [self addSubviews];
    [self layout];
    
    return self;
}

- (void)addSubviews {
    [self addSubview:self.imageView];
    [self addSubview:self.textLabel];
}

- (void)layout {
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
//        make.size.mas_equalTo(CGSizeMake(60, 60));
        make.height.equalTo(self.imageView.mas_width);
    }];
    [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imageView.mas_bottom);
        make.left.bottom.right.equalTo(self);
    }];
}

- (void)refreshWithModel:(OCSMoreMediaModel *)model {
    self.imageView.image = [UIImage imageNamed:model.imageName];
    self.textLabel.text = model.text;
}

#pragma mark - getter methods

- (UIImageView *)imageView {
    if (!_imageView) {
        UIImageView *imageView = [[UIImageView alloc] init];
        _imageView = imageView;
    }
    return _imageView;
}

- (UILabel *)textLabel {
    if (!_textLabel) {
        UILabel *textLabel = [[UILabel alloc] init];
        textLabel.font = [UIFont systemFontOfSize:12.0f];
        textLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        textLabel.textAlignment = NSTextAlignmentCenter;
        _textLabel = textLabel;
    }
    return _textLabel;
}

@end
