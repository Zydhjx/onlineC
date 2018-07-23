//
//  OCSLinksHandler.m
//  onlineC
//
//  Created by zyd on 2018/7/20.
//

#import "OCSLinksHandler.h"
#import "UIColor+OCSExtension.h"
#import "OCSSessionViewController.h"

#import <ObjectiveGumbo.h>
#import <NSAttributedString+YYText.h>

@implementation OCSLinksHandler

+ (NSAttributedString *)attributedStringWithLinkString:(NSString *)linkString {
    NSMutableAttributedString *totalAttributedString = [[NSMutableAttributedString alloc] initWithString:@""];
    
    OGNode *rootNode = [ObjectiveGumbo parseNodeWithString:linkString];
    OGElement *rootElement = [[rootNode elementsWithTag:GUMBO_TAG_BODY] lastObject];
    [rootElement.children enumerateObjectsUsingBlock:^(OGNode * _Nonnull node, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([node isKindOfClass:OGElement.class]) {
            OGElement *element = (OGElement *)node;
            // 不是a标签则直接进入下一个循环
            if (element.tag != GUMBO_TAG_A) {
                return;
            }
            
            // 字符串长度为0时也直接进入下一个循环
            if (element.text.length == 0) {
                return;
            }
            
            NSRange textRange = NSMakeRange(0, element.text.length);
            NSMutableAttributedString *mutableAttributedString = [[NSMutableAttributedString alloc] initWithString:element.text];
            NSString *hrefValue = [element.attributes valueForKey:@"href"];
            
            [mutableAttributedString addAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14.0f],
                                                     NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)} range:textRange];
            [mutableAttributedString yy_setTextHighlightRange:textRange color:[UIColor colorWithHexString:@"#0C82F1"] backgroundColor:nil tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
                [self handleTapActionEventWithHrefValue:hrefValue];
            }];
            
            [totalAttributedString appendAttributedString:mutableAttributedString];
        } if ([node isKindOfClass:OGText.class] && node.text > 0) {
            NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:14.0f],
                                         NSForegroundColorAttributeName: [UIColor colorWithHexString:@"#333333"]};
            
            // 处理表情
            NSMutableAttributedString *attributedString = [[self imageAttributedStringWithText:node.text] mutableCopy];
            [attributedString addAttributes:attributes range:NSMakeRange(0, attributedString.length)];
            
            [totalAttributedString appendAttributedString:attributedString];
        }
    }];
    
    return [totalAttributedString copy];
}

+ (void)handleTapActionEventWithHrefValue:(NSString *)hrefValue {
    NSDictionary *dictionary = nil;
    if ([hrefValue isEqualToString:@"转人工"]) {
        // 转人工
        dictionary = @{@"eventType": @(OCSLinksEventTypeTurnToHumanService),
                       @"actionType": @"03",
                       @"href": hrefValue};
    } else if ([hrefValue hasPrefix:@"XX"]) {
        // 关联问题
        dictionary = @{@"eventType": @(OCSLinksEventTypeAssociatedProblem),
                       @"actionType": @"02",
                       @"href": hrefValue};
    } else if ([hrefValue hasPrefix:@"WY"]) {
        // 网页
        dictionary = @{@"eventType": @(OCSLinksEventTypeURL),
                       @"actionType": @"02",
                       @"href": hrefValue};
    } else if ([hrefValue isEqualToString:@"离开"]) {
        // 离开
        dictionary = @{@"eventType": @(OCSLinksEventTypeLeave),
                       @"actionType": @"03",
                       @"href": hrefValue};
    } else {
        // 跳转app中其他页面的情况
        dictionary = @{@"eventType": @(OCSLinksEventTypeAppInner),
                       @"actionType": @"01",
                       @"href": hrefValue};
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:OCSSessionHandleLinksEventNotification object:dictionary];
}

+ (NSAttributedString *)imageAttributedStringWithText:(NSString *)text {
    NSString *pattern = @"\\[:bq[1-9][0-9]{0,1}\\]";
    NSError *error = nil;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text];
    NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&error];
    [regex enumerateMatchesInString:text options:NSMatchingReportProgress range:NSMakeRange(0, text.length) usingBlock:^(NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
        NSString *string = [text substringWithRange:result.range];
        if (string.length) {
            NSRange newRange = [attributedString.string rangeOfString:string];
            if ([string hasPrefix:@"[:"]) {
                string = [string substringFromIndex:@"[:".length];
            }
            if ([string hasSuffix:@"]"]) {
                string = [string substringToIndex:string.length - 1];
            }
            string = [@"emoticon_" stringByAppendingString:string];
            NSTextAttachment *textAttachment = [[NSTextAttachment alloc] initWithData:nil ofType:nil];
            textAttachment.image = [UIImage imageNamed:string];
            NSAttributedString *imageAttributedString = [NSAttributedString attributedStringWithAttachment:textAttachment];
            if (imageAttributedString) {
                [attributedString replaceCharactersInRange:newRange withAttributedString:imageAttributedString];
            }
        }
    }];
    return [attributedString copy];
}

@end
