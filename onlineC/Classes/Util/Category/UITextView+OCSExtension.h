//
//  UITextView+OCSExtension.h
//  onlineC
//
//  Created by zyd on 2018/7/23.
//

#import <UIKit/UIKit.h>

@interface UITextView (OCSExtension)

// 超出允许的最大输入长度返回YES, 不超出则返回NO
- (BOOL)restrictTextLengthWithMaxAllowableInput:(NSUInteger)max;

@end
