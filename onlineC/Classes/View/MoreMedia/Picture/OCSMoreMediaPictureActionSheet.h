//
//  OCSMoreMediaPictureActionSheet.h
//  onlineC
//
//  Created by zyd on 2018/7/18.
//

#import <UIKit/UIKit.h>

@class OCSMoreMediaPictureActionSheet;
@protocol OCSMoreMediaPictureActionSheetDelegate <NSObject>

@optional
- (void)actionSheet:(OCSMoreMediaPictureActionSheet *)actionSheet clickedItemAtIndex:(NSInteger)index;

@end

@interface OCSMoreMediaPictureActionSheet : UIView

+ (void)showWithDelegate:(nullable id<OCSMoreMediaPictureActionSheetDelegate>)delegate;

@end
