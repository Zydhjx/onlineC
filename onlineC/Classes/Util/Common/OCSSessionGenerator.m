//
//  OCSSessionGenerator.m
//  onlineC
//
//  Created by zyd on 2018/7/23.
//

#import "OCSSessionGenerator.h"
#import "OCSSessionViewController.h"

@implementation OCSSessionGenerator

+ (UIViewController *)sessionWithParameters:(NSDictionary *)parameters {
    return [[OCSSessionViewController alloc] initWithParameters:parameters];
}

@end
