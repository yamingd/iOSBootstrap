//
//  RealmHelper.h
//  AppBootstrap
//
//  Created by Yaming on 10/31/14.
//  Copyright (c) 2014 www.github.com/yamingd. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifdef REALM_DB

#import <Realm/Realm.h>

@interface RealmContext : NSObject

+(NSString*)userFolder;

@property(nonatomic, strong)NSString* name;
@property(nonatomic, strong)NSArray* classes;
@property int version;

-(instancetype)initWith:(NSString*)name classes:(NSArray*)classes version:(int)version;

-(RLMRealm*)open;

-(void)erase;
-(void)update:(void (^)(RLMRealm* realm))block;
-(void)query:(void (^)(RLMRealm* realm))block;
-(void)dealloc;

@end

#endif