//
//  SqliteMapper.m
//  Pods
//  在子类实现单例
//  Created by Yaming on 10/6/15.
//
//

#import "SqliteMapper.h"
#import "boost.h"

@interface SqliteMapper ()

@property(nonatomic, strong)NSString* pkColumn;
@property(nonatomic, strong)NSString* tableName;
@property(nonatomic, strong)NSDictionary* tableColumns;
@property(nonatomic, strong)NSArray* columns;
@property(nonatomic, strong)SqliteContext* sqliteContext;

@property(strong, nonatomic)NSString* selectFields;
@property(strong, nonatomic)NSString* sqlForGet;
@property(strong, nonatomic)NSString* sqlForSave;

@end

@implementation SqliteMapper

#pragma mark - Private

-(void)buildCreateTableSql{
    NSMutableString* s = [NSMutableString string];
    
    for (NSString* col in _tableColumns) {
        [s appendFormat:@"%@ %@", col, [_tableColumns objectForKey:col]];
        if ([col isEqualToString:_pkColumn]) {
            [s appendString:@" PRIMARY KEY"];
        }
        [s appendString:S_COMMOA];
    }
    
    [s deleteCharactersInRange:NSMakeRange(s.length-2, 2)];
    
    _createTableSql = [NSString stringWithFormat:CREATE, _tableName, s];
}
-(void)buildSelectFields{
    NSMutableString* s = [NSMutableString string];
    
    for (NSString* col in _columns) {
        [s appendString:col];
        [s appendString:S_COMMOA];
    }
    
    [s deleteCharactersInRange:NSMakeRange(s.length-2, 2)];
    
    _selectFields = s;
}
-(void)buildSqlForGet{
    NSMutableString* s = [NSMutableString string];
    [s appendString:SELECT];
    for (NSString* col in _columns) {
        [s appendString:col];
        [s appendString:S_COMMOA];
    }
    
    [s deleteCharactersInRange:NSMakeRange(s.length-2, 2)];
    [s appendString:FROM];
    [s appendFormat:@"%@ %@ = ?", WHERE, _pkColumn];
    
    _sqlForGet = s;
}
-(void)buildSqlForSave{
    NSMutableString* s = [NSMutableString string];
    [s appendString:@"REPLACE INTO"];
    [s appendString:_tableName];
    [s appendString:@"("];
    [s appendString:_selectFields];
    [s appendString:@")"];
    [s appendString:@"values("];
    for (NSString* col in _columns) {
        [s appendString:S_QMARK];
    }
    [s deleteCharactersInRange:NSMakeRange(s.length-1, 1)];
    [s appendString:@")"];
    
    _sqlForSave = s;
}

#pragma mark - Public

+(instancetype)instance{
    static SqliteMapper *_shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shared = [[SqliteMapper alloc] init];
    });
    return _shared;
}

-(instancetype)init{
    self = [super init];
    if (self) {
        [self prepareSql];
        [self prepare];
    }
    return self;
}

-(void)prepareSql{
    [self buildCreateTableSql];
    [self buildSelectFields];
    [self buildSqlForGet];
    [self buildSqlForSave];
}

-(void)prepare{
    [self ensureContext];
    [_sqliteContext initTable:self];
    // 子类完成自定义的属性设置后，调用父类prepare
}

-(NSString*)filterNull:(NSString*)val{
    if (!val) {
        return @"";
    }
    return val;
}

-(void)ensureContext{
    NSException *e = [NSException exceptionWithName:@"NotImplement" reason:@"NotImplement" userInfo:nil];
    @throw e;
}

#pragma mark - ResultSet

-(id)map:(FMResultSet*)rs withItem:(id)item{
    NSException *e = [NSException exceptionWithName:@"NotImplement" reason:@"NotImplement" userInfo:nil];
    @throw e;
}

#pragma mark - Wrap
-(void)wrap:(id)item withRef:(BOOL)ref{
    //在子类实现
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

#pragma mark - Get

-(id)get:(id)pkValue withRef:(BOOL)ref{
    if (!pkValue) {
        return nil;
    }
    
    __block id item;
    WEAKSELF_DEFINE
    [_sqliteContext query:@"getByPk" block:^(FMDatabase *db) {
        FMResultSet* rs = [db executeQuery:_sqlForGet, pkValue];
        while ([rs next]) {
            item = [weakSelf map:rs withItem:nil];
        }
    }];
    if (ref) {
        [self wrap:item withRef:ref];
    }
    return item;
}
-(NSArray*)gets:(NSString*)tag withArray:(NSArray*)pkValues withRef:(BOOL)ref{
    if (!pkValues || pkValues.count == 0) {
        return [NSMutableArray array];
    }
    NSMutableArray* result = [NSMutableArray array];
    NSMutableString* s = [NSMutableString stringWithString:_sqlForGet];
    for (int i=1; i<pkValues.count; i++) {
        [s appendFormat:@"%@%@ = ?", S_OR, _pkColumn];
    }
    WEAKSELF_DEFINE
    [_sqliteContext query:tag block:^(FMDatabase *db) {
        FMResultSet* rs = [db executeQuery:s withArgumentsInArray:pkValues];
        while ([rs next]) {
            id item = [weakSelf map:rs withItem:nil];
            [result addObject:item];
        }
    }];
    if (ref) {
        [self wrapList:result withRef:ref];
    }
    return result;
}

-(NSArray*)gets:(NSString*)tag withSet:(NSSet*)pkValues withRef:(BOOL)ref{
    if (!pkValues || pkValues.count == 0) {
        return [NSMutableArray array];
    }
    if (pkValues.count == 1) {
        NSMutableArray* result = [NSMutableArray array];
        NSEnumerator *itor = [pkValues objectEnumerator];
        id pk = itor.nextObject;
        id item = [self get:pk withRef:ref];
        [result addObject:item];
        return result;
    }else{
        NSEnumerator *itor = [pkValues objectEnumerator];
        return [self gets:tag withArray:itor.allObjects withRef:ref];
    }
}

-(NSArray*)gets:(NSString*)tag withComma:(NSString*)pkValues withRef:(BOOL)ref{
    if (!pkValues || pkValues.length == 0) {
        return [NSMutableArray array];
    }
    NSArray* vals = [pkValues componentsSeparatedByString:@","];
    return [self gets:tag withArray:vals withRef:ref];
}

#pragma mark - Save

-(NSArray*)buildSaveParameters:(id)item{
    NSException *e = [NSException exceptionWithName:@"NotImplement" reason:@"NotImplement" userInfo:nil];
    @throw e;
}

-(BOOL)save:(NSString*)tag withItem:(id)item withRef:(BOOL)ref{
    if (!item) {
        return NO;
    }
    __block BOOL flag = NO;
    NSArray* args = [self buildSaveParameters:item];
    [_sqliteContext update:tag block:^(FMDatabase *db) {
        flag = [db executeUpdate:_sqlForSave withArgumentsInArray:args];
    }];
    if (ref) {
        [self saveRef:item];
    }
    return flag;
}
-(BOOL)save:(NSString*)tag withList:(NSArray*)items withRef:(BOOL)ref{
    if (!items || items.count == 0) {
        return NO;
    }
    WEAKSELF_DEFINE
    __block BOOL flag = NO;
    [_sqliteContext update:tag block:^(FMDatabase *db) {
        for (id item in items) {
            NSArray* args = [weakSelf buildSaveParameters:item];
            flag = [db executeUpdate:_sqlForSave withArgumentsInArray:args];
        }
    }];
    if (ref) {
        [self saveRefList:items];
    }
    return flag;
}
-(BOOL)save:(NSString*)tag withSet:(NSSet*)items withRef:(BOOL)ref{
    if (!items || items.count == 0) {
        return NO;
    }
    WEAKSELF_DEFINE
    __block BOOL flag = NO;
    [_sqliteContext update:tag block:^(FMDatabase *db) {
        for (id item in items) {
            NSArray* args = [weakSelf buildSaveParameters:item];
            flag = [db executeUpdate:_sqlForSave withArgumentsInArray:args];
        }
    }];
    if (ref) {
        [self saveRefList:[items objectEnumerator].allObjects];
    }
    return flag;
}

#pragma mark - Delete
-(BOOL)removeBy:(id)itemId{
    __block BOOL flag = NO;
    NSString* sql = [NSString stringWithFormat:@"delete from %@ where %@ = ?", _tableName, _pkColumn];
    [_sqliteContext update:@"removeBy" block:^(FMDatabase *db) {
        flag = [db executeUpdate:sql, itemId];
    }];
    return flag;
}
-(BOOL)removeWhere:(NSString*)where withArgs:(NSArray*)args{
    __block BOOL flag = NO;
    NSString* sql = [NSString stringWithFormat:@"delete from %@ where %@", _tableName, where];
    [_sqliteContext update:@"removeWhere" block:^(FMDatabase *db) {
        flag = [db executeUpdate:sql withArgumentsInArray:args];
    }];
    return flag;
}

#pragma mark - Count
-(int)count:(NSString*)tag where:(NSString*)where groupBy:(NSString*)groupBy withArgs:(NSArray*)args{
    NSMutableString* s = [NSMutableString string];
    [s appendFormat:@"select count(1) from %@ ", _tableName];
    if (where) {
        [s appendFormat:@"%@%@", WHERE, where];
    }
    
    if (groupBy) {
        [s appendFormat:@" group by %@", groupBy];
    }
    __block int total = 0;
    [_sqliteContext query:@"count" block:^(FMDatabase *db) {
        FMResultSet* rs = [db executeQuery:s withArgumentsInArray:args];
        while ([rs next]) {
            total = [rs intForColumnIndex:0];
        }
    }];
    return total;
}
-(int)sum:(NSString*)tag where:(NSString*)where groupBy:(NSString*)groupBy withArgs:(NSArray*)args{
    NSMutableString* s = [NSMutableString string];
    [s appendFormat:@"select sum(%@) from %@ ", tag, _tableName];
    if (where) {
        [s appendFormat:@"%@%@", WHERE, where];
    }
    
    if (groupBy) {
        [s appendFormat:@" group by %@", groupBy];
    }
    __block int total = 0;
    [_sqliteContext query:@"sum" block:^(FMDatabase *db) {
        FMResultSet* rs = [db executeQuery:s withArgumentsInArray:args];
        while ([rs next]) {
            total = [rs intForColumnIndex:0];
        }
    }];
    return total;
}
-(id)max:(NSString*)tag where:(NSString*)where groupBy:(NSString*)groupBy withArgs:(NSArray*)args{
    NSMutableString* s = [NSMutableString string];
    [s appendFormat:@"select max(%@) from %@ ", tag, _tableName];
    if (where) {
        [s appendFormat:@"%@%@", WHERE, where];
    }
    
    if (groupBy) {
        [s appendFormat:@" group by %@", groupBy];
    }
    __block id val;
    [_sqliteContext query:@"max" block:^(FMDatabase *db) {
        FMResultSet* rs = [db executeQuery:s withArgumentsInArray:args];
        while ([rs next]) {
            val = [rs objectForColumnIndex:0];
        }
    }];
    return val;
}
-(id)min:(NSString*)tag where:(NSString*)where groupBy:(NSString*)groupBy withArgs:(NSArray*)args{
    NSMutableString* s = [NSMutableString string];
    [s appendFormat:@"select min(%@) from %@ ", tag, _tableName];
    if (where) {
        [s appendFormat:@"%@%@", WHERE, where];
    }
    
    if (groupBy) {
        [s appendFormat:@" group by %@", groupBy];
    }
    __block id val;
    [_sqliteContext query:@"min" block:^(FMDatabase *db) {
        FMResultSet* rs = [db executeQuery:s withArgumentsInArray:args];
        while ([rs next]) {
            val = [rs objectForColumnIndex:0];
        }
    }];
    return val;
}

#pragma mark - Select
-(NSArray*)select:(NSString*)tag where:(NSString*)where order:(NSString*)order withArgs:(NSArray*)args withRef:(BOOL)ref{
    NSMutableString* s = [NSMutableString string];
    [s appendFormat:@"select %@ from %@ ", _selectFields, _tableName];
    if (where) {
        [s appendFormat:@"%@%@", WHERE, where];
    }
    
    if (order) {
        [s appendFormat:@" order by %@", order];
    }
    WEAKSELF_DEFINE
    __block NSMutableArray* val = [NSMutableArray array];
    [_sqliteContext query:@"select" block:^(FMDatabase *db) {
        FMResultSet* rs = [db executeQuery:s withArgumentsInArray:args];
        while ([rs next]) {
            id item = [weakSelf map:rs withItem:nil];
            [val addObject:item];
        }
    }];
    if (ref) {
        [self wrapList:val withRef:ref];
    }
    return val;
}

-(NSArray*)selectLimit:(NSString*)tag where:(NSString*)where order:(NSString*)order withArgs:(NSArray*)args withRef:(BOOL)ref{
    NSMutableString* s = [NSMutableString string];
    [s appendFormat:@"select %@ from %@ ", _selectFields, _tableName];
    if (where) {
        [s appendFormat:@"%@%@", WHERE, where];
    }
    
    if (order) {
        [s appendFormat:@" order by %@", order];
    }
    [s appendString:LIMIT_OFFSET];
    
    WEAKSELF_DEFINE
    __block NSMutableArray* val = [NSMutableArray array];
    [_sqliteContext query:@"selectLimit" block:^(FMDatabase *db) {
        FMResultSet* rs = [db executeQuery:s withArgumentsInArray:args];
        while ([rs next]) {
            id item = [weakSelf map:rs withItem:nil];
            [val addObject:item];
        }
    }];
    if (ref) {
        [self wrapList:val withRef:ref];
    }
    return val;
}

-(NSArray*)selectPks:(NSString*)tag where:(NSString*)where order:(NSString*)order withArgs:(NSArray*)args{
    NSMutableString* s = [NSMutableString string];
    [s appendFormat:@"select %@ from %@ ", _pkColumn, _tableName];
    if (where) {
        [s appendFormat:@"%@%@", WHERE, where];
    }
    
    if (order) {
        [s appendFormat:@" order by %@", order];
    }
    
    __block NSMutableArray* val = [NSMutableArray array];
    [_sqliteContext query:@"selectPks" block:^(FMDatabase *db) {
        FMResultSet* rs = [db executeQuery:s withArgumentsInArray:args];
        while ([rs next]) {
            id item = [rs objectForColumnIndex:0];
            [val addObject:item];
        }
    }];
    return val;
}

#pragma mark - generic
-(void)query:(NSString*)tag sql:(NSString*)sql withArgs:(NSArray*)args block:(void (^)(FMResultSet* rs))block{
    [_sqliteContext query:tag block:^(FMDatabase *db) {
        FMResultSet* rs = [db executeQuery:sql withArgumentsInArray:args];
        while (rs.next) {
            block(rs);
        }
    }];
}
-(void)update:(NSString*)tag sql:(NSString*)sql withArgs:(NSArray*)args{
    [_sqliteContext update:tag block:^(FMDatabase *db) {
        [db executeUpdate:sql withArgumentsInArray:args];
    }];
}

@end
