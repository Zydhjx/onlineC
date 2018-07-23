//
//  OCSStarBar.h
//  onlineC
//
//  Created by zyd on 2018/7/12.
//

#import <UIKit/UIKit.h>

@interface OCSStarBar : UIView

@property (nonatomic ,copy)void(^onStart)(NSInteger);
- (void)markStar:(NSInteger)star;

@end
