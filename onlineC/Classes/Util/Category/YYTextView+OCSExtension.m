//
//  YYTextView+OCSExtension.m
//  onlineC
//
//  Created by zyd on 2018/7/16.
//

#import "YYTextView+OCSExtension.h"

@implementation YYTextView (OCSExtension)

- (BOOL)restrictTextLengthWithMaxAllowableInput:(NSUInteger)max {
    if (self.text.length > max) {
        return self.text = [self.text substringToIndex:max];
    }
//    NSString *language = UIApplication.sharedApplication.textInputMode.primaryLanguage;
//    if ([language isEqualToString:@"zh-Hans"] || [language isEqualToString:@"zh-Hant"]) {
//        if (self.text.length > max) {//!self.markedTextRange &&
//            return self.text = [self.text substringToIndex:max];
//        }
//    } else {
//        if (self.text.length > max) {
//            return self.text = [self.text substringToIndex:max];
//        }
//    }
    
    return NO;
}

@end
