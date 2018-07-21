//
//  UITableView+OCSExtension.m
//  onlineC
//
//  Created by zyd on 2018/7/17.
//

#import "UITableView+OCSExtension.h"

@implementation UITableView (OCSExtension)

- (void)scrollToBottom:(BOOL)animated
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSInteger row = [self numberOfRowsInSection:0] - 1;
        if (row > 0)
        {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
            [self scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:animated];
        }
    });
}

@end
