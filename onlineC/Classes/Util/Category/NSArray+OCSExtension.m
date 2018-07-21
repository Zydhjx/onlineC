//
//  NSArray+OCSExtension.m
//  onlineC
//
//  Created by zyd on 2018/7/18.
//

#import "NSArray+OCSExtension.h"

@implementation NSArray (OCSExtension)

- (NSString *)JSONStringWithOptions:(NSJSONWritingOptions)options encoding:(NSStringEncoding)encoding error:(NSError * __autoreleasing *)error {
    NSData *data = [NSJSONSerialization dataWithJSONObject:self options:options error:error];
    NSString *jsonString = [[NSString alloc] initWithData:data encoding:encoding];
    return jsonString;
}

@end
