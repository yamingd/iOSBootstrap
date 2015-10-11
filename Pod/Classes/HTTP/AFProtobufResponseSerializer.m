//
//  AFProtobufResponseSerializer.m
//  AppBootstrap
//
//  Created by Yaming on 10/2/15.
//  Copyright © 2015 whosbean.com. All rights reserved.
//

#import "AFProtobufResponseSerializer.h"
#import "PAppResponse.pb.h"

@implementation AFProtobufResponseSerializer

- (instancetype)init {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.acceptableContentTypes = [NSSet setWithObjects:X_PROTOBUF, nil];
    
    return self;
}

- (id)responseObjectForResponse:(NSURLResponse *)response
                           data:(NSData *)data
                          error:(NSError *__autoreleasing *)error
{

    if (![self validateResponse:(NSHTTPURLResponse *)response data:data error:error]) {
        return nil;
    }
    
    NSHTTPURLResponse* rsp = (NSHTTPURLResponse*)response;
    
    id xtag = [rsp.allHeaderFields  objectForKey:@"X-tag"];
    if (xtag != nil) {
        NSNumber* count = (NSNumber*)xtag;
        NSUInteger len = [data length];
        char raw[len-count.intValue];
        [data getBytes:raw range:NSMakeRange(count.intValue, len-count.intValue)];
        PAppResponse* resp = [PAppResponse parseFromData:[NSData dataWithBytes:raw length:len-count.intValue]];
        return resp;
    }else{
        PAppResponse* resp = [PAppResponse parseFromData:data];
        return resp;
    }
}

@end
