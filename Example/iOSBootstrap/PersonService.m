//
//  PersonService.m
//  iOSBootstrap
//
//  Created by Yaming on 10/7/15.
//  Copyright © 2015 Yaming. All rights reserved.
//

#import "PersonService.h"

@implementation PersonService

#pragma mark - Query/Find

+(void)findLatest:(long)cursorId withCallback:(APIResponseBlock)block{
    NSArray* list = [[PBPersonMapper instance] selectLimit:@"findLatest" where:@"id > ?" order:@"id desc" withArgs:@[@(cursorId), kListPageSize, @(0)] withRef:YES];
    if (list.count > 0) {
        block(list, nil, YES);
        if (list.count == kListPageSize) {
            return;
        }
    }
    
    NSString* url = [NSString stringWithFormat:@"/persons/1/%ld", cursorId];
    [[APIClient shared] getPath:url params:nil withCallback:^(PAppResponse* response, NSError *error) {
        if (error) {
            block(nil, error, NO);
        }else{
            NSArray* items = [APIClient dataToClass:response.data type:[PBPerson class]];
            if (items.count > 0) {
                [[PBPersonMapper instance] save:@"findLatest" withList:items withRef:YES];
            }
            block(items, error, NO);
        }
    }];
}

// 读取更多的(page从2开始)
+(void)findMore:(int)page cursorId:(long)cursorId withCallback:(APIResponseBlock)block{
    
    NSArray* list = [[PBPersonMapper instance] selectLimit:@"findMore" where:@"id < ?" order:@"id desc" withArgs:@[@(cursorId), kListPageSize, @(0)] withRef:YES];
    if (list.count > 0) {
        block(list, nil, YES);
        if (list.count == kListPageSize) {
            return;
        }
    }
    
    NSString* url = [NSString stringWithFormat:@"/persons/%d/%ld", page, cursorId];
    [[APIClient shared] getPath:url params:nil withCallback:^(PAppResponse* response, NSError *error) {
        if (error) {
            block(nil, error, NO);
        }else{
            NSArray* items = [APIClient dataToClass:response.data type:[PBPerson class]];
            if (items.count > 0) {
                [[PBPersonMapper instance] save:@"findMore" withList:items withRef:YES];
            }
            block(items, error, NO);
        }
    }];
}

// 主键查找
+(void)findBy:(long)itemId withRef:(BOOL)withRef withCallback:(APIResponseBlock*)block{
    //1. 从本地读
    PBPerson* person = [[PBPersonMapper instance] get:itemId withRef:withRef];
    if (person) {
        block(person, nil, YES);
        return;
    }
    
    [self loadBy:itemId withCallback:block];
}

// 从服务器读取
+(void)loadBy:(long)itemId withCallback:(APIResponseBlock*)block{
    
    //2. 从服务器读
    NSString* url = [NSString stringWithFormat:@"/persons/%ld", itemId];
    [[APIClient shared] getPath:url params:nil withCallback:^(PAppResponse* response, NSError *error) {
        if (error) {
            block(nil, error, NO);
        }else{
            NSArray* items = [APIClient dataToClass:response.data type:[PBPerson class]];
            PBPerson* person = nil;
            if (items.count > 0) {
                person = items.firstObject;
                [[PBPersonMapper instance] save:@"findBy" withItem:person withRef:YES];
            }
            block(person, error, NO);
        }
    }];
    
}

#pragma mark - Create

// 新建
+(void)create:(PBPerson*)item withCallback:(APIResponseBlock)block{
    
    //1. 写入服务器，并返回
    NSString* url = @"/persons/";
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    BOOL hasFile = NO;
    if (hasFile) {
        [[APIClient shared] postPath:url params:params formBody:^(id<AFMultipartFormData> formData) {
            
        } withCallback:^(id response, NSError *error) {
            [self parseCreateReponse:response error:error withCallback:block];
        }];
    }else{
        [[APIClient shared] postPath:url params:params formBody:nil withCallback:^(id response, NSError *error) {
            [self parseCreateReponse:response error:error withCallback:block];
        }];
    }
}

+(void)parseCreateReponse:(id)response error:(NSError*)error withCallback:(APIResponseBlock)block{
    if (error) {
        block(nil, error, NO);
    }else{
        NSArray* items = [APIClient dataToClass:response.data type:[PBPerson class]];
        PBPerson* person = nil;
        if (items.count > 0) {
            person = items.firstObject;
            [[PBPersonMapper instance] save:@"save" withItem:person withRef:YES];
        }
        block(person, error, NO);
    }
}

// 更新
+(void)save:(PBPerson*)item withCallback:(APIResponseBlock)block{
    
    //1. 写入服务器，并返回
    NSString* url = [NSString stringWithFormat:@"/persons/%ld", item.id];
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    BOOL hasFile = NO;
    if (hasFile) {
        [[APIClient shared] postPath:url params:params formBody:^(id<AFMultipartFormData> formData) {
            
        } withCallback:^(PAppResponse* response, NSError *error) {
            [self parseCreateReponse:response error:error withCallback:block];
        }];
    }else{
        [[APIClient shared] putPath:url params:params withCallback:^(PAppResponse* response, NSError *error) {
            [self parseCreateReponse:response error:error withCallback:block];
        }];
    }
}

#pragma mark - Remove

// 删除
+(void)remove:(PBPerson*)item withCallback:(APIResponseBlock)block{
    
    //1. 写入服务器，并返回
    NSString* url = [NSString stringWithFormat:@"/persons/%ld", item.id];
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    [[APIClient shared] deletePath:url params:params withCallback:^(PAppResponse* response, NSError *error) {
        if (error) {
            block(nil, error, NO);
        }else{
            if (response.code == 200) {
                [[PBPersonMapper instance] removeBy:item.id];
            }
            block(response, error, NO);
        }
    }];
}

@end
