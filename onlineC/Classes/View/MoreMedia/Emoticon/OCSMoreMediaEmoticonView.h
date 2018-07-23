//
//  OCSMoreMediaEmoticonView.h
//  onlineC
//
//  Created by zyd on 2018/7/22.
//

#import <UIKit/UIKit.h>

@class OCSMoreMediaEmoticonView;
@protocol OCSMoreMediaEmoticonViewDelegate <NSObject>

@optional
- (void)moreMediaEmoticonView:(OCSMoreMediaEmoticonView *)emoticonView didSelectModel:(id)model;
- (void)moreMediaEmoticonViewDidCancel;

@end

@interface OCSMoreMediaEmoticonView : UIView

@property (weak, nonatomic) id<OCSMoreMediaEmoticonViewDelegate> delegate;

@end
