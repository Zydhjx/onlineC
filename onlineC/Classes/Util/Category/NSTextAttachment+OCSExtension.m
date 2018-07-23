//
//  NSTextAttachment+OCSExtension.m
//  onlineC
//
//  Created by zyd on 2018/7/23.
//

#import "NSTextAttachment+OCSExtension.h"
#import <objc/runtime.h>

@implementation NSTextAttachment (OCSExtension)

- (void)setImageTag:(NSString *)imageTag {
    SEL selector = @selector(imageTag);
    [self willChangeValueForKey:NSStringFromSelector(selector)];
    objc_setAssociatedObject(self, selector, imageTag, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self didChangeValueForKey:NSStringFromSelector(selector)];
}

- (NSString *)imageTag {
    return objc_getAssociatedObject(self, _cmd);
}

@end
