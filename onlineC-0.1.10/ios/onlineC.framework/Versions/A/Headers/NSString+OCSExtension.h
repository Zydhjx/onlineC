//
//  NSString+OCSExtension.h
//  onlineC
//
//  Created by zyd on 2018/7/18.
//

#import <Foundation/Foundation.h>

@interface NSString (OCSExtension)

- (id)JSONObjectWithOptions:(NSJSONReadingOptions)options encoding:(NSStringEncoding)encoding error:(NSError * __autoreleasing *)error;

@end
