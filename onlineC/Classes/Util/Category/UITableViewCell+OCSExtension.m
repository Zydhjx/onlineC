//
//  UITableViewCell+OCSExtension.m
//  onlineC
//
//  Created by zyd on 2018/7/13.
//

#import "UITableViewCell+OCSExtension.h"
#import <objc/runtime.h>

@implementation UITableViewCell (OCSExtension)

- (void)setTableView:(UITableView *)tableView {
    SEL selector = @selector(tableView);
    [self willChangeValueForKey:NSStringFromSelector(selector)];
    objc_setAssociatedObject(self, selector, tableView, OBJC_ASSOCIATION_ASSIGN);
    [self didChangeValueForKey:NSStringFromSelector(selector)];
}

- (UITableView *)tableView {
    return objc_getAssociatedObject(self, _cmd);
}

//- (void)setIndexPath:(NSIndexPath *)indexPath {
//    SEL selector = @selector(indexPath);
//    [self willChangeValueForKey:NSStringFromSelector(selector)];
//    objc_setAssociatedObject(self, selector, indexPath, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//    [self didChangeValueForKey:NSStringFromSelector(selector)];
//}
//
//- (NSIndexPath *)indexPath {
//    return objc_getAssociatedObject(self, _cmd);
//}

- (void)refreshWithModel:(id)model {
}

@end
