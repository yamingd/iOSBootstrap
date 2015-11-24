//
//  AppSession.h
//  EnglishCafe
//
//  Created by yaming_deng on 2/5/14.
//  Copyright (c) 2014 www.github.com/yamingd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PAppSession.pb.h"

#define kDbSession @"session"

@interface AppSession : NSObject

+ (AppSession*)current;

@property(strong, nonatomic, readonly) NSString* appName;
@property(strong, nonatomic, readonly) PAppSession* session;
@property(strong, nonatomic) NSMutableDictionary *flash;
@property(strong, nonatomic, readonly) NSString* userAgent;

- (instancetype)init;

//是否匿名
- (BOOL)isAnonymous;
- (BOOL)isSignIn;

//环境参数DICT
- (NSDictionary*) envdict;

//API调用参数DICT
- (NSDictionary*) apidict;
- (NSDictionary*) header;

- (void)remember:(long)userId userName:(NSString*)userName realName:(NSString*)realName userKind:(int)userKind;
- (void)saveDeviceToken:(NSString*)token;

- (void)clear;
- (void)load:(NSString*)appName;

@end
