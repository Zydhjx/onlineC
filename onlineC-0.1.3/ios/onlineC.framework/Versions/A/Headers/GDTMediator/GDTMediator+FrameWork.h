//
//  GDTMediator+GDTMediatorModuleAActions.h
//  GDTMediator
//
//  Created by casa on 16/3/13.
//  Copyright © 2016年 casa. All rights reserved.
//Categories(实际应用中，这是一个单独的repo，所用需要调度其他模块的人，只需要依赖这个repo。这个repo由target-action维护者维护)

//跳转页面  目前想到登录页面  微应用页面

#import "GDTMediator.h"
#import <UIKit/UIKit.h>


@interface GDTMediator (DEBBankCardView)
/**
 跳转电e宝银行卡绑定页面

 @param param "target":"" 当前触点UIResponder,用来获取当前ViewController
 */
- (void)GDTMediator_DEBBankCardViewAction:(NSDictionary *)param;
@end

@interface GDTMediator (DEBPaymentView)

/**
 跳转电e宝支付页面

 @param param "target":"" 当前触点UIResponder,用来获取当前ViewController
 */
- (void)GDTMediator_DEBPaymentViewAction:(NSDictionary *)param;
@end

@interface GDTMediator (GDTPushToMicroApp)
/**
 跳转其他微应用
 
 @param param {"AppId":"微应用标识","AppName":"AppId为空，利用名称去判断，主要用于前期测试，上线不允许传"}
 */
- (void)GDTMediator_GDTPushToMicroAppAction:(NSDictionary *)param;
@end
