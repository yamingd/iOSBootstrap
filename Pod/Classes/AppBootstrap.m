//
//  AppBootstrap.m
//  AppBootstrap
//
//  Created by Yaming on 10/28/14.
//  Copyright (c) 2014 www.github.com/yamingd. All rights reserved.
//

#import "boost.h"
#import "AppSession.h"
#import "AppBootstrap.h"
#import "AFNetworking.h"
#import "AFNetworking/AFNetworkActivityIndicatorManager.h"
#import "AFNetworkActivityLogger/AFNetworkActivityLogger.h"

@implementation AppBootstrap

- (void)setRootController:(UIViewController *)vc
{
    [self.window setRootViewController:vc];
}

-(BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    
    LOG(@"willFinishLaunchingWithOptions");
    
    [self application:application prepareOpenControllers:launchOptions];
    [self application:application prepareAppSession:launchOptions];
    [self application:application prepareDatabase:launchOptions];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self application:application prepareRootController:launchOptions];
    
    return YES;
}

-(NSString*)getAppNameString{
    return @"appBootstrap";
}

-(BOOL)shouldEnableAPNS{
    return NO;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Set the app badge to 0 when launching
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onAccountSignin:) name:kNotificationAccountSignin object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onAccountSignout:) name:kNotificationAccountSignout object:nil];
    
    self.launchOptions = launchOptions;
    LOG(@"didFinishLaunchingWithOptions BEGIN");
    if (launchOptions) {
        id value = [launchOptions objectForKey:@"UIApplicationLaunchOptionsRemoteNotificationKey"];
        if (value) {
            NSDictionary *userInfo = (NSDictionary *)value;
            self.userNotification = userInfo;
        }
    }
    
    [self application:application prepareAPNSToken:launchOptions];
    
    // Set the app badge to 0 when launching
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
    [self application:application prepareComponents:launchOptions];
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    if (self.userNotification) {
        [EventPoster send:kRemoteNotificationReceived userInfo:self.userNotification];
    }
    
    return YES;
    
}

- (BOOL)application:(UIApplication *)application shouldSaveApplicationState:(NSCoder *)coder{
    return YES;
}

- (BOOL)application:(UIApplication *)application shouldRestoreApplicationState:(NSCoder *)coder{
    return YES;
}
- (UIViewController *)application:(UIApplication *)application viewControllerWithRestorationIdentifierPath:(NSArray *)identifierComponents coder:(NSCoder *)coder
{
    return nil;
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
    @try {
        [self removeTempData];
        LOG(@"remove dbfile. app and vocas.");
    }
    @catch (NSException *exception) {
        
    }
}
-(void)removeTempData{
    
}

-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    NSString *deviceTokenStr = [[[[deviceToken description]
                                  stringByReplacingOccurrencesOfString: @"<" withString: @""]
                                 stringByReplacingOccurrencesOfString: @">" withString: @""]
                                stringByReplacingOccurrencesOfString: @" " withString: @""];
    
    [[AppSession current] saveDeviceToken:deviceTokenStr];
    LOG(@"Device Token: %@", deviceTokenStr);
    [EventPoster send:kRemoteNotificationAccepted userInfo:nil];
}

-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    LOG(@"%@", [NSString stringWithFormat:@"Error:%@", error]);
}

-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    [EventPoster send:kRemoteNotificationReceived userInfo:userInfo];
}

//QQ分享集成
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return YES;
    //return  [UMSocialSnsService handleOpenURL:url];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return YES;
    //return  [UMSocialSnsService handleOpenURL:url];
}

#pragma mark - prepare

-(void)application:(UIApplication *)application prepareAPNSToken:(NSDictionary *)launchOptions{
    if ([self shouldEnableAPNS]) {
        
        //-- Set Notification
        if ([application respondsToSelector:@selector(isRegisteredForRemoteNotifications)])
        {
            // iOS 8 Notifications
            [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
            
            [application registerForRemoteNotifications];
        }
        else
        {
            // iOS < 8 Notifications
            [application registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound)];
        }
    }
}

-(void)application:(UIApplication *)application prepareAppSession:(NSDictionary *)launchOptions{
    [[AppSession current] load:[self getAppNameString]];
}

-(void)application:(UIApplication *)application prepareRootController:(NSDictionary *)launchOptions{
    //TODO: implement in subclass.
    /*
     NSString* appTitle = [[AppSession current].config objectForKey:@"AppTitle"];
     self.loadingController = [[LoadingViewController alloc] init];
     self.loadingController.title = appTitle;
     self.navController = [[UINavigationController alloc] init];
     [self.navController pushViewController:self.loadingController animated:YES];
     [self.window setRootViewController:self.navController];
     */
}

-(void)application:(UIApplication *)application prepareOpenControllers:(NSDictionary *)launchOptions{
    [[AFNetworkActivityLogger sharedLogger] startLogging];
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    
    dispatch_async(kBG_QUEUE, ^{
        [self startNetworkMonitor];
    });
    
}

-(void)application:(UIApplication *)application prepareDatabase:(NSDictionary *)launchOptions{
    self.sqliteContext = [[SqliteContext alloc] initWith:[self getAppNameString] salt:nil];
}

-(void)application:(UIApplication *)application prepareComponents:(NSDictionary *)launchOptions{
    
}

#pragma mark - Network Monitor

static BOOL networNotReachableFlag = NO;

- (void)startNetworkMonitor{
    
    AFNetworkReachabilityManager *afNetworkReachabilityManager = [AFNetworkReachabilityManager sharedManager];
    [afNetworkReachabilityManager startMonitoring];  //开启网络监视器；
    [afNetworkReachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        switch (status) {
            case AFNetworkReachabilityStatusNotReachable:{
                LOG(@"网络不通");
                networNotReachableFlag = YES;
                [self onNetworkLost];
                break;
            }
            case AFNetworkReachabilityStatusReachableViaWiFi:{
                LOG(@"网络通过WIFI连接");
                if (networNotReachableFlag) {
                    networNotReachableFlag = NO;
                    [self onNetworkReconnect];
                }
                break;
            }
                
            case AFNetworkReachabilityStatusReachableViaWWAN:{
                LOG(@"网络通过无线连接");
                if (networNotReachableFlag) {
                    networNotReachableFlag = NO;
                    [self onNetworkReconnect];
                }
                break;
            }
            default:
                break;
        }
        
        LOG(@"网络状态数字返回：%li", (long)status)
        LOG(@"网络状态返回: %@", AFStringFromNetworkReachabilityStatus(status));
        
    }];
    
    //return [AFNetworkReachabilityManager sharedManager].isReachable;
}

-(void)onNetworkLost{
    
}

-(void)onNetworkReconnect{
    
}

-(void)onAccountSignin:(NSNotification*)notification{
    //NSDictionary *dictionary = [notification userInfo];
}

-(void)onAccountSignout:(NSNotification*)notification{
    //NSDictionary *dictionary = [notification userInfo];
}

@end
