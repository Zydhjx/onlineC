//
//  OCSSessionGenerator.h
//  onlineC
//
//  Created by zyd on 2018/7/23.
//

#import <Foundation/Foundation.h>

@class UIViewController;
@interface OCSSessionGenerator : NSObject

/**
 * @para parameters 需要传入的参数
 * @return 会话控制器实例
 */
+ (UIViewController *)sessionWithParameters:(NSDictionary *)parameters;

@end
