//
//  OCSUserChatTextModel.m
//  onlineC
//
//  Created by zyd on 2018/7/17.
//

#import "OCSUserChatTextModel.h"
#import "OCSUserChatTextCell.h"
#import "OCSLinksHandler.h"

#import "UIColor+OCSExtension.h"

@implementation OCSUserChatTextModel
+ (void)load {
    [self setValue:self forKey:@"01"];
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
    NSString *key = @"sensitiveWordContent";
    NSString *content = [mutableDictionary valueForKey:key];
    NSMutableAttributedString *attributedContent = [[OCSLinksHandler attributedStringWithLinkString:content] mutableCopy];
    [attributedContent addAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14.0f],
                                       NSForegroundColorAttributeName: [UIColor colorWithHexString:@"#FFFFFF"]} range:NSMakeRange(0, attributedContent.length)];
    [mutableDictionary setValue:[attributedContent copy] forKey:key];
    return [mutableDictionary copy];
}

#pragma mark - cellIdentifier

- (NSString *)cellIdentifier {
    return NSStringFromClass(OCSUserChatTextCell.class);
}

@end
