
//
//  OCSLinksCell.m
//  onlineC
//
//  Created by zyd on 2018/7/13.
//

#import "OCSLinksCell.h"
#import "OCSLinksModel.h"

#import "UIView+OCSFrame.h"

#import <Masonry.h>
#import <YYText.h>

@interface OCSLinksCell ()

@property (strong, nonatomic) UIImageView *linksBackgroundView;
@property (strong, nonatomic) YYLabel *linksView;

@end

@implementation OCSLinksCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (!self) { return nil; }
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self addSubviews];
    [self layout];
    
    return self;
}

- (void)addSubviews {
    [self addSubview:self.linksBackgroundView];
    [self.linksBackgroundView addSubview:self.linksView];
}

- (void)layout {
    [self.linksBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(5);
        make.left.equalTo(self.mas_left).offset(60);
        make.bottom.equalTo(self.mas_bottom).offset(5);
        make.right.equalTo(self.mas_right).offset(-26);
    }];
    [self.linksView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.linksBackgroundView.mas_top).offset(20);
        make.left.equalTo(self.linksBackgroundView.mas_left).offset(25);
        make.bottom.equalTo(self.linksBackgroundView.mas_bottom).offset(-20);
        make.right.equalTo(self.linksBackgroundView.mas_right).offset(-20);
    }];
}

- (void)refreshWithModel:(OCSLinksModel *)model {
    self.linksView.preferredMaxLayoutWidth = self.width;
    self.linksView.attributedText = model.content;
}

#pragma mark - getter methods

- (UIImageView *)linksBackgroundView {
    if (!_linksBackgroundView) {
        UIImageView *linksBackgroundView = [[UIImageView alloc] init];
        linksBackgroundView.image = [[UIImage imageNamed:@"bubble_white_icon"] resizableImageWithCapInsets:UIEdgeInsetsMake(40, 20, 20, 20) resizingMode:UIImageResizingModeStretch];
        linksBackgroundView.userInteractionEnabled = YES;
        _linksBackgroundView = linksBackgroundView;
    }
    return _linksBackgroundView;
}

- (YYLabel *)linksView {
    if (!_linksView) {
        YYLabel *linksView = [[YYLabel alloc] init];
        linksView.numberOfLines = 0;
        _linksView = linksView;
    }
    return _linksView;
}

@end
