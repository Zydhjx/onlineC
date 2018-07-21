//
//  OCSTextModel.m
//  onlineC
//
//  Created by zyd on 2018/7/16.
//

#import "OCSTextModel.h"
#import "OCSTextCell.h"
#import "OCSLinksHandler.h"

@implementation OCSTextModel

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
    NSString *key = @"content";
    NSString *content = [mutableDictionary valueForKey:key];
    NSAttributedString *attributedContent = [OCSLinksHandler attributedStringWithLinkString:content];
    [mutableDictionary setValue:attributedContent forKey:key];
    return [mutableDictionary copy];
}

#pragma mark - cellIdentifier

- (NSString *)cellIdentifier {
    return NSStringFromClass(OCSTextCell.class);
}

@end
