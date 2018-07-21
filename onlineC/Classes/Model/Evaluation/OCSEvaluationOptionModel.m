//
//  OCSEvaluationOptionModel.m
//  onlineC
//
//  Created by zyd on 2018/7/15.
//

#import "OCSEvaluationOptionModel.h"
#import "OCSEvaluationOptionsCollectionViewOptionCell.h"

@implementation OCSEvaluationOptionModel

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
    return NSStringFromClass(OCSEvaluationOptionsCollectionViewOptionCell.class);
}

@end
