//
//  OCSPromptModel.h
//  onlineC
//
//  Created by zyd on 2018/7/19.
//

#import "OCSModel.h"

@interface OCSPromptModel : OCSModel

@property (copy, nonatomic) NSAttributedString *content;

+ (instancetype)modelWithDictionary:(NSDictionary *)dictionary;

@end
