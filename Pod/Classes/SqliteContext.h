//
//  SqliteContext.h
//  Pods
//
//  Created by Yaming on 10/6/15.
//
//

#import <Foundation/Foundation.h>
#import "FMDB.h"

@class SqliteMapper;

#define kSqliteTagDefault @"default"
#define kSqliteDbNameSuffix @".db"

@interface SqliteContext : NSObject

@property (strong, nonatomic, readonly)NSString* tag;
@property (strong, nonatomic, readonly)NSString* name;
@property (strong, nonatomic, readonly)NSString* userId;
@property (strong, nonatomic, readonly)NSData* salt;

-(instancetype)initWith:(NSString*)tag name:(NSString*)name salt:(NSData*)salt;
-(instancetype)initWith:(NSString*)name salt:(NSData*)salt;

-(instancetype)setForUser:(long)userId;

-(BOOL)exists;
-(void)deleteFile;

#pragma mark - DDL

-(NSDictionary*)tables;
-(NSSet*)tableColumns:(NSString*)name;
-(void)clearTables;

-(void)createTable:(NSString*)sql;
-(void)alterTable:(NSString*)name columns:(NSDictionary*)columns oldColumns:(NSSet*)oldColumns;
-(void)initTable:(SqliteMapper*)sqliteMapper;

#pragma mark - DML

-(void)update:(NSString*)tag block:(void (^)(FMDatabase* db))block;
-(void)query:(NSString*)tag block:(void (^)(FMDatabase* db))block;

#pragma mark - Session

-(void)close;
-(void)reopen;

@end
