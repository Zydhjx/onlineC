//
//  OCSUserChatModel.h
//  onlineC
//
//  Created by zyd on 2018/7/16.
//

#import "OCSModel.h"

@interface OCSUserChatModel : OCSModel

@property (copy, nonatomic) NSString *chatDetailId;

// 用户输入类型
@property (copy, nonatomic) NSString *contentType;

// 用于关联类和contentType的方法
+ (void)setValue:(id)value forKey:(NSString *)key;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;
+ (instancetype)modelWithDictionary:(NSDictionary *)dictionary;

@end
