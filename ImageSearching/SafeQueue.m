//
//  SafeQueue.m
//  ImageSearching
//
//  Created by Yuliang Ma on 4/4/14.
//  Copyright (c) 2014 MA. All rights reserved.
//

#import "SafeQueue.h"
@interface SafeQueue() {
    NSMutableArray *array;
    dispatch_queue_t queue;
}

@end

@implementation SafeQueue
- (id)init {
    self = [super init];
    array = [[NSMutableArray alloc] init];
    queue = dispatch_queue_create("Safe Queue", NULL);
    return self;
}

- (void)dequeueWithCompletion: (void (^)(id val))handler{
    dispatch_async(queue, ^{
        if (![self isEmpty]) {
            id obj = array[0];
            [array removeObjectAtIndex:0];
            handler(obj);
        }
    });
}
- (void)enqueue: (id)val {
    dispatch_async(queue, ^{
        [array addObject:val];
    });
}
- (BOOL)isEmpty {
    return array.count == 0;
}

@end
