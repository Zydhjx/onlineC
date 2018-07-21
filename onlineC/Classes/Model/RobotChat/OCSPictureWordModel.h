//
//  OCSPictureWordModel.h
//  onlineC
//
//  Created by zyd on 2018/7/16.
//

#import "OCSRobotModel.h"

@interface OCSPictureWordModel : OCSRobotModel

// 信息内容
@property (copy, nonatomic) NSAttributedString *content;
// 图片地址
@property (copy, nonatomic) NSString *imgUrl;

// 信息内容分割之后的数组
@property (copy, nonatomic) NSArray *contents;
// 图片地址分割之后的数组
@property (copy, nonatomic) NSArray *imgUrls;

@end
