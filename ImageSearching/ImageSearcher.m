//
//  ImageSearcher.m
//  ImageSearching
//
//  Created by Yuliang Ma on 4/4/14.
//  Copyright (c) 2014 MA. All rights reserved.
//

#import "ImageSearcher.h"
#import "HTMLParser.h"
#import "SafeSet.h"
#import "SafeQueue.h"
@interface QueueLevel : NSObject  // used in breath first algorithm
@property (nonatomic, assign) int level;
@end
@implementation QueueLevel
@end

@interface ImageSearcher()
@property (nonatomic, strong) SafeSet *visitedBag;
@property (nonatomic, strong) SafeSet *imageURLCollection;
@property (nonatomic, strong) SafeQueue *queue;
@property (nonatomic, strong) QueueLevel *queueLevel;
@property (atomic, assign) int recur_count;
@end

@implementation ImageSearcher
@synthesize visitedBag = _visitedBag;
@synthesize imageURLCollection = _imageURLCollection;
@synthesize queue = _queue;
@synthesize queueLevel = _queueLevel;

#pragma mark - custom getter/setter
- (SafeSet *)visitedBag {
    if (!_visitedBag) _visitedBag = [[SafeSet alloc] init];
    return _visitedBag;
}
- (SafeSet *)imageURLCollection {
    if (!_imageURLCollection) _imageURLCollection = [[SafeSet alloc] init];
    return _imageURLCollection;
}
- (SafeQueue *)queue {
    if (!_queue) _queue = [[SafeQueue alloc] init];
    return _queue;
}
- (QueueLevel *)queueLevel {
    if (!_queueLevel) _queueLevel = [[QueueLevel alloc] init];
    return _queueLevel;
}

#pragma mark - main methods
+ (instancetype)sharedSingleton
{
    static ImageSearcher *sharedSingleton = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedSingleton = [[ImageSearcher alloc] init];
    });
    return sharedSingleton;
}

- (void)clearCache {
    [self.visitedBag removeAllObjects];
    [self.imageURLCollection removeAllObjects];
    self.visitedBag = nil;
    self.imageURLCollection = nil;
    self.queueLevel = nil;
    self.queue = nil;
}

- (void)recursivelyFindImagesFromURL: (NSString *)urlString
                          depthFirst: (BOOL)flag
                               limit: (int)limit
                   completionHandler: (void (^)(NSSet *, NSError*))handler {
    if (flag) {
        [self depthFirstSearchWithURL:urlString limit:limit completionHandler:^(NSError *error) {
            if (error) {
                handler([self.imageURLCollection toNSSet], error);
            } else {
                handler([self.imageURLCollection toNSSet], nil);
            }
        }];
    } else {
        self.queueLevel.level += 1;
        [self.queue enqueue:urlString];
        [self.queue enqueue:self.queueLevel];
        
        [self breathFirstSearchWithLimit:limit completionHandler:^(NSError *error) {
            if (error) {
                handler([self.imageURLCollection toNSSet], error);
            } else {
                handler([self.imageURLCollection toNSSet], nil);
            }
        }];
    }
}

#pragma mark - private methods
- (void)depthFirstSearchWithURL: (NSString *)urlString
                          limit: (int)num
              completionHandler: (void (^)(NSError*))handler {
    NSLog(@"Depth first search with url: %@", urlString);
    self.recur_count++;
    [self.visitedBag add:urlString];
    [[[HTMLParser alloc] init] searchWithURL:urlString completionHandler:^(NSArray *hrefArray, NSArray *imgArray, NSError *error) {
        if (error) {
            self.recur_count--;
            handler(error);
        } else {
            if (imgArray && imgArray.count > 0) {
                for (NSString *url in imgArray)
                    [self.imageURLCollection add:url];
            }
            if (hrefArray && hrefArray.count > 0) {
                for (NSString *url in hrefArray) {
                    if (![self.visitedBag contains:url] && ![self.visitedBag contains:[self cousinURL:url]]) {
                        if ([self.visitedBag count] < num) {
                            [self depthFirstSearchWithURL:url limit:num completionHandler:^(NSError *error) {
                                handler(error);
                            }];
                        } else {
                            break;
                        }
                    }
                }
                self.recur_count--;
                if(self.recur_count == 0) handler(nil);
            } else {
                self.recur_count--;
                if(self.recur_count == 0) handler(nil);
            }
        }
    }];
}

- (void)breathFirstSearchWithLimit: (int)level
                 completionHandler: (void (^)(NSError*))handler {
    NSLog(@"performing breath first search");
    
    if (![self.queue isEmpty] && self.queueLevel.level <= level) {
        __block id obj;
        [self.queue dequeueWithCompletion:^(id val) {
            obj = val;
            if ([obj isKindOfClass:[NSString class]]) {
                NSString *urlString = (NSString *)obj;
                NSLog(@"urlString: %@", urlString);
                [self.visitedBag add:urlString];
                [[[HTMLParser alloc] init] searchWithURL:urlString completionHandler:^(NSArray *hrefArray, NSArray *imgArray, NSError *error) {
                    if (error) {
                        handler(error);
                    } else {
                        if (imgArray && imgArray.count > 0) {
                            for (NSString *url in imgArray)
                                [self.imageURLCollection add:url];
                        }
                        if (hrefArray && hrefArray.count > 0) {
                            for (NSString *url in hrefArray) {
                                if (![self.visitedBag contains:url] && ![self.visitedBag contains:[self cousinURL:url]]) {
                                    [self.queue enqueue:url];
                                    [self breathFirstSearchWithLimit:level completionHandler:^(NSError *error) {
                                        handler(error);
                                    }];
                                }
                            }
                        }
                    }
                }];
            } else {
                QueueLevel *levelObj = (QueueLevel *)obj;
                levelObj.level += 1;
                [self.queue enqueue:levelObj];
            }
        }];
    } else {
        handler(nil);
    }
}

- (NSString *)cousinURL: (NSString *)url {
    return ([url hasSuffix:@"/"]) ? [url substringToIndex:url.length-1] : [url stringByAppendingString:@"/"];
}

@end