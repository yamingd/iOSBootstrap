//
//  AppSecurity.h
//  AppBootstrap
//
//  Created by Yaming on 10/2/15.
//  Copyright © 2015 whosbean.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AppSession;
@class PAppSession;

@interface AppSecurity : NSObject

+ (instancetype)instance;
+ (NSString*)randomCode;


+ (NSString*)aes128Encrypt:(NSString*)text salt:(NSString*)salt iv:(NSString *)iv;
+ (NSString*)aes128Decrypt:(NSString*)text salt:(NSString*)salt iv:(NSString *)iv;

@property(strong, nonatomic, readonly) NSString* cookieId;
@property(strong, nonatomic, readonly) NSString* cookieSalt;

-(void)config:(NSString*)cookieId salt:(NSString*)salt;

-(NSDictionary*)signSession:(PAppSession*)session;

-(NSString*)signRequest:(NSString*)url;

@end
