//
//  PDPerformer.m
//  PDPerformer
//
//  Created by liang on 2019/3/5.
//  Copyright © 2019 PipeDog. All rights reserved.
//

#import "PDPerformer.h"
#import <QuartzCore/QuartzCore.h>

#define Lock() dispatch_semaphore_wait(self.lock, DISPATCH_TIME_FOREVER)
#define Unlock() dispatch_semaphore_signal(self.lock)

@interface PDPerformer ()

@property (class, strong, readonly) NSMutableDictionary<NSString *, NSMutableDictionary *> *handlers;
@property (class, strong, readonly) dispatch_semaphore_t lock;

@end

@implementation PDPerformer


+ (void)perform:(dispatch_block_t)block forKey:(NSString *)key limits:(NSUInteger)limits inSeconds:(NSTimeInterval)secs {
    NSAssert(key != nil, @"Param key cannot be nil");
    
    if (limits == 0 || secs == 0) {
        !block ?: block(); return;
    }
    
    Lock();
    NSMutableDictionary *dict = self.handlers[key];
    if (!dict) {
        dict = [NSMutableDictionary dictionary];
    }
    
    NSInteger invokeTimes = [dict[@"invokeTimes"] integerValue];
    CFTimeInterval lastInvokeTimestamp = [dict[@"invokeTimestamp"] doubleValue];
    CFTimeInterval currentTimestamp = CACurrentMediaTime();
    Unlock();
    
    if (currentTimestamp - lastInvokeTimestamp > secs) {
        // Over time, reset the number of invokes.
        Lock();
        dict[@"invokeTimestamp"] = @(currentTimestamp);
        dict[@"invokeTimes"] = @((invokeTimes = 1));
        self.handlers[key] = dict;
        Unlock();
        
        !block ?: block();
    } else if (currentTimestamp - lastInvokeTimestamp <= secs &&
               invokeTimes < limits) {
        // The time limit was not exceeded, add up the number of invokes.
        Lock();
        // Note: Do not update the invoke timestamp within the specified time.
        //       The invoke time is subject to the first invoke time.
        dict[@"invokeTimes"] = @((invokeTimes += 1));
        self.handlers[key] = dict;
        Unlock();
        
        !block ?: block();
    } else {
        // The time limit was not exceeded, the limit number of invokes has been reached.
        // Do nothing...
    }
}

#pragma mark - Getter Methods
+ (NSMutableDictionary<NSString *,NSMutableDictionary *> *)handlers {
    static NSMutableDictionary *_handlers = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _handlers = [NSMutableDictionary dictionary];
    });
    return _handlers;
}

+ (dispatch_semaphore_t)lock {
    static dispatch_semaphore_t _lock;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _lock = dispatch_semaphore_create(1);
    });
    return _lock;
}

@end
