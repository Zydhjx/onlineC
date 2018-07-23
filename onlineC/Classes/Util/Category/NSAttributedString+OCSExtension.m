//
//  NSAttributedString+OCSExtension.m
//  onlineC
//
//  Created by zyd on 2018/7/23.
//

#import "NSAttributedString+OCSExtension.h"
#import "NSTextAttachment+OCSExtension.h"

@implementation NSAttributedString (OCSExtension)

- (NSString *)plainString {
    //最终纯文本
    NSMutableString *plainString = [NSMutableString stringWithString:self.string];
    
    //替换下标的偏移量
    __block NSUInteger base = 0;
    
    //遍历
    [self enumerateAttribute:NSAttachmentAttributeName inRange:NSMakeRange(0, self.length)
                     options:0
                  usingBlock:^(id value, NSRange range, BOOL *stop) {
                      //检查类型是否是自定义NSTextAttachment类
                      if (value && [value isKindOfClass:[NSTextAttachment class]]) {
                          //替换
                          [plainString replaceCharactersInRange:NSMakeRange(range.location + base, range.length)
                                                     withString:((NSTextAttachment *) value).imageTag];
                          //增加偏移量
                          base += ((NSTextAttachment *) value).imageTag.length - 1;
                      }
                  }];
    
    return plainString;
}

@end
