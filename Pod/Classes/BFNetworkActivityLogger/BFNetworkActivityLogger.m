//
//  BFNetworkActivityLogger.m
//  Organiger
//
//  Created by MaxWellPro on 16/5/17.
//  Copyright © 2016年 QuanYan. All rights reserved.
//

#import "BFNetworkActivityLogger.h"
#import <objc/runtime.h>
#import "AFNetworking.h"

static NSURLRequest * AFNetworkRequestFromNotification(NSNotification *notification) {
    NSURLRequest *request = nil;
    if ([[notification object] respondsToSelector:@selector(originalRequest)]) {
        request = [[notification object] originalRequest];
    } else if ([[notification object] respondsToSelector:@selector(request)]) {
        request = [[notification object] request];
    }
    
    return request;
}

static NSError * AFNetworkErrorFromNotification(NSNotification *notification) {
    NSError *error = nil;
    if ([[notification object] isKindOfClass:[NSURLSessionTask class]]) {
        error = [(NSURLSessionTask *)[notification object] error];
        if (!error) {
            error = notification.userInfo[AFNetworkingTaskDidCompleteErrorKey];
        }
    }
    
    return error;
}

@implementation BFNetworkActivityLogger

+ (instancetype)sharedLogger {
    static BFNetworkActivityLogger *_sharedLogger = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedLogger = [[self alloc] init];
    });
    
    return _sharedLogger;
}

- (id)init {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.level = BFLoggerLevelInfo;
    
    return self;
}

- (void)dealloc {
    [self stopLogging];
}

- (void)startLogging {
    [self stopLogging];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkRequestDidStart:) name:AFNetworkingTaskDidResumeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkRequestDidFinish:) name:AFNetworkingTaskDidCompleteNotification object:nil];
}

- (void)stopLogging {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - NSNotification

static void * AFNetworkRequestStartDate = &AFNetworkRequestStartDate;

- (void)networkRequestDidStart:(NSNotification *)notification {
    NSURLRequest *request = AFNetworkRequestFromNotification(notification);
    
    if (!request) {
        return;
    }
    
    if (request && self.filterPredicate && [self.filterPredicate evaluateWithObject:request]) {
        return;
    }
    
    objc_setAssociatedObject(notification.object, AFNetworkRequestStartDate, [NSDate date], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    NSString *body = nil;
    if ([request HTTPBody]) {
        body = [[NSString alloc] initWithData:[request HTTPBody] encoding:NSUTF8StringEncoding];
    }
    
    switch (self.level) {
        case BFLoggerLevelDebug:
            NSLog(@"\n ===================== HTTP Method ===================== \n %@ \n ===================== HTTP URL ===================== \n '%@': \n ===================== HTTP HeaderFields ===================== \n %@ \n ===================== HTTPBody ===================== \n ===================== Logger End ===================== \n", [request HTTPMethod], [[request URL] absoluteString], [request allHTTPHeaderFields]);
            break;
        case BFLoggerLevelInfo:
            NSLog(@"%@ '%@'", [request HTTPMethod], [[request URL] absoluteString]);
            break;
        default:
            break;
    }
}

- (void)networkRequestDidFinish:(NSNotification *)notification {
    NSURLRequest *request = AFNetworkRequestFromNotification(notification);
    NSURLResponse *response = [notification.object response];
    NSError *error = AFNetworkErrorFromNotification(notification);
    
    if (!request && !response) {
        return;
    }
    
    if (request && self.filterPredicate && [self.filterPredicate evaluateWithObject:request]) {
        return;
    }
    
    NSUInteger responseStatusCode = 0;
    NSDictionary *responseHeaderFields = nil;
    if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
        responseStatusCode = (NSUInteger)[(NSHTTPURLResponse *)response statusCode];
        responseHeaderFields = [(NSHTTPURLResponse *)response allHeaderFields];
    }
    
    id responseObject = notification.userInfo[AFNetworkingTaskDidCompleteSerializedResponseKey];
    if (responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            responseObject = [[NSDictionary alloc] initWithDictionary:responseObject];
        }
        else if ([responseObject isKindOfClass:[NSData class]]) {
            NSStringEncoding stringEncoding = NSUTF8StringEncoding;
            responseObject = [[NSString alloc] initWithData:responseObject encoding:stringEncoding];
        }
    }
    
    NSTimeInterval elapsedTime = [[NSDate date] timeIntervalSinceDate:objc_getAssociatedObject(notification.object, AFNetworkRequestStartDate)];
    
    if (error) {
        switch (self.level) {
            case BFLoggerLevelDebug:
            case BFLoggerLevelInfo:
            case BFLoggerLevelWarn:
            case BFLoggerLevelError:
                NSLog(@"[Error] %@ '%@' (%ld) [%.04f s]: %@", [request HTTPMethod], [[response URL] absoluteString], (long)responseStatusCode, elapsedTime, error);
            default:
                break;
        }
    } else {
        switch (self.level) {
            case BFLoggerLevelDebug:
                NSLog(@"%ld '%@' [%.04f s]: %@ %@", (long)responseStatusCode, [[response URL] absoluteString], elapsedTime, responseHeaderFields, responseObject);
                break;
            case BFLoggerLevelInfo:
                NSLog(@"%ld '%@' [%.04f s]", (long)responseStatusCode, [[response URL] absoluteString], elapsedTime);
                break;
            default:
                break;
        }
    }
}

@end
