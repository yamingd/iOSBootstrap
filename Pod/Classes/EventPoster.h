//
//  EventPoster.h
//  Pods
//
//  Created by Yaming on 10/7/15.
//
//

#import <Foundation/Foundation.h>

@interface EventPoster : NSObject

+ (void)send:(NSString*)name userInfo:(NSDictionary*)userInfo;

@end
