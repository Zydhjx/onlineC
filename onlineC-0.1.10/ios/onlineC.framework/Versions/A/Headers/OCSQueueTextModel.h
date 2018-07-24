//
//  OCSQueueTextModel.h
//  onlineC
//
//  Created by zyd on 2018/7/19.
//

#import "OCSModel.h"

@interface OCSQueueTextModel : OCSModel

// 队列唯一标识
@property (copy, nonatomic) NSString *queueId;
// 01.未在工作时间 02.无可用坐席 03.40（排队等待最长时间 s）
@property (copy, nonatomic) NSString *returnFlag;
// 文本
@property (copy, nonatomic) NSAttributedString *content;
// 文本前缀
@property (copy, readonly, nonatomic) NSString *prefix;

+ (instancetype)modelWithDictionary:(NSDictionary *)dictionary;

@end
