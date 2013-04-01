//
//  AppDelegate.m
//  BabyPictorial
//
//  Created by han chao on 13-3-19.
//  Copyright (c) 2013年 taoxiaoxian. All rights reserved.
//

#import "AppDelegate.h"

#import "MainViewController.h"

#import "MobClick.h"

@implementation AppDelegate

- (void)dealloc
{
    self.navController = nil;
    
    [_window release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    
    [MobClick startWithAppkey:YOUMENG_APP_KEY reportPolicy:REALTIME channelId:nil];
    //检查更新
    [MobClick checkUpdate];
    
    self.navController = [[UINavigationController alloc]
                          initWithRootViewController:[[[MainViewController alloc] initWithNibName:@"MainViewController"
                                                                                           bundle:nil] autorelease]];
    
    
//    [self.navController setNavigationBarHidden:YES];
    
    
    if ( [[UIDevice currentDevice].systemVersion floatValue] < 6.0)
    { // warning: addSubView doesn't work on iOS6
        
        [self.window addSubview:self.navController.view];
    }
    else
    { // use this mehod on ios6

        self.window.rootViewController = self.navController;
        
    }
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
