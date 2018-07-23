//
//  OCSUserChatPictureModel.m
//  onlineC
//
//  Created by zyd on 2018/7/21.
//

#import "OCSUserChatPictureModel.h"
#import "OCSUserChatPictureCell.h"

@implementation OCSUserChatPictureModel

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
    return NSStringFromClass(OCSUserChatPictureCell.class);
}

@end
