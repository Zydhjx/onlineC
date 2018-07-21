//
//  OCSLinksModel.m
//  onlineC
//
//  Created by zyd on 2018/7/13.
//

#import "OCSLinksModel.h"
#import "OCSLinksCell.h"
#import "OCSSessionViewController.h"
#import "OCSLinksHandler.h"

#import "UIColor+OCSExtension.h"

#import <ObjectiveGumbo.h>
#import <NSAttributedString+YYText.h>

@implementation OCSLinksModel

+ (void)load {
    [self setValue:self forKey:@"09"];
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    // 在子类中处理dictionary为需要的样式
    dictionary = [self attributedStringDictionaryWithDictionary:dictionary];
    
    self = [super initWithDictionary:dictionary];
    if (!self) { return nil; }
    return self;
}

#pragma mark -- 处理dictionary的方法

- (NSDictionary *)attributedStringDictionaryWithDictionary:(NSDictionary *)dictionary {
    NSMutableDictionary *mutableDictionary = [dictionary mutableCopy];
    NSString *key = @"content";
    NSString *content = [mutableDictionary valueForKey:key];
    OGNode *node = [ObjectiveGumbo parseNodeWithString:content];
    NSArray *elements = [node elementsWithTag:GUMBO_TAG_A];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 10.0f;
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:14],
                                 NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle),
                                 NSParagraphStyleAttributeName: paragraphStyle};
    NSMutableAttributedString *totalString = [[NSMutableAttributedString alloc] initWithString:@""];
    [elements enumerateObjectsUsingBlock:^(OGElement * _Nonnull element, NSUInteger index, BOOL * _Nonnull stop) {
        NSString *title = element.text;
        NSInteger length = title.length;
        NSString *href = [element.attributes valueForKey:@"href"];
        
        if (index < elements.count - 1) {
            title = [title stringByAppendingString:@"\n"];
        }
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:title attributes:attributes];
//        [attributedString addAttribute:NSLinkAttributeName value:href range:NSMakeRange(0, length)];
        [attributedString yy_setTextHighlightRange:NSMakeRange(0, length) color:[UIColor colorWithHexString:@"#0C82F1"] backgroundColor:nil tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
            NSDictionary *dictionary = nil;
            if ([href isEqualToString:@"转人工"]) {
                // 转人工客服
                dictionary = @{@"eventType": @(OCSLinksEventTypeTurnToHumanService),
                               @"actionType": @"03",
                               @"href": href};
            } else {
                // 跳转app中其他页面
                dictionary = @{@"eventType": @(OCSLinksEventTypeAppInner),
                               @"actionType": @"01",
                               @"href": href};
            }
            
            [[NSNotificationCenter defaultCenter] postNotificationName:OCSSessionHandleLinksEventNotification object:dictionary];
        }];
        
        [totalString appendAttributedString:attributedString];
    }];
    [mutableDictionary setValue:[totalString copy] forKey:key];
    
    return [mutableDictionary copy];
}

#pragma mark - cellIdentifier

- (NSString *)cellIdentifier {
    return NSStringFromClass(OCSLinksCell.class);
}

@end
