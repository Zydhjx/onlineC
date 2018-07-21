//
//  OCSTiming.m
//  onlineC
//
//  Created by zyd on 2018/7/18.
//

#import "OCSTiming.h"

@interface OCSTiming () {
    NSInteger _counterNum;
    NSInteger _endNum;
    NSInteger _duration;
}

@property (weak, nonatomic) NSTimer *timer;
@property (weak, nonatomic) id<OCSTimingDelegate> delegate;

@end

@implementation OCSTiming

- (void)dealloc {
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (instancetype)initWithDelegate:(id<OCSTimingDelegate>)delegate duration:(NSInteger)duration {
    self = [super init];
    if (!self) { return nil; }
    
    _delegate = delegate;
    _duration = duration;
    
    return self;
}

- (void)setDuration:(NSInteger)duration {
    _duration = duration;
}

- (void)startTiming {
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    
    _counterNum = 0;
    _endNum = _duration;
    _isTiming = YES;
    
    NSTimer *timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(handleTimerEvent:) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    [timer fire];
    self.timer = timer;
}

- (void)cancelTiming {
    if (self.delegate &&
        [self.delegate respondsToSelector:@selector(timing:didCancelTimingWithNum:)]) {
        [self.delegate timing:self didCancelTimingWithNum:_counterNum];
    }
    
    [self destroy];
}

- (void)destroy {
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    
    _isTiming = NO;
    self.referenceObject = nil;
}

#pragma mark - timer event

- (void)handleTimerEvent:(NSTimer *)timer {
    _counterNum++;
    
    if (_counterNum == 1) {
        if (self.delegate &&
            [self.delegate respondsToSelector:@selector(timing:didStartTimingWithNum:)]) {
            [self.delegate timing:self didStartTimingWithNum:_counterNum];
        }
    } else if (_counterNum == _endNum) {
        if (self.delegate &&
            [self.delegate respondsToSelector:@selector(timing:didFinishWithNum:)]) {
            [self.delegate timing:self didFinishWithNum:_counterNum];
        }
        
        [self destroy];
    } else {
        if (self.delegate &&
            [self.delegate respondsToSelector:@selector(timing:beingTimingWithNum:)]) {
            [self.delegate timing:self beingTimingWithNum:_counterNum];
        }
    }
}

@end
