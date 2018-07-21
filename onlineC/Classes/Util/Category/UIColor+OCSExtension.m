//
//  UIColor+OCSExtension.m
//  onlineC
//
//  Created by zyd on 2018/7/12.
//

#import "UIColor+OCSExtension.h"

@implementation UIColor (OCSExtension)

#pragma mark - 十六进制颜色

+ (UIColor *)colorWithHexString:(NSString *)string {
    return [self colorWithHexString:string alpha:1.0f];
}

+ (UIColor *)colorWithHexString:(NSString *)string alpha:(CGFloat)alpha {
    string = [string stringByReplacingOccurrencesOfString:@"#" withString:@""];
    NSScanner *scanner = [[NSScanner alloc] initWithString:string];
    UInt32 hex;
    if (![scanner scanHexInt:&hex]) { return nil; }
    return [self colorWithRGBHex:hex alpha:alpha];
}

+ (UIColor *)colorWithRGBHex:(UInt32)hex alpha:(CGFloat)alpha {
    int r = (hex >> 16) & 0xFF;
    int g = (hex >> 8) & 0xFF;
    int b = (hex) & 0xFF;
    
    return [UIColor colorWithRed:r/255.0f
                           green:g/255.0f
                            blue:b/255.0f
                           alpha:alpha];
}

@end
