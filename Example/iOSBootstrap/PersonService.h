//
//  PersonService.h
//  iOSBootstrap
//
//  Created by Yaming on 10/7/15.
//  Copyright © 2015 Yaming. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "APIClient.h"
#import "PBPerson.h"
#import "PBPersonMapper.h"

@interface PersonService : NSObject

#pragma mark - Query/Find

// 读取最新的
+(void)findLatest:(long)cursorId withCallback:(APIResponseBlock)block;

// 读取更多的(page从2开始)
+(void)findMore:(int)page cursorId:(long)cursorId withCallback:(APIResponseBlock)block;

// 主键查找
+(void)findBy:(long)itemId withRef:(BOOL)withRef withCallback:(APIResponseBlock*)block;

// 从服务器读取
+(void)loadBy:(long)itemId withCallback:(APIResponseBlock*)block;

#pragma mark - Create

// 新建
+(void)create:(PBPerson*)item withCallback:(APIResponseBlock)block;
// 更新
+(void)save:(PBPerson*)item withCallback:(APIResponseBlock)block;

#pragma mark - Remove

// 删除
+(void)remove:(PBPerson*)item withCallback:(APIResponseBlock)block;


@end
