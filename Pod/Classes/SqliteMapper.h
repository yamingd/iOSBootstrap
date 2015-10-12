//
//  SqliteMapper.h
//  Pods
//
//  Created by Yaming on 10/6/15.
//
//

#import <Foundation/Foundation.h>

#import "FMDB.h"
#import "SqliteContext.h"

#define S_COMMOA @", "
#define S_QMARK @"?, "
#define S_OR @" OR "
#define S_AND @" AND "
#define S_E_Q @" = ? "
#define SELECT @"select "
#define FROM @" from "
#define ORDER_BY @" order by "
#define WHERE @" where "
#define LIMIT_OFFSET @" limit ? offset ?"
#define DELETE_FROM @"delete from "
#define UPDATE @"update "
#define SET @" set "
#define S_EMPTY @" "
#define STRING_NULL @""
#define DESC @" desc "
#define CREATE @"create table if not exists %@(%@) WITHOUT ROWID;"
#define INSERT @"REPLACE into %@(%@)values(%@)"

@interface SqliteMapper : NSObject

@property(nonatomic, strong, readonly)NSString* pkColumn;
@property(nonatomic, strong, readonly)NSString* tableName;
@property(nonatomic, strong, readonly)NSString* createTableSql;
@property(nonatomic, strong, readonly)NSDictionary* tableColumns;
@property(nonatomic, strong, readonly)NSArray* columns;
@property(nonatomic, strong, readonly)SqliteContext* sqliteContext;

#pragma mark - Public

+(instancetype)instance;

-(void)prepare;
-(void)ensureContext;
-(NSString*)filterNull:(NSString*)val;

#pragma mark - Set
-(void)setTableName:(NSString *)tableName;
-(void)setTableColumns:(NSDictionary *)tableColumns;
-(void)setSqliteContext:(SqliteContext *)sqliteContext;
-(void)setPkColumn:(NSString *)pkColumn;
-(void)setColumns:(NSArray *)columns;

#pragma mark - Get
-(id)get:(id)pkValue withRef:(BOOL)ref;
-(NSArray*)gets:(NSString*)tag withArray:(NSArray*)pkValues withRef:(BOOL)ref;
-(NSArray*)gets:(NSString*)tag withSet:(NSSet*)pkValues withRef:(BOOL)ref;
-(NSArray*)gets:(NSString*)tag withComma:(NSString*)pkValues withRef:(BOOL)ref;

#pragma mark - Save
-(NSArray*)buildSaveParameters:(id)item;
-(BOOL)save:(NSString*)tag withItem:(id)item withRef:(BOOL)ref;
-(BOOL)save:(NSString*)tag withList:(NSArray*)items withRef:(BOOL)ref;
-(BOOL)save:(NSString*)tag withSet:(NSSet*)items withRef:(BOOL)ref;

#pragma mark - Delete
-(BOOL)removeBy:(id)itemId;
-(BOOL)removeWhere:(NSString*)where withArgs:(NSArray*)args;

#pragma mark - Count
-(int)count:(NSString*)tag where:(NSString*)where groupBy:(NSString*)groupBy withArgs:(NSArray*)args;
-(int)sum:(NSString*)tag where:(NSString*)where groupBy:(NSString*)groupBy withArgs:(NSArray*)args;
-(id)max:(NSString*)tag where:(NSString*)where groupBy:(NSString*)groupBy withArgs:(NSArray*)args;
-(id)min:(NSString*)tag where:(NSString*)where groupBy:(NSString*)groupBy withArgs:(NSArray*)args;

#pragma mark - Select
-(NSArray*)select:(NSString*)tag where:(NSString*)where order:(NSString*)order withArgs:(NSArray*)args withRef:(BOOL)ref;
-(NSArray*)selectLimit:(NSString*)tag where:(NSString*)where order:(NSString*)order withArgs:(NSArray*)args withRef:(BOOL)ref;
-(NSArray*)selectPks:(NSString*)tag where:(NSString*)where order:(NSString*)order withArgs:(NSArray*)args;

#pragma mark - Wrap
-(void)wrap:(id)item withRef:(BOOL)ref;
-(void)wrapList:(NSArray*)items withRef:(BOOL)ref;
-(void)saveRef:(id)item;
-(void)saveRefList:(NSArray*)items;

#pragma mark - ResultSet

-(id)map:(FMResultSet*)rs withItem:(id)item;

#pragma mark - generic
-(void)query:(NSString*)tag sql:(NSString*)sql withArgs:(NSArray*)args block:(void (^)(FMResultSet* rs))block;
-(void)update:(NSString*)tag sql:(NSString*)sql withArgs:(NSArray*)args;

@end
