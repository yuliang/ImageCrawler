//
//  AppDelegate.m
//  ImageSearching
//
//  Created by Yuliang Ma on 4/4/14.
//  Copyright (c) 2014 MA. All rights reserved.
//

#import "AppDelegate.h"
#import "SearchViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:[[SearchViewController alloc] init]];
    self.window.rootViewController = navigationController;
    [self.window makeKeyAndVisible];
    return YES;
}

/********** notes *************

1. URL -> HTML code  URL parameter -> NSString of HTML
2. NSString occurrences of a string <img> </img>  // Take HTML string as parameter, return array of image URLs, add to collection of image URLs
3. if it is another URL, do #2 recursively
4. Dictionary of URLs that I have visited (dictionary size < 50)

5. Download and present images from the collection



*/


@end
