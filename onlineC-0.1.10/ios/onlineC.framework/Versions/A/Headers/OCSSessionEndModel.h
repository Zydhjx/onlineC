//
//  OCSSessionEndModel.h
//  onlineC
//
//  Created by zyd on 2018/7/20.
//

#import "OCSModel.h"

@interface OCSSessionEndModel : OCSModel

@property (copy, nonatomic) NSMutableAttributedString *content;

+ (instancetype)modelWithDictionary:(NSDictionary *)dictionary;

@end
