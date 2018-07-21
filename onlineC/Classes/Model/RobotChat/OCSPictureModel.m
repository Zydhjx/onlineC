//
//  OCSPictureModel.m
//  onlineC
//
//  Created by zyd on 2018/7/16.
//

#import "OCSPictureModel.h"
#import "OCSPictureCell.h"

@implementation OCSPictureModel

+ (void)load {
    [self setValue:self forKey:@"02"];
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
    return [mutableDictionary copy];
}

#pragma mark - cellIdentifier

- (NSString *)cellIdentifier {
    return NSStringFromClass(OCSPictureCell.class);
}

@end
