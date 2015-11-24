//
//  TSAppSession.m
//  AppBootstrap
//
//  Created by Yaming on 10/2/15.
//  Copyright © 2015 www.github.com/yamingd. All rights reserved.
//

#ifdef REALM_DB

#import "TSAppSession.h"
#import "PAppSession.pb.h"

@implementation TSAppSession

+(instancetype)newOne{
    TSAppSession* one = [[TSAppSession alloc] init];
    one.id = 1;
    one.realName = @"Guest";
    one.userName = @"Guest";
    one.userId = 0;
    one.deviceToken = @"NULL";
    
    return one;
}

-(void)resetSessionId{
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
    long long dTime = [[NSNumber numberWithDouble:time] longLongValue];
    self.sessionId = [NSString stringWithFormat:@"%llu",dTime];
}

-(instancetype) initWithProtocolData:(NSData*) data {
    return [self initWithData:data];
}
-(instancetype) initWithProtocolObj:(PAppSession*)pbobj{
    // c++
    if (self = [super init]) {
        [self initValues:pbobj];
    }
    return self;
}

- (void)initValues:(PAppSession *)pbobj {
    self.id = 1;
    if ([pbobj hasSessionId]) {
        self.sessionId = pbobj.sessionId;
    }else{
        [self resetSessionId];
    }
    if ([pbobj hasRealName]) {
        self.realName = pbobj.realName;
    }
    else {
        self.realName = @"Guest";
    }
    if ([pbobj hasUserName]) {
        self.userName = pbobj.userName;
    }
    else {
        self.userName = @"Guest";
    }
    if ([pbobj hasUserId]) {
        self.userId = pbobj.userId;
    }else{
        self.userId = 0;
    }
    if ([pbobj hasSecret]) {
        self.secret = pbobj.secret;
    }
    else {
        self.secret = @"secret";
    }
    if ([pbobj hasSigninDate]) {
        self.signinDate = pbobj.signinDate;
    }
    else {
        self.secret = @"";
    }
    if ([pbobj hasAppName]) {
        self.appName = pbobj.appName;
    }
    else {
        self.appName = @"";
    }
    
    if ([pbobj hasDeviceToken]) {
        self.deviceToken = pbobj.deviceToken;
    }
    else {
        self.deviceToken = @"NULL";
    }
    if ([pbobj hasApnsEnabled]) {
        self.apnsEnabled = pbobj.apnsEnabled;
    }else{
        self.apnsEnabled = 0;
    }
    if ([pbobj latitude]) {
        self.latitude = pbobj.latitude;
    }else{
        self.latitude = 0;
    }
    if ([pbobj longitude]) {
        self.longitude = pbobj.longitude;
    }else{
        self.longitude = 0;
    }
    if ([pbobj cityId]) {
        self.cityId = pbobj.cityId;
    }else{
        self.cityId = 0;
    }
    if ([pbobj userKind]) {
        self.userKind = pbobj.userKind;
    }else{
        self.userKind = 0;
    }
    if ([pbobj userDemo]) {
        self.userDemo = pbobj.userDemo;
    }else{
        self.userDemo = 0;
    }
}

-(NSMutableDictionary*)asDict{
    return nil;
}

-(NSData*) getProtocolData{
    return nil;
}

-(instancetype) initWithData:(NSData*) data {
    
    if(self = [super init]) {
        // c++
        PAppSession* resp = [self deserialize:data];
        self = [self initWithProtocolObj:resp];
    }
    return self;
}

+ (NSString *)primaryKey {
    return @"id";
}

#pragma mark private methods

- (PAppSession *)deserialize:(NSData *)data {
    PAppSession *resp = [PAppSession parseFromData:data];
    return resp;
}

@end

#endif
