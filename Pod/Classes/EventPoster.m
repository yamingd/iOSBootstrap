//
//  EventPoster.m
//  Pods
//
//  Created by Yaming on 10/7/15.
//
//

#import "EventPoster.h"
#import "boost.h"

@implementation EventPoster

+ (void)send:(NSString*)name userInfo:(NSDictionary*)userInfo{
    dispatch_main_async_safe(^{
        [[NSNotificationCenter defaultCenter] postNotificationName:name object:nil userInfo:userInfo];
    });
}

@end
