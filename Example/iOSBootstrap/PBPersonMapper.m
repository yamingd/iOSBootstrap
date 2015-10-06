//
//  PBPersonMapper.m
//  iOSBootstrap
//
//  Created by Yaming on 10/6/15.
//  Copyright © 2015 Yaming. All rights reserved.
//

#import "PBPersonMapper.h"

@implementation PBPersonMapper

+(instancetype)instance{
    static PBPersonMapper *_shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shared = [[PBPersonMapper alloc] init];
    });
    return _shared;
}

-(instancetype)init{
    self = [super init];
    return self;
}

-(void)prepare{
    self.pkColumn = @"id";
    self.tableName = @"ts_person";
    self.tableColumns = @{@"id": @"integer",};
    self.columns = @[];
    
    [super prepare];
}

-(void)ensureContext{
    self.sqliteContext = nil;
}

#pragma mark - ResultSet

-(id)map:(FMResultSet*)rs withItem:(id)item{
    return nil;
}

#pragma mark - Save

-(NSArray*)buildSaveParameters:(id)item{
    PBPerson* person = (PBPerson*)item;
    NSMutableArray* args = [NSMutableArray array];
    [args addObject:@(1)];
    return args;
}

#pragma mark - Wrap
-(void)wrap:(id)item withRef:(BOOL)ref{
    PBPerson* person = (PBPerson*)item;
}

-(void)wrapList:(NSArray*)items withRef:(BOOL)ref{
    //在子类实现
}

-(void)saveRef:(id)item{
    //在子类实现
}

-(void)saveRefList:(NSArray*)items{
    //在子类实现
}

@end
