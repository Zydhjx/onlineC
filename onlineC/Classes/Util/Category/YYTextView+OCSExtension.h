//
//  YYTextView+OCSExtension.h
//  onlineC
//
//  Created by zyd on 2018/7/16.
//

#import "YYTextView.h"

@interface YYTextView (OCSExtension)

// 超出允许的最大输入长度返回YES, 不超出则返回NO
- (BOOL)restrictTextLengthWithMaxAllowableInput:(NSUInteger)max;

@end
