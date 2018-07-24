//
//  OCSMoreMediaToolView.h
//  onlineC
//
//  Created by zyd on 2018/7/17.
//

#import <UIKit/UIKit.h>

// 工具框类型
typedef NS_ENUM(NSUInteger, OCSMoreMediaToolType) {
    OCSMoreMediaToolTypeRobotService,
    OCSMoreMediaToolTypeHumanService,
};

// 服务类型
typedef NS_ENUM(NSUInteger, OCSMoreMediaToolServiceType) {
    OCSMoreMediaToolServiceTypeNone,
    OCSMoreMediaToolServiceTypeEmoticon,
    OCSMoreMediaToolServiceTypePicture,
    OCSMoreMediaToolServiceTypePosition,
    OCSMoreMediaToolServiceTypeEnd,
    OCSMoreMediaToolServiceTypeTurnToHuman,
};

@protocol OCSMoreMediaToolViewDelegate <NSObject>

@optional
- (void)didSelectServiceType:(OCSMoreMediaToolServiceType)serviceType;

@end

@interface OCSMoreMediaToolView : UIView

// 设置或获取工具框类型
@property (assign, nonatomic) OCSMoreMediaToolType toolType;
@property (weak, nonatomic) id<OCSMoreMediaToolViewDelegate> delegate;
//@property (copy, nonatomic) void (^didSelectServiceType)(OCSMoreMediaToolServiceType serviceType);

// 设置或获取工具框类型
//- (void)setToolType:(OCSMoreMediaToolType)toolType;
//- (OCSMoreMediaToolType)toolType;

@end
