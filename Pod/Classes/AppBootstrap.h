//
//  AppBootstrap.h
//  AppBootstrap
//
//  Created by Yaming on 10/28/14.
//  Copyright (c) 2014 www.github.com/yamingd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SqliteContext.h"

@interface AppBootstrap : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) SqliteContext* sqliteContext;
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSDictionary *launchOptions;
@property (strong, nonatomic) NSDictionary *userNotification;

-(void)setRootController:(UIViewController *)vc;

-(NSString*)getAppNameString;

-(BOOL)shouldEnableAPNS;

-(void)application:(UIApplication *)application prepareNetwork:(NSDictionary *)launchOptions;

-(void)application:(UIApplication *)application prepareAPNSToken:(NSDictionary *)launchOptions;

-(void)application:(UIApplication *)application prepareAppSession:(NSDictionary *)launchOptions;

-(void)application:(UIApplication *)application prepareRootController:(NSDictionary *)launchOptions;

-(void)application:(UIApplication *)application prepareOpenControllers:(NSDictionary *)launchOptions;

-(void)application:(UIApplication *)application prepareDatabase:(NSDictionary *)launchOptions;

-(void)application:(UIApplication *)application prepareComponents:(NSDictionary *)launchOptions;

-(void)onNetworkLost;
-(void)onNetworkReconnect;

-(void)onAccountSignin:(NSNotification*)notes;
-(void)onAccountSignout:(NSNotification*)notes;

@end
