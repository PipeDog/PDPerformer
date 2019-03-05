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

+ (void)perform:(dispatch_block_t)block forKey:(NSString *)key limits:(NSUInteger)limits inSeconds:(NSTimeInterval)secs;

@end

NS_ASSUME_NONNULL_END
