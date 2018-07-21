//
//  NSString+OCSExtension.m
//  onlineC
//
//  Created by zyd on 2018/7/18.
//

#import "NSString+OCSExtension.h"

@implementation NSString (OCSExtension)

- (id)JSONObjectWithOptions:(NSJSONReadingOptions)options encoding:(NSStringEncoding)encoding error:(NSError * __autoreleasing *)error {
    NSData *data = [self dataUsingEncoding:encoding];
    id jsonObject = [NSJSONSerialization JSONObjectWithData:data options:options error:error];
    return jsonObject;
}

@end
