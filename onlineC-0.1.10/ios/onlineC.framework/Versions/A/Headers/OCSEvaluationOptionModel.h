//
//  OCSEvaluationOptionModel.h
//  onlineC
//
//  Created by zyd on 2018/7/15.
//

#import "OCSEvaluationModel.h"

@interface OCSEvaluationOptionModel : OCSEvaluationModel

@property (copy, nonatomic) NSString *notSatisfaction;

+ (instancetype)modelWithDictionary:(NSDictionary *)dictionary;

@end
