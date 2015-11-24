//
//  AFProtobufResponseSerializer.h
//  AppBootstrap
//
//  Created by Yaming on 10/2/15.
//  Copyright © 2015 www.github.com/yamingd. All rights reserved.
//

#import "AFURLResponseSerialization.h"

#define X_PROTOBUF @"application/x-protobuf"

@interface AFProtobufResponseSerializer : AFHTTPResponseSerializer

- (instancetype) init;

@end
