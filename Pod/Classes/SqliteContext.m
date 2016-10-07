//
//  SqliteContext.m
//  Pods
//
//  Created by Yaming on 10/6/15.
//  www.github.com/yamingd
//
#import "boost.h"
#import "SqliteContext.h"
#import "SqliteMapper.h"

@interface SqliteContext ()

@property (strong, nonatomic)NSString* path;
@property (strong, nonatomic)NSString* originalName;
@property (strong, nonatomic)FMEncryptDatabaseQueue* dbQueue;
@property (strong, nonatomic)NSMutableDictionary* allTables;

@end

@implementation SqliteContext

+(NSString*)dbFolder{
    NSString *documentsDirectory = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *folder = [NSString stringWithFormat:@"%@/%@", documentsDirectory, @"db"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:folder]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:folder withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return folder;
}

#pragma makr - Init

-(instancetype)initWith:(NSString*)tag name:(NSString*)name salt:(NSData*)salt{
    self = [super init];
    if (self) {
        _tag = tag;
        _name = name;
        _originalName = name;
        _salt = salt;
        _path = [SqliteContext dbFolder];
    }
    
    return self;
}
-(instancetype)initWith:(NSString*)name salt:(NSData*)salt{
    return [self initWith:kSqliteTagDefault name:name salt:salt];
}

-(instancetype)setForUser:(long)userId{
    _userId = [NSString stringWithFormat:@"%ld", userId];
    _name = [NSString stringWithFormat:@"user_%ld", userId];
    return self;
}

-(BOOL)exists{
    NSString* fileName = [self dbFileName];
    return [[NSFileManager defaultManager] fileExistsAtPath:fileName];
}

-(void)deleteFile{
    NSString* fileName = [self dbFileName];
    BOOL mark = [[NSFileManager defaultManager] fileExistsAtPath:fileName];
    if (mark) {
        [[NSFileManager defaultManager] removeItemAtPath:fileName error:nil];
    }
}

#pragma makr - Private

-(NSString*)dbFileName{
    NSString* fileName = [NSString stringWithFormat:@"%@/%@%@", _path, _name, kSqliteDbNameSuffix];
    if ([[NSFileManager defaultManager] fileExistsAtPath:fileName]) {
        return fileName;
    }else{
        return fileName;
    }
}

-(void)ensureDbOpen{
    @synchronized(self){
        if (_dbQueue) {
            return;
        }
        
        NSString* fileName = [self dbFileName];
        _dbQueue = [FMEncryptDatabaseQueue databaseQueueWithPath:fileName encryptKey:_salt];
        LOG("Sqlite Open: %@", fileName);
    }
}

#pragma mark - DDL

-(NSDictionary*)tables{
    [self ensureDbOpen];
    if (_allTables) {
        return _allTables;
    }
    
    _allTables = [NSMutableDictionary dictionary];
    __block NSString* sql = @"SELECT name FROM sqlite_master WHERE type='table' ORDER BY name";
    [_dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet* rs = [db executeQuery:sql];
        NSString* name;
        while ([rs next]) {
            name = [rs stringForColumnIndex:0];
            [_allTables setObject:[NSMutableSet set] forKey:name];
        }
    }];
    
    [_dbQueue inDatabase:^(FMDatabase *db) {
        for (NSString* name in _allTables) {
            NSMutableSet* set = [_allTables objectForKey:name];
            sql = [NSString stringWithFormat:@"PRAGMA table_info('%@')", name];
            
            FMResultSet* rs = [db executeQuery:sql];
            NSString* col;
            while ([rs next]) {
                col = [rs stringForColumnIndex:1];
                [set addObject:col];
            }
            
        }
    }];
    return _allTables;
}

-(NSSet*)tableColumns:(NSString*)name{
    [self ensureDbOpen];
    NSMutableSet* set = [NSMutableSet set];
    NSString* sql = [NSString stringWithFormat:@"PRAGMA table_info('%@')", name];
    [_dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet* rs = [db executeQuery:sql];
        NSString* col;
        while ([rs next]) {
            col = [rs stringForColumnIndex:1];
            [set addObject:col];
        }
    }];
    return set;
}

-(void)clearTables{
    if (_allTables) {
        [_allTables removeAllObjects];
    }
    _allTables = nil;
}

-(void)createTable:(NSString*)sql{
    [self ensureDbOpen];
    @synchronized(self) {
        [_dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
            [db executeUpdate:sql withArgumentsInArray:nil];
        }];
    }
}

-(void)alterTable:(NSString*)name columns:(NSDictionary*)columns oldColumns:(NSSet*)oldColumns{
    [self ensureDbOpen];
    @synchronized(self) {
        __block NSString* sql0 = @"alter table %@ add column %@ %@";
        [_dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
            
            for (NSString* col in columns) {
                if ([oldColumns containsObject:col]) {
                    continue;
                }
                
                [db executeUpdate:[NSString stringWithFormat:sql0, name, col, [columns objectForKey:col]] withArgumentsInArray:nil];
            }
            
        }];
    }
}

-(void)initTable:(SqliteMapper*)sqliteMapper{
    NSString *tableName = sqliteMapper.tableName;
    NSSet* oldColumns = [self tableColumns:tableName];
    if (!oldColumns || oldColumns.count == 0) {
        [self createTable:sqliteMapper.createTableSql];
    }else{
        [self alterTable:tableName columns:sqliteMapper.tableColumns oldColumns:oldColumns];
    }
}

#pragma mark - DML

-(void)update:(NSString*)tag block:(void (^)(FMDatabase* db))block{
    __block NSTimeInterval ts = [[NSDate date] timeIntervalSince1970];
    [self ensureDbOpen];
    [_dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        @try {
            block(db);
            *rollback = NO;
        }
        @catch (NSException *exception) {
            LOG(@"Error: %@", exception);
            *rollback = YES;
        }
        @finally {
            ts = [[NSDate date] timeIntervalSince1970] - ts;
            LOG(@"db-%@ update complete duration: %f ms, tag: %@", _tag, ts, tag);
        }
    }];
    
}
-(void)query:(NSString*)tag block:(void (^)(FMDatabase* db))block{
    NSTimeInterval ts = [[NSDate date] timeIntervalSince1970];
    [self ensureDbOpen];
    [_dbQueue inDatabase:^(FMDatabase *db) {
        block(db);
    }];
    ts = [[NSDate date] timeIntervalSince1970] - ts;
    LOG(@"db-%@ query complete duration: %f ms, tag: %@", _tag, ts, tag);
}

#pragma mark - Session

-(void)close{
    if (_dbQueue) {
        [_dbQueue close];
    }
    _dbQueue = nil;
}

-(void)reopen{
    [self close];
    _name = _originalName;
    [self ensureDbOpen];
}

@end
