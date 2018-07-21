//
//  OCSModelGenerator.m
//  onlineC
//
//  Created by zyd on 2018/7/19.
//

#import "OCSModelGenerator.h"
#import "OCSTextModel.h"

@implementation OCSModelGenerator

+ (NSArray *)modelsWithResponseObject:(id)responseObject {
    if (responseObject) {
        return nil;
    }
    
    
    return nil;
}

+ (NSArray *)enqueueHumanServiceWithResponseObject:(id)responseObject {
    NSString *returnFlag = [responseObject valueForKey:@"returnFlag"];
    if ([returnFlag isEqualToString:@"03"]) {
        OCSTextModel *model = [OCSTextModel modelWithDictionary:@{@"contentType": @"01", @"content": @""}];
        model.content = [[NSAttributedString alloc] initWithString:@"您好！欢迎您访问国家电网客服中心！正在排队，请等候......"];
        return @[model];
    }
    
    return nil;
}

@end
