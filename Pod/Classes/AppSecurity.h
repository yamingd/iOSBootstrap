//
//  AppSecurity.h
//  AppBootstrap
//
//  Created by Yaming on 10/2/15.
//  Copyright © 2015 www.github.com/yamingd. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AppSession;
@class PAppSession;

@interface AppSecurity : NSObject

+ (instancetype)instance;
+ (NSString*)randomCode;

@property(strong, nonatomic, readonly) NSString* cookieId;
@property(strong, nonatomic, readonly) NSString* cookieSalt;
@property(strong, nonatomic, readonly) NSString* aesSeed;

-(void)config:(NSString*)cookieId salt:(NSString*)salt aesSeed:(NSString*)aesSeed;

-(NSDictionary*)signSession:(PAppSession*)session;

-(NSString*)signRequest:(NSString*)url;

-(NSString*)aes128Encrypt:(NSString*)text;

-(NSString*)aes128Decrypt:(NSString*)text;

@end
