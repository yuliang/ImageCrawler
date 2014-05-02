//
//  ImageSearcher.h
//  ImageSearching
//
//  Created by Yuliang Ma on 4/4/14.
//  Copyright (c) 2014 MA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageSearcher : NSObject
+ (instancetype)sharedSingleton;
- (void)recursivelyFindImagesFromURL: (NSString *)urlString
                          depthFirst: (BOOL)flag  // if no then it does breath first traversal
                               limit: (int)limit  // For depth first, limits number of visited websites; For breath first, num of levels
                   completionHandler: (void (^)(NSSet *, NSError*))handler;

- (void)clearCache;
@end
