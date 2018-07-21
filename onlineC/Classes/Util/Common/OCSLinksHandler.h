//
//  OCSLinksHandler.h
//  onlineC
//
//  Created by zyd on 2018/7/20.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger,  OCSLinksEventType) {
    OCSLinksEventTypeTurnToHumanService, // 转人工
    OCSLinksEventTypeAppInner, // App内跳转
    OCSLinksEventTypeAssociatedProblem, // XX开头
    OCSLinksEventTypeURL, // 地址
};

@interface OCSLinksHandler : NSObject

+ (NSAttributedString *)attributedStringWithLinkString:(NSString *)linkString;

@end
