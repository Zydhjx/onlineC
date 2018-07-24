//
//  NSDictionary+OCSExtension.h
//  onlineC
//
//  Created by zyd on 2018/7/18.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (OCSExtension)

- (NSString *)JSONStringWithOptions:(NSJSONWritingOptions)options encoding:(NSStringEncoding)encoding error:(NSError * __autoreleasing *)error;

@end
