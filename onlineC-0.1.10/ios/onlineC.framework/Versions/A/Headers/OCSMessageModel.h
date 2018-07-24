//
//  OCSMessageModel.h
//  onlineC
//
//  Created by zyd on 2018/7/13.
//

#import "OCSModel.h"

@interface OCSMessageModel : OCSModel

// 文本内容
@property (copy, nonatomic) NSString *content;
// 展示页面时间
@property (copy, nonatomic) NSString *showTime;
// 坐席标识
@property (copy, nonatomic) NSString *empFlag;
// 图片路径
@property (copy, nonatomic) NSString *imgUrl;

@end
