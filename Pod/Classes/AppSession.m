//
//  AppSession.m
//  EnglishCafe
//
//  Created by yaming_deng on 2/5/14.
//  Copyright (c) 2014 www.github.com/yamingd. All rights reserved.
//

#import "boost.h"
#import "AppSession.h"
#import "SqliteContext.h"
#import "DeviceHelper.h"
#import "AppSecurity.h"

#define SESSION_UPDATE @"replace into app_session(key, data)values(?, ?)"
#define SESSION_SELECT_ALL @"select key, data from app_session"
#define SESSION_INSERT @"insert into app_session(key, data)values(?, ?)"
#define SESSION_DB_INIT @"create table if not exists app_session(key text primary key, data blob) without ROWID"

@interface AppSession ()

@property(strong, nonatomic)SqliteContext* sessionDb;
@property(strong, nonatomic)PAppSessionBuilder* sessionBuilder;
@property BOOL hasRecord;

@end

@implementation AppSession

+ (instancetype)current {
    static AppSession *_shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shared = [[AppSession alloc] init];
    });
    return _shared;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        _sessionDb = [[SqliteContext alloc] initWith:kDbSession name:kDbSession salt:nil];
        [_sessionDb createTable:SESSION_DB_INIT];
    }
    return self;
}

- (void)dealloc{
    
    PRINT_DEALLOC
    
    if (_sessionDb) {
        [_sessionDb close];
    }
}

- (BOOL)isAnonymous{
    return self.session == nil || self.session.userId == 0;
}

- (BOOL)isSignIn{
    return self.session !=nil && self.session.userName && self.session.userId > 0;
}

//环境字典
- (NSMutableDictionary*) envdict{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:self.session.deviceId forKey:@"device_id"];
    
    [dict setValue:self.session.deviceName forKey:@"device_name"];
    [dict setValue:self.session.deviceScreenSize forKey:@"device_screensize"];
    
    [dict setValue:self.session.osName forKey:@"os_name"];
    [dict setValue:self.session.osVersion forKey:@"os_version"];
    
    [dict setValue:self.session.packageVersion forKey:@"package_version"];
    [dict setValue:self.session.packageName forKey:@"package_name"];
    
    return dict;
}

//API调用参数DICT
- (NSMutableDictionary*) apidict{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:self.session.sessionId forKey:@"sessionid"];
    [dict setValue:self.session.userName forKey:@"uname"];
    return dict;
}

- (NSDictionary*) header{
    return [[AppSecurity instance] signSession:self.session];
}

- (void)remember:(long)userId userName:(NSString*)userName realName:(NSString*)realName userKind:(int)userKind{
    //save session to local file
    _sessionBuilder.userId = userId;
    _sessionBuilder.userName = userName;
    _sessionBuilder.realName = realName;
    _sessionBuilder.userKind = userKind;
    _session = [_sessionBuilder build];
    [self save];
}

- (void)saveDeviceToken:(NSString*)token{
    _sessionBuilder.deviceToken = token;
    if (!token) {
        _sessionBuilder.deviceToken = @"NULL";
    }
    _session = [_sessionBuilder build];
    [self save];
}

-(void)clear{
    _sessionBuilder.userId = 0;
    _sessionBuilder.userName = @"Guest";
    _sessionBuilder.realName = @"Guest";
    _session = [_sessionBuilder build];
    
    [self save];
}

- (void)wrapDevivceApp{
    _sessionBuilder.osName = [DeviceHelper getOSName];
    _sessionBuilder.osVersion = [DeviceHelper getOSVersion];
    _sessionBuilder.deviceName = [DeviceHelper getDeviceName];
    _sessionBuilder.deviceScreenSize = [DeviceHelper getScreenSize];
    _sessionBuilder.packageName = [DeviceHelper getAppName];
    _sessionBuilder.packageVersion = [DeviceHelper getAppVersion];
    if (!_sessionBuilder.deviceToken) {
        _sessionBuilder.deviceToken = @"NULL";
    }
    _sessionBuilder.deviceId = [DeviceHelper getDeviceUdid];
    _sessionBuilder.appName = _appName;
    
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    _sessionBuilder.localeIdentifier = [[NSLocale currentLocale] objectForKey:NSLocaleLanguageCode];
    _userAgent = [NSString stringWithFormat:@"%@/%@ (%@; %@; %@)", _appName, version, [[UIDevice currentDevice] model], [[UIDevice currentDevice] systemVersion], _sessionBuilder.localeIdentifier];
}

-(void)save{
    __block NSData* data = [_session data];
    if (_hasRecord) {
        [_sessionDb update:@"updateSession" block:^(FMDatabase *db) {
            [db executeUpdate:SESSION_UPDATE, @"session", data];
        }];
    }else{
        [_sessionDb update:@"insertSession" block:^(FMDatabase *db) {
            [db executeUpdate:SESSION_INSERT, @"session", data];
        }];
        _hasRecord = YES;
    }
    
    [_sessionBuilder clear];
    _sessionBuilder = [[PAppSession builder] mergeFrom:_session];
    [self wrapDevivceApp];
}

- (void)load:(NSString*)appName{
    //load session from db file.
    _appName = appName;
    _sessionBuilder = [PAppSession builder];
    _hasRecord = NO;
    
    [_sessionDb query:@"SESSION_SELECT_ALL" block:^(FMDatabase *db) {
        FMResultSet* rs = [db executeQuery:SESSION_SELECT_ALL];
        while (rs.next) {
            _hasRecord = YES;
            NSData* data = [rs dataForColumnIndex:1];
            [_sessionBuilder mergeFromData:data];
            break;
        }
        [rs close];
    }];
    
    [self wrapDevivceApp];
    
    _session = [_sessionBuilder build];
    
    [self save];
}

@end
