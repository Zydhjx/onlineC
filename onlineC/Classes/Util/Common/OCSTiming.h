//
//  OCSTiming.h
//  onlineC
//
//  Created by zyd on 2018/7/18.
//

#import <Foundation/Foundation.h>

@class OCSTiming;
@protocol OCSTimingDelegate <NSObject>

@optional
- (void)timing:(OCSTiming *)timing didStartTimingWithNum:(NSInteger)num;
- (void)timing:(OCSTiming *)timing beingTimingWithNum:(NSInteger)num;
- (void)timing:(OCSTiming *)timing didCancelTimingWithNum:(NSInteger)num;
- (void)timing:(OCSTiming *)timing didFinishWithNum:(NSInteger)num;

@end

@interface OCSTiming : NSObject

@property (strong, nonatomic) id referenceObject;

@property (assign, readonly, nonatomic) BOOL isTiming;

- (instancetype)initWithDelegate:(id<OCSTimingDelegate>)delegate duration:(NSInteger)duration;
- (void)setDuration:(NSInteger)duration;
- (void)startTiming;
- (void)cancelTiming;
- (void)destroy;

@end
