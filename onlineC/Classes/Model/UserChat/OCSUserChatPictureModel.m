//
//  OCSUserChatPictureModel.m
//  onlineC
//
//  Created by zyd on 2018/7/21.
//

#import "OCSUserChatPictureModel.h"
#import "OCSUserChatPictureCell.h"

@implementation OCSUserChatPictureModel

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (!self) { return nil; }
    
    [self setValuesForKeysWithDictionary:dictionary];
    
    return self;
}

+ (instancetype)modelWithDictionary:(NSDictionary *)dictionary {
    id model = [[self alloc] initWithDictionary:dictionary];
    return model;
}

#pragma mark - 未定义的属性

- (id)valueForUndefinedKey:(NSString *)key {
    return nil;
}

#pragma mark - 设置未定义的属性的值(用于数据字段和系统字段冲突的情况)

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

#pragma mark - cellIdentifier

- (NSString *)cellIdentifier {
    return NSStringFromClass(OCSUserChatPictureCell.class);
}

@end
