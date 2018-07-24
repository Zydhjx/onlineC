//
//  OCSInputToolBar.h
//  onlineC
//
//  Created by zyd on 2018/7/12.
//

#import <UIKit/UIKit.h>

FOUNDATION_EXPORT CGFloat const OCSInputToolBarHeight;

@interface OCSInputToolBar : UIView

// 文本
@property (copy, nonatomic) NSAttributedString *attributedText;
@property (assign, nonatomic) NSUInteger location;
// 字体类型
@property (strong, readonly, nonatomic) UIFont *font;
// 字体颜色
@property (strong, readonly, nonatomic) UIColor *textColor;

@property (copy, nonatomic) dispatch_block_t moreMediaButtonCallback;
@property (copy, nonatomic) void (^sendButtonCallback)(id model);
@property (copy, nonatomic) dispatch_block_t textViewDidBeginEditing;

@property (copy, nonatomic) dispatch_block_t sizeDidChange;

@end
