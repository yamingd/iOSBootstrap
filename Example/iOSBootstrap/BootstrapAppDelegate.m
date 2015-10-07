//
//  BootstrapAppDelegate.m
//  iOSBootstrap
//
//  Created by Yaming on 10/05/2015.
//  Copyright (c) 2015 Yaming. All rights reserved.
//

#import "BootstrapAppDelegate.h"

@implementation BootstrapAppDelegate

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Set the app badge to 0 when coming to front
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}

-(NSString*)getAppNameString{
    return kAppName;
}

-(BOOL)shouldEnableAPNS{
    return kAppAPNSEnable;
}

#pragma mark - Application Prepare

- (void)application:(UIApplication *)application prepareAppSession:(NSDictionary *)launchOptions{
    [super application:application prepareAppSession:launchOptions];
    [[AppSecurity instance] config:kAppCookieId salt:kAppCookieSalt];
    [[APIClient shared] initWithApiBase:kAppAPIBaseUrl];
}
- (void)application:(UIApplication *)application prepareComponents:(NSDictionary *)launchOptions{
    
    // Set out NSURLCache settings
    NSURLCache *URLCache = [[NSURLCache alloc] initWithMemoryCapacity:4 * 1024 * 1024 diskCapacity:20 * 1024 * 1024 diskPath:nil];
    [NSURLCache setSharedURLCache:URLCache];
    
}
- (void)application:(UIApplication *)application prepareDatabase:(NSDictionary *)launchOptions{
    [super application:application prepareDatabase:launchOptions];
}
- (void)application:(UIApplication *)application prepareOpenControllers:(NSDictionary *)launchOptions{
    [super application:application prepareOpenControllers:launchOptions];
}
- (void)application:(UIApplication *)application prepareRootController:(NSDictionary *)launchOptions{
    UIViewController *rootVC = [XibFactory productWithStoryboardIdentifier:@"BootstrapViewController"];
    [self.window setRootViewController:rootVC];
}

#pragma makr - Global Event

-(void)onNetworkLost{
    
}

-(void)onNetworkReconnect{
    
}

@end
