//
//  FMEncryptDatabase.h
//
//

#import "FMDB.h"

@interface FMEncryptDatabase : FMDatabase

+ (instancetype)databaseWithPath:(NSString*)aPath encryptKey:(NSData *)encryptKey;

- (instancetype)initWithPath:(NSString*)aPath encryptKey:(NSData *)encryptKey;

@end
