//
//  UIColor+OCSExtension.h
//  onlineC
//
//  Created by zyd on 2018/7/12.
//

#import <UIKit/UIKit.h>

@interface UIColor (OCSExtension)

/**
 * 十六进制颜色字符串转UIColor
 */

+ (UIColor *)colorWithHexString:(NSString *)string;

/**
 * 十六进制颜色字符串转UIColor, 可设置透明度
 */
+ (UIColor *)colorWithHexString:(NSString *)string alpha:(CGFloat)alpha;

@end
