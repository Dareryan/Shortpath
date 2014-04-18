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
#import "APIClient.h"
#import "Event+Methods.h"
#import "AFNetworkActivityIndicatorManager.h"
#import <AFNetworking.h>
#import "Visitor.h"
#import <AFOAuth2Client/AFOAuth2Client.h>
#import <AFNetworking/AFNetworking.h>


@implementation FISAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{

    [[AFNetworkActivityIndicatorManager sharedManager]setEnabled:YES];

    [[AFNetworkReachabilityManager sharedManager] startMonitoring];

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
    
    //[self.dataStore saveContext];
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

//- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
//{
//    NSString *responseURL = [url absoluteString];
//    NSLog(@"%@",responseURL);
//    
//    NSString *pattern = @"flatironshortpath:\\/\\/oauthCallback\\?code=(.+)&state=";
//    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:0 error:nil];
//    NSArray *matches = [regex matchesInString:responseURL options:0 range:NSMakeRange(0, [responseURL length])];
//    NSTextCheckingResult *match = matches[0];
//    
//    NSString *code = [responseURL substringWithRange:[match rangeAtIndex:1]];
//    
//    NSLog(@"%@",code);
//    
//    NSURL *urlForBase = [NSURL URLWithString:@"https://core.staging.shortpath.net"];
//    
//    
//    AFOAuth2Client *client = [[AFOAuth2Client alloc] initWithBaseURL:urlForBase clientID:@"F50bIw7OVNXDU0ohYkn15U8cHTbKeUu1Kaa1zRlK" secret:@"b89HZvCKilyMJbF1d0GQZFfOvbFI5JkgFY5wSV89"];
//    client.requestSerializer = [AFJSONRequestSerializer serializer];
//    
//    
//    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
//    securityPolicy.allowInvalidCertificates = YES;
//    [client setSecurityPolicy:securityPolicy];
//    
//    [client authenticateUsingOAuthWithURLString:@"https://core.staging.shortpath.net/oauth/access_token" code:code redirectURI:@"flatironshortpath://oauthCallback" success:^(AFOAuthCredential *credential) {
//        
//        NSLog(@"credential: %@", credential);
//        
//    } failure:^(NSError *error) {
//        
//        NSLog(@"fail with error: %@", error);
//    }];
//    
//    
//    return YES;
//}
//



@end
