//
//  OCSInputToolBar.h
//  onlineC
//
//  Created by zyd on 2018/7/12.
//

#import <UIKit/UIKit.h>

FOUNDATION_EXPORT CGFloat const OCSInputToolBarHeight;

@interface OCSInputToolBar : UIView

@property (copy, nonatomic) dispatch_block_t moreMediaButtonCallback;
@property (copy, nonatomic) void (^sendButtonCallback)(id model);
@property (copy, nonatomic) dispatch_block_t textViewDidBeginEditing;

@property (copy, nonatomic) dispatch_block_t sizeDidChange;

@end
