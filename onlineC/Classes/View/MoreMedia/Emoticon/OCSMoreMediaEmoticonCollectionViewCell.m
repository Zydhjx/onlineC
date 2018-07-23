//
//  OCSMoreMediaEmoticonCollectionViewCell.m
//  onlineC
//
//  Created by zyd on 2018/7/22.
//

#import "OCSMoreMediaEmoticonCollectionViewCell.h"

#import "UICollectionViewCell+OCSExtension.h"
#import "UIImage+OCSExtension.h"

#import <Masonry.h>

@interface OCSMoreMediaEmoticonCollectionViewCell ()

@property (strong, nonatomic) UIImageView *imageView;

@end

@implementation OCSMoreMediaEmoticonCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (!self) { return nil; }
    
    [self addSubviews];
    [self layout];
    
    return self;
}

- (void)addSubviews {
    [self addSubview:self.imageView];
}

- (void)layout {
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

- (void)refreshWithModel:(NSString *)model {
    self.imageView.contentMode = [model isEqualToString:@"emoticon_delete"] ? UIViewContentModeCenter : UIViewContentModeScaleAspectFit;
    self.imageView.image = [UIImage imageNamed:model];
}

#pragma mark - getter methods

- (UIImageView *)imageView {
    if (!_imageView) {
        UIImageView *imageView = [[UIImageView alloc] init];
        _imageView = imageView;
    }
    return _imageView;
}

@end
