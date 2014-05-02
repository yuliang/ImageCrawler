//
//  SafeQueue.h
//  ImageSearching
//
//  Created by Yuliang Ma on 4/4/14.
//  Copyright (c) 2014 MA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SafeQueue : NSObject
- (void)dequeueWithCompletion: (void (^)(id val))handler;
- (void)enqueue: (id)val;
- (BOOL)isEmpty;
@end