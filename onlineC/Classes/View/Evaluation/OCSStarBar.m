//
//  OCSStarBar.m
//  onlineC
//
//  Created by zyd on 2018/7/12.
//

#import "OCSStarBar.h"

#import "UIImage+OCSExtension.h"

#import <Masonry.h>

static NSInteger const kImageViewTag = 10000;
static NSInteger const kMaxStar = 5;

@interface PaddingButton : UIButton

@property (nonatomic,assign)CGFloat exWidth;

@end

@implementation PaddingButton

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    BOOL hit = [super pointInside:point withEvent:event];
    if (hit == NO)
    {
        if (point.x > -_exWidth && point.x - CGRectGetMaxX(self.bounds) <= _exWidth && fabs(point.y - CGRectGetMidY(self.bounds)) <= CGRectGetHeight(self.bounds)/2 + _exWidth)
        {
            return YES;
        }
    }
    return hit;
}

@end


@implementation OCSStarBar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        for (NSInteger i = 0; i < kMaxStar; i++)
        {
            CGFloat imgWidth = 24;
            PaddingButton *button = [PaddingButton new];
            button.exWidth = 8;
            [button setImage:[[UIImage imageNamed:@"star_button_unselected_icon"] imageScaleToSize:CGSizeMake(imgWidth, imgWidth)] forState:UIControlStateNormal];
            [button setImage:[[UIImage imageNamed:@"star_button_selected_icon"] imageScaleToSize:CGSizeMake(imgWidth, imgWidth)] forState:UIControlStateSelected];
            [button setImage:[[UIImage imageNamed:@"star_button_selected_icon"] imageScaleToSize:CGSizeMake(imgWidth, imgWidth)] forState:UIControlStateHighlighted];
            [button setImage:[[UIImage imageNamed:@"star_button_selected_icon"] imageScaleToSize:CGSizeMake(imgWidth, imgWidth)] forState:UIControlStateHighlighted | UIControlStateSelected];
            [button addTarget:self action:@selector(onButtonPress:) forControlEvents:UIControlEventTouchDown];
            button.tag = kImageViewTag + i;
            [self addSubview:button];
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.mas_left).with.offset(8*i + imgWidth*i);
                make.centerY.equalTo(self);
                make.size.mas_equalTo(CGSizeMake(imgWidth, imgWidth));
            }];
        }
    }
    return self;
}

- (void)setForSelect:(BOOL)forSelect
{
    for (NSInteger i = 0; i < kMaxStar; i++)
    {
        UIButton *view = [self viewWithTag:kImageViewTag + i];
        view.userInteractionEnabled = forSelect;
    }
}

- (void)markStar:(NSInteger)star
{
    for (NSInteger i = 0; i < kMaxStar; i++)
    {
        UIButton *view = [self viewWithTag:kImageViewTag + i];
        view.selected = i < star;
    }
}

- (void)onButtonPress:(UIButton *)button
{
    NSInteger star = button.tag - kImageViewTag + 1;
    if (self.onStart) {
        self.onStart(star);
    }
    [self markStar:star];
}

@end
