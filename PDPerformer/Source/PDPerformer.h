//
//  PDPerformer.h
//  PDPerformer
//
//  Created by liang on 2019/3/5.
//  Copyright © 2019 PipeDog. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PDPerformer : NSObject

// The implementation method can only execute a limited number of times in a specified period of time.
+ (void)perform:(dispatch_block_t)block forKey:(NSString *)key limits:(NSUInteger)limits inSeconds:(NSTimeInterval)secs;

// The implementation method executes only the last time in a specified amount of time.
+ (void)performTailHandler:(dispatch_block_t)block forKey:(NSString *)key inSeconds:(NSTimeInterval)secs;

@end

NS_ASSUME_NONNULL_END
