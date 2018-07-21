//
//  OCSMoreMediaModel.h
//  onlineC
//
//  Created by zyd on 2018/7/17.
//

#import "OCSModel.h"

@interface OCSMoreMediaModel : OCSModel

@property (copy, nonatomic) NSString *imageName;
@property (copy, nonatomic) NSString *text;

+ (instancetype)modelWithDictionary:(NSDictionary *)dictionary;

@end
