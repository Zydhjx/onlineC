//
//  OCSEvaluationTextView.h
//  onlineC
//
//  Created by zyd on 2018/7/15.
//

#import <UIKit/UIKit.h>

@interface OCSEvaluationTextView : UIView

@property (copy, readonly, nonatomic) NSString *appraiseContent;

- (void)setTitle:(NSString *)title;

@end
