//
//  UIImage+OCSExtension.m
//  onlineC
//
//  Created by zyd on 2018/7/12.
//

#import "UIImage+OCSExtension.h"

@implementation UIImage (OCSExtension)

- (UIImage *)imageScaleToSize:(CGSize)size; {
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *scaleImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return scaleImage;
}

@end
