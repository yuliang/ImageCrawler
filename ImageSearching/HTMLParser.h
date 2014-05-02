//
//  HTMLParser.h
//  ImageSearching
//
//  Created by Yuliang Ma on 4/4/14.
//  Copyright (c) 2014 MA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HTMLParser : NSObject

// First array is array of links (href)
// Second array is array of image links (img)
- (void)searchWithURL: (NSString *)urlString completionHandler: (void (^)(NSArray *, NSArray *, NSError*))handler;
@end
