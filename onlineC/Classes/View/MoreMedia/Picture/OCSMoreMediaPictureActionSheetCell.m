//
//  OCSMoreMediaPictureActionSheetCell.m
//  onlineC
//
//  Created by zyd on 2018/7/18.
//

#import "OCSMoreMediaPictureActionSheetCell.h"

#import "UIColor+OCSExtension.h"
#import "UITableViewCell+OCSExtension.h"

#import <Masonry.h>

@interface OCSMoreMediaPictureActionSheetCell ()

@property (strong, nonatomic) UILabel *titleLabel;

@end

@implementation OCSMoreMediaPictureActionSheetCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (!self) { return nil; }
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self addSubview:self.titleLabel];
    [self layout];
    
    return self;
}

- (void)layout {
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

- (void)refreshWithModel:(NSString *)model {
    self.titleLabel.text = model;
}

#pragma mark - getter methods

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.font = [UIFont systemFontOfSize:16.0f];
        titleLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel = titleLabel;
    }
    return _titleLabel;
}

@end
