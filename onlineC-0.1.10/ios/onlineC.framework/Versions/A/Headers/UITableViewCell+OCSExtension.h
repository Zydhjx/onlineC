//
//  UITableViewCell+OCSExtension.h
//  onlineC
//
//  Created by zyd on 2018/7/13.
//

#import <UIKit/UIKit.h>

@interface UITableViewCell (OCSExtension)

@property (weak, nonatomic) UITableView *tableView;
//@property (strong, nonatomic) NSIndexPath *indexPath;

// 刷新cell
- (void)refreshWithModel:(id)model;

@end
