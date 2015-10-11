//
//  AppConfig.h
//  iOSBootstrap
//
//  Created by Yaming on 10/7/15.
//  Copyright © 2015 Yaming. All rights reserved.
//

#ifndef AppConfig_h
#define AppConfig_h

#define kListPageSize 20
#define kAppName @"iOSBootstrapDemo"

#define kQQKey @""
#define kQQSecret @""

#define kWxKey @""
#define kWxSecret @""

#define kTongJiKey @""
#define kTongJiSecret @""


#if DEBUG

#define kAppCookieId @"x-auth"
#define kAppCookieSalt @"iOSBootstrapDemoSecret"
#define kAppAPIBaseUrl @"http://localhost:8080/m"
#define kAppAPNSEnable NO

#define kIMServerIP @""
#define kIMServerPort 9080

#endif

#if TEST

#endif

#if RELEASE

#endif

#endif /* AppConfig_h */
