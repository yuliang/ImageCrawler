//
//  SafeSet.h
//  ImageSearching
//
//  Created by Yuliang Ma on 4/4/14.
//  Copyright (c) 2014 MA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SafeSet : NSObject

- (void)add: (id)val;

- (BOOL)contains: (id)val;

- (NSSet *)toNSSet;

- (NSUInteger)count;

- (void)removeAllObjects;

@end
