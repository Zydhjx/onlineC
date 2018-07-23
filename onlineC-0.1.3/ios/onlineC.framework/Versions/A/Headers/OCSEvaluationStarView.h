//
//  OCSEvaluationStarView.h
//  onlineC
//
//  Created by zyd on 2018/7/15.
//

#import <UIKit/UIKit.h>

@interface OCSEvaluationStarView : UIView

@property (strong, nonatomic) void (^callback)(BOOL shouldHide, NSString *result);
@property (copy, nonatomic) NSString *satisfactionType;

@end
