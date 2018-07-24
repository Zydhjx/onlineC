//
//  UITableView+OCSExtension.h
//  onlineC
//
//  Created by zyd on 2018/7/17.
//

#import <UIKit/UIKit.h>

@interface UITableView (OCSExtension)

//- (void)scrollToBottom:(BOOL)animated;

- (void)scrollToBottomDelay:(BOOL)isDelay animated:(BOOL)animated;

- (void)scrollToBottom;

@end
