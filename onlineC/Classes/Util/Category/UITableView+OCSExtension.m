//
//  UITableView+OCSExtension.m
//  onlineC
//
//  Created by zyd on 2018/7/17.
//

#import "UITableView+OCSExtension.h"

@implementation UITableView (OCSExtension)

//- (void)scrollToBottom:(BOOL)animated
//{
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        NSInteger row = [self numberOfRowsInSection:0] - 1;
//        if (row > 0)
//        {
//            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
//            [self scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:animated];
//        }
//    });
//}

- (void)scrollToBottomDelay:(BOOL)isDelay animated:(BOOL)animated {
    dispatch_block_t block = ^{
        NSInteger row = [self numberOfRowsInSection:0] - 1;
        if (row > 0)
        {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
            [self scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:animated];
        }
    };
    
    isDelay ? dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), block) : block();
}

- (CGFloat)verticalOffsetOnBottom {
    CGFloat viewHeight = self.bounds.size.height;
    CGFloat contentHeight = self.contentSize.height;
    CGFloat topInset = self.contentInset.top;
    CGFloat bottomInset = self.contentInset.bottom;
    CGFloat bottomOffset = floorf(contentHeight - bottomInset - topInset - viewHeight - 64);
    return MAX(bottomOffset, 0);
}

- (void)scrollToBottom:(BOOL)animated {
    CGPoint bottomOffset = CGPointMake(0, [self verticalOffsetOnBottom]);
    [self setContentOffset:bottomOffset animated:animated];
}

- (void)scrollToBottom {
    [self beginUpdates];
    [self scrollToBottom:YES];
    [self endUpdates];
}

@end
