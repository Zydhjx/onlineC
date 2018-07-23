//
//  GDTMediator.h
//  GDTMediator
//
//  Created by 邵侃 on 2018/7/16.
//  Copyright © 2018年 邵侃. All rights reserved.
//

#import <UIKit/UIKit.h>

//! Project version number for GDTMediator.
FOUNDATION_EXPORT double GDTMediatorVersionNumber;

//! Project version string for GDTMediator.
FOUNDATION_EXPORT const unsigned char GDTMediatorVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <GDTMediator/PublicHeader.h>


@interface GDTMediator : NSObject

+ (instancetype)sharedInstance;

// 远程App调用入口
- (id)performActionWithUrl:(NSURL *)url completion:(void(^)(NSDictionary *info))completion;
// 本地组件调用入口
- (id)performTarget:(NSString *)targetName action:(NSString *)actionName params:(NSDictionary *)params shouldCacheTarget:(BOOL)shouldCacheTarget;
- (void)releaseCachedTargetWithTargetName:(NSString *)targetName;

@end
