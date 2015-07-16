//
//  AppDelegate.m
//  ZMShareModel
//
//  Created by Leo on 15/6/19.
//  Copyright (c) 2015年 Leo. All rights reserved.
//

#import "AppDelegate.h"


@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [[ZMShareModel sharedIntence] handleOpenURL: url sourceApplication: sourceApplication annotation: annotation];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return [[ZMShareModel sharedIntence] handleOpenURL: url];
}

@end
