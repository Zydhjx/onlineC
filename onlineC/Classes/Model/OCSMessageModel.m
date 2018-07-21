//
//  OCSMessageModel.m
//  onlineC
//
//  Created by zyd on 2018/7/13.
//

#import "OCSMessageModel.h"
#import "OCSMessageCell.h"

@implementation OCSMessageModel

#pragma mark - cellIdentifier

- (NSString *)cellIdentifier {
    return NSStringFromClass(OCSMessageCell.class);
}

@end
