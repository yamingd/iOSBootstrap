//
//  PBMapperInit.m
//  iOSBootstrap
//
//  Created by Yaming on 10/7/15.
//  Copyright © 2015 Yaming. All rights reserved.
//

#import "PBMapperInit.h"

@implementation PBMapperInit

+(instancetype)instance{
    static PBMapperInit *_shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shared = [[PBMapperInit alloc] init];
    });
    return _shared;
}

-(instancetype)init{
    self = [super init];
    return self;
}

-(void)start{
    
}

@end
