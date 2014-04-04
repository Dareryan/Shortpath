//
//  FISAppDelegate.m
//  ShortPath
//
//  Created by Eugene Watson on 4/1/14.
//  Copyright (c) 2014 Eugene Watson. All rights reserved.
//

#import "FISAppDelegate.h"
#import "FISTabBarControllerViewController.h"
#import "FISViewController.h"

@implementation FISAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    //Create Nav VC here
    //Check to see if have a token
    // set root view based on having a token or not
    
    //make method to handle logging out - delete the token and pop back to root nav controller and present login screen (Blue Logo screen)
    //this is everytime app is launched, need to check for token bc not always coming from log out screen
    
    //self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    //UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    FISTabBarControllerViewController *tabBarVC = (FISTabBarControllerViewController *) [storyBoard instantiateViewControllerWithIdentifier:@"tabBarVC"];
//    UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController: tabBarVC];
//    navVC.navigationBarHidden = YES;
//    self.window.rootViewController = navVC;
//    [self.window makeKeyAndVisible];

    
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

+(void)hasToken
{
    
    
}




@end
