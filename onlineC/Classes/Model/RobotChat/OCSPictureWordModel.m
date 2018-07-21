//
//  OCSPictureWordModel.m
//  onlineC
//
//  Created by zyd on 2018/7/16.
//

#import "OCSPictureWordModel.h"
#import "OCSPictureWordCell.h"
#import "OCSLinksHandler.h"

@implementation OCSPictureWordModel

+ (void)load {
    [self setValue:self forKey:@"08"];
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
    
    NSString *separator = @"&-&";
    NSString *content = [mutableDictionary valueForKey:NSStringFromSelector(@selector(content))];
    NSArray *contents = [content componentsSeparatedByString:separator];
    NSMutableArray *mutableContents = [[NSMutableArray alloc] init];
    [contents enumerateObjectsUsingBlock:^(NSString * _Nonnull string, NSUInteger index, BOOL * _Nonnull stop) {
        NSAttributedString *attributedString = [OCSLinksHandler attributedStringWithLinkString:string];
        [mutableContents addObject:attributedString];
    }];
    [mutableDictionary setObject:[mutableContents copy] forKey:NSStringFromSelector(@selector(contents))];
    
    NSString *imgUrl = [mutableDictionary valueForKey:NSStringFromSelector(@selector(imgUrl))];
    NSArray *imgUrls = [imgUrl componentsSeparatedByString:separator];
    [mutableDictionary setObject:imgUrls forKey:NSStringFromSelector(@selector(imgUrls))];
    
    return [mutableDictionary copy];
}

#pragma mark - cellIdentifier

- (NSString *)cellIdentifier {
    return NSStringFromClass(OCSPictureWordCell.class);
}

@end
