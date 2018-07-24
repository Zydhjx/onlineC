//
//  OCSPictureWordCell.m
//  onlineC
//
//  Created by zyd on 2018/7/16.
//

#import "OCSPictureWordCell.h"
#import "OCSPictureWordModel.h"

#import "UIColor+OCSExtension.h"
#import "UITableViewCell+OCSExtension.h"
#import "UITableView+OCSExtension.h"

#import <Masonry.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import <YYLabel.h>

@interface OCSPictureWordCell ()

@property (strong, nonatomic) UIImageView *headPortraitView;
@property (strong, nonatomic) UIImageView *messageBackgroundView;
@property (strong, nonatomic) UIView *messageView;
@property (strong, nonatomic) NSMutableArray *contentLabels;
@property (strong, nonatomic) NSMutableArray *imageViews;

@end

@implementation OCSPictureWordCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (!self) { return nil; }
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.contentLabels = [[NSMutableArray alloc] init];
    self.imageViews = [[NSMutableArray alloc] init];
    [self addSubviews];
    [self layout];
    
    return self;
}

- (void)addSubviews {
    [self addSubview:self.headPortraitView];
    [self addSubview:self.messageBackgroundView];
    [self.messageBackgroundView addSubview:self.messageView];
}

- (void)layout {
    [self.headPortraitView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(15);
        make.left.equalTo(self.mas_left).offset(15);
        make.size.mas_equalTo(CGSizeMake(45, 45));
    }];
    [self.messageBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(5);
        make.left.equalTo(self.headPortraitView.mas_right).offset(0);
        make.bottom.equalTo(self.mas_bottom).offset(0);
        make.right.lessThanOrEqualTo(self.mas_right).offset(-26);
    }];
    [self.messageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.messageBackgroundView.mas_top).offset(15);
        make.left.equalTo(self.messageBackgroundView.mas_left).offset(20);
        make.bottom.equalTo(self.messageBackgroundView.mas_bottom).offset(-15);
        make.right.equalTo(self.messageBackgroundView.mas_right).offset(-15);
    }];
}

- (void)refreshWithModel:(OCSPictureWordModel *)model {
    NSArray *contents = model.contents;
    NSArray *imgUrls = model.imgUrls;
    
    // 需要优化
    UIView *lastView = self.messageView;
    for (NSInteger i = 0; i < model.contents.count; i++) {
        YYLabel *textLabel = [[YYLabel alloc] init];
        textLabel.numberOfLines = 0;
        // 131为除label外的宽度
        textLabel.preferredMaxLayoutWidth = [UIScreen mainScreen].bounds.size.width - 131;
        textLabel.font = [UIFont systemFontOfSize:14.0f];
        textLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        textLabel.attributedText = contents[i];
        [self.messageView addSubview:textLabel];
        [textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            if (i == 0) {
                make.top.equalTo(lastView.mas_top);
            } else {
                make.top.equalTo(lastView.mas_bottom);
            }

            make.left.right.equalTo(self.messageView);
        }];
        lastView = textLabel;

        UIImageView *imageView = [[UIImageView alloc] init];
        __weak __typeof(self) weakSelf = self;
        [imageView sd_setImageWithURL:[NSURL URLWithString:imgUrls[i]] placeholderImage:nil completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            __strong __typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf.tableView scrollToBottomDelay:YES animated:YES];
        }];
        [self.messageView addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(lastView.mas_bottom);
            make.left.right.equalTo(self.messageView);
        }];
        lastView = imageView;
    }

    if (![lastView isEqual:self]) {
        [lastView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.messageView);
        }];
    }
}

#pragma mark - getter methods

- (UIImageView *)headPortraitView {
    if (!_headPortraitView) {
        UIImageView *headPortraitView = [[UIImageView alloc] init];
        headPortraitView.image = [UIImage imageNamed:@"customer_service_icon"];
        _headPortraitView = headPortraitView;
    }
    return _headPortraitView;
}

- (UIImageView *)messageBackgroundView {
    if (!_messageBackgroundView) {
        UIImageView *messageBackgroundView = [[UIImageView alloc] init];
        messageBackgroundView.image = [[UIImage imageNamed:@"bubble_white_icon"] resizableImageWithCapInsets:UIEdgeInsetsMake(40, 20, 20, 20) resizingMode:UIImageResizingModeStretch];
        _messageBackgroundView = messageBackgroundView;
    }
    return _messageBackgroundView;
}

- (UIView *)messageView {
    if (!_messageView) {
        UIView *messageView = [[UIView alloc] init];
        _messageView = messageView;
    }
    return _messageView;
}

@end
