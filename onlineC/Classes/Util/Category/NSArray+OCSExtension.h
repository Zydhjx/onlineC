//
//  NSArray+OCSExtension.h
//  onlineC
//
//  Created by zyd on 2018/7/18.
//

#import <Foundation/Foundation.h>

@interface NSArray (OCSExtension)

- (NSString *)JSONStringWithOptions:(NSJSONWritingOptions)options encoding:(NSStringEncoding)encoding error:(NSError * __autoreleasing *)error;

@end
