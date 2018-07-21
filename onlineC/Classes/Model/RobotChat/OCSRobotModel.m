//
//  OCSRobotModel.m
//  onlineC
//
//  Created by zyd on 2018/7/13.
//

#import "OCSRobotModel.h"
#import "OCSLinksModel.h"

@implementation OCSRobotModel
static NSMutableDictionary *_mutableClassKeyedByContentType = nil;

+ (NSMutableDictionary *)mutableClassKeyedByContentType {
    if (_mutableClassKeyedByContentType == nil) {
        _mutableClassKeyedByContentType = [[NSMutableDictionary alloc] init];
    }
    return _mutableClassKeyedByContentType;
}

+ (void)setValue:(id)value forKey:(NSString *)key {
    [self.mutableClassKeyedByContentType setValue:value forKey:key];
}

+ (id)valueForKey:(NSString *)key {
    return [self.mutableClassKeyedByContentType valueForKey:key];
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (!self) { return nil; }
    
    [self setValuesForKeysWithDictionary:dictionary];
    
    return self;
}

+ (instancetype)modelWithDictionary:(NSDictionary *)dictionary {
    NSString *contentType = [dictionary valueForKey:@"contentType"];
    Class aClass = [self valueForKey:contentType];
    
    id model = [[aClass alloc] initWithDictionary:dictionary];
    return model;
}

#pragma mark - 未定义的属性

- (id)valueForUndefinedKey:(NSString *)key {
    return nil;
}

#pragma mark - 设置未定义的属性的值(用于数据字段和系统字段冲突的情况)

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

@end
