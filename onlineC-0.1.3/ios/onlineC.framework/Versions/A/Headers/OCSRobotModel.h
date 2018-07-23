//
//  OCSRobotModel.h
//  onlineC
//
//  Created by zyd on 2018/7/13.
//

#import "OCSModel.h"

@interface OCSRobotModel : OCSModel

// 答案类型
@property (copy, nonatomic) NSString *contentType;

// 用于关联类和contentType的方法
+ (void)setValue:(id)value forKey:(NSString *)key;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;
+ (instancetype)modelWithDictionary:(NSDictionary *)dictionary;

@end
