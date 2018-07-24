//
//  OCSPictureCell.m
//  onlineC
//
//  Created by zyd on 2018/7/16.
//

#import "OCSPictureCell.h"
#import "OCSPictureModel.h"

#import "UITableViewCell+OCSExtension.h"
#import "UITableView+OCSExtension.h"

#import <Masonry.h>
#import <SDWebImage/UIImageView+WebCache.h>

@interface OCSPictureCell ()

@property (strong, nonatomic) UIImageView *headPortraitView;
@property (strong, nonatomic) UIImageView *messageBackgroundView;
@property (strong, nonatomic) UIImageView *messageImageView;

@end

@implementation OCSPictureCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (!self) { return nil; }
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self addSubviews];
    [self layout];
    
    return self;
}

- (void)addSubviews {
    [self addSubview:self.headPortraitView];
    [self addSubview:self.messageBackgroundView];
    [self.messageBackgroundView addSubview:self.messageImageView];
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
    [self.messageImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.messageBackgroundView.mas_top).offset(15);
        make.left.equalTo(self.messageBackgroundView.mas_left).offset(20);
        make.bottom.equalTo(self.messageBackgroundView.mas_bottom).offset(-15);
        make.right.equalTo(self.messageBackgroundView.mas_right).offset(-15);
    }];
}

- (void)refreshWithModel:(OCSPictureModel *)model {
    __weak __typeof(self) weakSelf = self;
    NSURL *imageURL = [NSURL URLWithString:model.imgUrl];
    static BOOL flag = NO;
    [self.messageImageView sd_setImageWithURL:imageURL placeholderImage:nil completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        NSLog(@"%lf----%lf", image.size.width, image.size.height);
        
        if (strongSelf && !flag) {
            flag = YES;
            [strongSelf.tableView reloadData];
//            strongSelf.messageImageView.image = image;
        }
//        [strongSelf.tableView scrollToBottom:YES];
    }];
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

- (UIImageView *)messageImageView {
    if (!_messageImageView) {
        UIImageView *messageImageView = [[UIImageView alloc] init];
        _messageImageView = messageImageView;
    }
    return _messageImageView;
}

@end
