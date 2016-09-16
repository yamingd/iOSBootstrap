//
//  APIClient.m
//  EnglishCafe
//
//  Created by yaming_deng on 2/5/14.
//  Copyright (c) 2014 www.github.com/yamingd. All rights reserved.
//
#import "APIClient.h"
#import "AppSession.h"
#import "AppSecurity.h"
#import "Utility.h"

@implementation APIClient

+ (instancetype)shared {
    static APIClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[APIClient alloc] init];
    });
    return _sharedClient;
}

+ (NSArray*)dataToClass:(NSArray *)data type:(Class)type{
    NSMutableArray *dslist= [[NSMutableArray alloc] init];
    for (NSData* item in data) {
        id obj = [type parseFromData:item];
        [dslist addObject:obj];
    }
    return dslist;
}

- (instancetype)initWithApiBase:(NSString*)url{
    self.baseUrlString = url;
    return [self initWithBaseURL:[NSURL URLWithString:url]];
}

- (instancetype)initWithBaseURL:(NSURL *)url{
    self = [super initWithBaseURL:url];
    self.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    
    self.responseSerializer = [AFProtobufResponseSerializer serializer];
    [self setHeaderValue:self.requestSerializer];
    
    return self;
}
-(void) setHeaderValue:(AFHTTPRequestSerializer*)req{
    NSDictionary *params = [[AppSession current] header];
    for (NSString* key in params) {
        NSString *sKey = [key description];
        NSString *sVal = [[params objectForKey:key] description];
        //LOG(@"%@=%@", sKey, sVal);
        [req setValue:sVal forHTTPHeaderField:sKey];
    }
    
    [self.requestSerializer setValue:[AppSession current].userAgent forHTTPHeaderField:@"User-Agent"];
    [self.requestSerializer setValue:X_PROTOBUF forHTTPHeaderField:@"Accept"];
}

-(void)resetHeaderValue{
    [self setHeaderValue:self.requestSerializer];
}

-(void)parseError:(NSString*)url error:(NSError *)error block:(void (^)(id response, NSError* error))block{
    LOG(@"Error(%@):%@", url, error);
    PAppResponseBuilder *builder = [PAppResponse builder];
    [builder setCode:(int)error.code];
    if ([error code] == -1001 || [error code] == -1009) {
        [builder setMsg: error.localizedDescription];
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationNetworkError object:nil userInfo:nil];
    }else{
        [builder setMsg: error.localizedDescription];
    }
    if (block) {
        block([builder build], error);
    }
}

-(void)parseData:(id)data block:(void (^)(id response, NSError* error))block{
    NSError* error = nil;
    PAppResponse* resp = (PAppResponse*)data;
    if (resp.code > 200) {
        error = [NSError errorWithDomain:@"APICallError" code:resp.code userInfo:nil];
        block(resp, error);
        if (resp.code == 500) {
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationServerError object:nil userInfo:nil];
        }
    }else{
        block(resp, nil);
    }
}

-(void)encrpyRequestWith:(NSString*)url requestSerializer:(AFHTTPRequestSerializer*) serializer{
    NSString* sign = [[AppSecurity instance] signRequest:url];
    [serializer setValue:sign forHTTPHeaderField:@"X-sign"];
}

-(void) getPath:(NSString *)urlString
       params:(NSDictionary *)params
        withCallback:(void (^)(id response, NSError* error))block{
    
#ifdef DEBUG
    LOG(@"query: %@", urlString);
#endif
    
    [self encrpyRequestWith:urlString requestSerializer:self.requestSerializer];
    
    [self GET:urlString parameters:params success:^(NSURLSessionDataTask * __unused task, id data) {
        [self parseData:data block:block];
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        [self parseError:urlString error:error block:block];
    }];
    
}

-(void) postPath:(NSString *)urlString
           params:(NSDictionary *)params
         formBody:(void (^)(id <AFMultipartFormData> formData))formBody
            withCallback:(void (^)(id response, NSError* error))block{
#ifdef DEBUG
    LOG(@"postPath: %@", urlString);
#endif
    
    [self encrpyRequestWith:urlString requestSerializer:self.requestSerializer];
    
    if (formBody) {
        
        [self POST:urlString parameters:params constructingBodyWithBlock:formBody success:^(NSURLSessionDataTask *task, id data) {
            [self parseData:data block:block];
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            [self parseError:urlString error:error block:block];
        }];
        
    } else{
        
        [self POST:urlString parameters:params success:^(NSURLSessionDataTask *task, id data) {
            [self parseData:data block:block];
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            [self parseError:urlString error:error block:block];
        }];
        
    }
    
}

-(void) deletePath:(NSString *)urlString
            params:(NSDictionary *)params
             withCallback:(void (^)(id response, NSError* error))block{
    
    [self encrpyRequestWith:urlString requestSerializer:self.requestSerializer];
    
    [self DELETE:urlString parameters:params success:^(NSURLSessionDataTask *task, id data) {
        [self parseData:data block:block];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self parseError:urlString error:error block:block];
    }];
    
}

-(void) putPath:(NSString *)urlString
         params:(NSDictionary *)params
          withCallback:(void (^)(id response, NSError* error))block{
    
    [self encrpyRequestWith:urlString requestSerializer:self.requestSerializer];
    
    [self PUT:urlString parameters:params success:^(NSURLSessionDataTask *task, id data) {
        [self parseData:data block:block];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self parseError:urlString error:error block:block];
    }];
    
}

-(void) patchPath:(NSString *)urlString
         params:(NSDictionary *)params
          withCallback:(void (^)(id response, NSError* error))block{
    
    [self encrpyRequestWith:urlString requestSerializer:self.requestSerializer];
    
    [self PATCH:urlString parameters:params success:^(NSURLSessionDataTask *task, id data) {
        [self parseData:data block:block];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self parseError:urlString error:error block:block];
    }];
    
}

-(void)test{
    
}

-(NSURLSessionDownloadTask*)download:(NSString*)urlString
                          filePath:(NSString *)filePath
                           process:(void (^)(long long readBytes, long long totalBytes))process
                          complete:(void (^)(BOOL successed, NSURL *filePath))complete{
#ifdef DEBUG
    LOG(@"download: %@", urlString);
#endif
    
    if ([urlString hasPrefix:@"http://"] || [urlString hasPrefix:@"https://"]) {
        
    }else{
        [self encrpyRequestWith:urlString requestSerializer:self.requestSerializer];
        urlString = [NSString stringWithFormat:@"%@%@", self.baseUrlString, urlString];
    }
    
    NSURL *URL = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSessionDownloadTask *downloadTask = [self downloadTaskWithRequest:request
                                                                  progress:nil
                                                               destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
                                                                   if (filePath) {
                                                                       return [NSURL URLWithString:filePath];
                                                                   }
                                                                   
        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory
                                                                              inDomain:NSUserDomainMask
                                                                     appropriateForURL:nil
                                                                                create:NO
                                                                                 error:nil];
                                                                   
        return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
                                                                   
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {

        if (error) {
            LOG(@"File download Error: %@, %@", urlString, error);
            if (complete) {
                complete(NO, nil);
            }
        }else{
            if (complete) {
                complete(YES, filePath);
            }
        }
        
    }];
    
    [self setDownloadTaskDidWriteDataBlock:^(NSURLSession *session, NSURLSessionDownloadTask *downloadTask,
                                             int64_t bytesWritten, int64_t totalBytesWritten, int64_t totalBytesExpectedToWrite) {

        if (process) {
            process(totalBytesWritten, totalBytesExpectedToWrite);
        }
        
    }];
    
    [downloadTask resume];
    
    return downloadTask;
    
}

-(NSURLSessionDownloadTask*)downloadNSData:(NSString*)urlString
                                 process:(void (^)(long long readBytes, long long totalBytes))process
                                complete:(void (^)(BOOL successed, NSData* data))complete{
    

#ifdef DEBUG
    LOG(@"download: %@", urlString);
#endif
    
    if ([urlString hasPrefix:@"http://"] || [urlString hasPrefix:@"https://"]) {
        
    }else{
        [self encrpyRequestWith:urlString requestSerializer:self.requestSerializer];
        urlString = [NSString stringWithFormat:@"%@%@", self.baseUrlString, urlString];
    }
    
    NSURL *URL = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSessionDownloadTask *downloadTask = [self downloadTaskWithRequest:request
                                                                  progress:nil
                                                               destination:nil
                                                         completionHandler:^(NSURLResponse *response, id data, NSError *error) {
                                                                   
                                                                   if (error) {
                                                                       LOG(@"File download Error: %@, %@", urlString, error);
                                                                       if (complete) {
                                                                           complete(NO, nil);
                                                                       }
                                                                   }else{
                                                                       if (complete) {
                                                                           complete(YES, data);
                                                                       }
                                                                   }
                                                                   
                                                               }];
    
    [self setDownloadTaskDidWriteDataBlock:^(NSURLSession *session, NSURLSessionDownloadTask *downloadTask,
                                             int64_t bytesWritten, int64_t totalBytesWritten, int64_t totalBytesExpectedToWrite) {
        
        if (process) {
            process(totalBytesWritten, totalBytesExpectedToWrite);
        }
        
    }];
    
    [downloadTask resume];
    
    return downloadTask;
    
}


-(NSString *)formatUrl:(NSString *)url args:(NSDictionary *)args{
    if (url == nil || url.length == 0) {
        return nil;
    }
    if ([url hasPrefix:@"http://"] || [url hasPrefix:@"https://"]) {
        return url;
    }

    if (args != nil) {
        url = [Utility addQueryStringToUrl:url params:args];
    }
    
    url = [NSString stringWithFormat:@"%@%@", self.baseUrlString, url];
    return url;
}

@end
