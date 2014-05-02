//
//  HTMLParser.m
//  ImageSearching
//
//  Created by Yuliang Ma on 4/4/14.
//  Copyright (c) 2014 MA. All rights reserved.
//

#import "HTMLParser.h"
#import "AFNetworking/AFHTTPRequestOperation.h"

@interface HTMLParser()
@property (nonatomic, strong) NSMutableArray *hrefArray;
@property (nonatomic, strong) NSMutableArray *imgArray;
@property (nonatomic, copy) NSString *baseURL;
@property (nonatomic, copy) NSString *startsWith;
@end

@implementation HTMLParser
@synthesize hrefArray = _hrefArray;
@synthesize imgArray = _imgArray;

- (NSMutableArray *)hrefArray {
    if (!_hrefArray) _hrefArray = [NSMutableArray array];
    return _hrefArray;
}
- (NSMutableArray *)imgArray {
    if (!_imgArray) _imgArray = [NSMutableArray array];
    return _imgArray;
}

- (void)searchWithURL: (NSString *)urlString completionHandler: (void (^)(NSArray *, NSArray *, NSError*))handler {
    NSURL *url = [NSURL URLWithString:urlString];
    NSArray *pathComponents = [urlString pathComponents];
    if (pathComponents.count > 1) self.baseURL = [NSString stringWithFormat:@"%@//%@", pathComponents[0], pathComponents[1]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSString *string = [[NSString alloc] initWithData:responseObject encoding:NSASCIIStringEncoding];
        //NSLog(@"%@", string);
        [self processHTMLString:string];
        handler([self.hrefArray copy], [self.imgArray copy], nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        handler(nil, nil, error);
    }];
    
    [operation start];
}

- (void)processHTMLString: (NSString *)html {
    // Find href links
    NSError *error = NULL;
    NSString *pattern = @"<a\\s+(?:[^>]*?\\s+)?href=\"([^\"]*)\""; //@"<(a|link)\\s+(?:[^>]*?\\s+)?href=\"([^\"]*)\"";
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&error];
    NSArray *array = [regex matchesInString:html options:0 range:NSMakeRange(0, html.length)];
    for (NSTextCheckingResult *match in array) {
        NSString *matchString = [html substringWithRange:match.range];
        NSArray *components = [matchString componentsSeparatedByString:@"href=\""];
        if(components.count < 2) continue;
        NSString *temp = components[1];
        NSString *urlString = [temp substringToIndex:temp.length-1];
        if (![urlString hasPrefix:@"#"] &&
            ![urlString hasPrefix:@"javascript:"] &&
            ![urlString hasPrefix:@"mailto:"] &&
            ![urlString hasPrefix:@"irc://"] &&
            ![urlString hasSuffix:@".css"] &&
            urlString.length > 1) {
            urlString = [self fullPathFromURL:urlString]; // deal with relative path
            //NSLog(@"%@", urlString);
            [self.hrefArray addObject:urlString];
        }
    }
    //NSLog(@"%lu urls found", (unsigned long)array.count);
    
    // Find img urls
    pattern = @"<img\\s[^>]*?src\\s*=\\s*['\"]([^'\"]*?)['\"][^>]*?>";
    regex = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&error];
    array = [regex matchesInString:html options:0 range:NSMakeRange(0, html.length)];
    for (NSTextCheckingResult *match in array) {
        NSString *matchString = [html substringWithRange:match.range];
        matchString = [matchString stringByReplacingOccurrencesOfString:@"'" withString:@"\""]; // to cover both <img src=' and <img src="
        NSArray *components = [matchString componentsSeparatedByString:@"src=\""];
        if(components.count < 2) continue;
        NSString *temp = components[1];
        components = [temp componentsSeparatedByString:@"\""];
        if(components.count < 2) continue;
        NSString *urlString = components[0];
        if (urlString.length < 2) continue; // dump if it is too short
        urlString = [self fullPathFromURL:urlString]; // deal with relative path
        //NSLog(@"---  %@", urlString);
        [self.imgArray addObject:urlString];
    }
}

- (NSString *)fullPathFromURL: (NSString *)urlString {
    NSString *fullPath = urlString;
    if ([fullPath hasPrefix:@"/"]) fullPath = [self.baseURL stringByAppendingString:urlString];
    if ([fullPath rangeOfString:@"://"].location == NSNotFound) fullPath = [NSString stringWithFormat:@"%@/%@", self.baseURL, urlString];
    return fullPath;
}
@end
