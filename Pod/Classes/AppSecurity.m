//
//  AppSecurity.m
//  AppBootstrap
//
//  Created by Yaming on 10/2/15.
//  Copyright © 2015 whosbean.com. All rights reserved.
//

#import "boost.h"
#import "AppSecurity.h"
#import <CommonCrypto/CommonCryptor.h>
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonHMAC.h>
#import "NSString+Ext.h"
#import "PAppSession.pb.h"
#import "AppSession.h"

static NSString* digits = @"0123456789abcdef";
static const char chars[] = "1234567890abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLOMNOPQRSTUVWXYZ";

@interface AppSecurity ()

@property(strong, nonatomic) NSString* aesSalt;
@property(strong, nonatomic) NSString* aesIV;

@end

@implementation AppSecurity

+ (instancetype)instance {
    static AppSecurity *_shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shared = [[AppSecurity alloc] init];
    });
    return _shared;
}

-(void)config:(NSString*)cookieId salt:(NSString*)salt aesSeed:(NSString*)aesSeed{
    _cookieId = cookieId;
    _cookieSalt = salt;
    _aesSeed = aesSeed;
    
    NSString* tmp = [AppSecurity md5:aesSeed encoding:NSUTF8StringEncoding];
    char chars[16];
    
    for (int i=0; i<16; i++) {
        chars[i] = [tmp characterAtIndex:i * 2];
    }
    _aesSalt = [[NSString alloc] initWithBytes:chars length:16 encoding:NSUTF8StringEncoding];
    
    for (int i=0; i<16; i++) {
        chars[i] = [tmp characterAtIndex:i * 2 + 1];
    }
    _aesIV = [[NSString alloc] initWithBytes:chars length:16 encoding:NSUTF8StringEncoding];
}

-(NSDictionary*)signSession:(PAppSession*)session{
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:session.sessionId forKey:@"X-sessionid"];
    [dict setValue:session.appName forKey:@"X-app"];
    [dict setValue:session.deviceId forKey:@"X-cid"];
    [dict setValue:session.packageVersion forKey:@"X-ver"]; //客户端版本标示，用于跟踪使用情况
    [dict setValue:session.localeIdentifier forKeyPath:@"x-lang"];
    
    //cookie
    NSString* cookieSecret = [AppSecurity md5:self.cookieSalt encoding:NSUTF8StringEncoding];
    NSString* timestamp = [NSString stringWithFormat:@"%f", [[NSDate date] timeIntervalSince1970]];
    NSData* ds = [[[NSNumber numberWithBool:session.userId] stringValue] dataUsingEncoding:NSUTF8StringEncoding];
    NSString* uv = [NSString base64StringFromData:ds length:ds.length];
    //uv = [Utility urlEscape:uv];
    //LOG(@"uv:%@", uv);
    timestamp = [[timestamp componentsSeparatedByString:@"."] objectAtIndex:0];
    //LOG(@"timestamp:%@", timestamp);
    //LOG(@"secret:%@", secret);
    NSString* sign = [NSString stringWithFormat:@"%@|%@|%@|%@", timestamp, cookieSecret, self.cookieId, uv];
    sign = [AppSecurity SHA256Hash:sign encoding:NSUTF8StringEncoding];
    //LOG(@"sign:%@", sign);
    sign = [NSString stringWithFormat:@"%@|%@|%@", uv, timestamp, sign];
    LOG(@"x-auth:%@", sign);
    [dict setValue:sign forKey:@"X-auth"];
    //LOG(@"header: %@", dict);
    return dict;
    
}

+(NSString*)md5:(NSString*)raw encoding:(NSStringEncoding)encoding
{
    NSData* ds = [raw dataUsingEncoding:encoding];
    
    unsigned char hash[CC_MD5_DIGEST_LENGTH];
    (void) CC_MD5( [ds bytes], (CC_LONG)[ds length], hash );
    ds = ([NSData dataWithBytes: hash length: CC_MD5_DIGEST_LENGTH]);
    
    return [AppSecurity dataHex:ds];
}

+(NSString*)SHA256Hash:(NSString*)raw encoding:(NSStringEncoding)encoding
{
    NSData* ds = [raw dataUsingEncoding:encoding];
    
    unsigned char hash[CC_SHA256_DIGEST_LENGTH];
    (void) CC_SHA256( [ds bytes], (CC_LONG)[ds length], hash );
    ds = ( [NSData dataWithBytes: hash length: CC_SHA256_DIGEST_LENGTH] );
    
    return [AppSecurity dataHex:ds];
}

+(NSString*)randomCode{
    //数字: 48-57
    //小写字母: 97-122
    //大写字母: 65-90
    int len = 10;
    char codes[len];
    
    for(int i=0;i<len; i++){
        codes[i]= chars[arc4random()%62];
    }
    
    NSString *text = [[NSString alloc] initWithBytes:codes length:len encoding:NSUTF8StringEncoding];
    return text;
}

-(NSString*)signRequest:(NSString*)url {
    NSRange range;
    range = [url rangeOfString:@"?"];
    if (range.location != NSNotFound) {
        url = [url substringToIndex:range.location];
    }
    
    NSString* key = [AppSecurity randomCode];
    NSString* md5key = [AppSecurity md5:key encoding:NSASCIIStringEncoding];
    
    NSString* data = [NSString stringWithFormat:@"%@|%lld|%@|%@|%@", md5key, [AppSession current].session.userId, url, self.cookieSalt, self.cookieId];
    
    //LOG(@"data: %@", data);
    
    NSString* sign = [AppSecurity SHA256Hash:data encoding:NSASCIIStringEncoding];
    
    sign = [NSString stringWithFormat:@"%@%@", key, sign];
    
    return sign;
}

-(NSString*)aes128Encrypt:(NSString*)text{
    
    char keyPtr[kCCKeySizeAES128+1];
    memset(keyPtr, 0, sizeof(keyPtr));
    [_aesSalt getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    char ivPtr[kCCBlockSizeAES128+1];
    memset(ivPtr, 0, sizeof(ivPtr));
    [_aesIV getCString:ivPtr maxLength:sizeof(ivPtr) encoding:NSUTF8StringEncoding];
    
    NSData* data = [text dataUsingEncoding:NSUTF8StringEncoding];
    NSUInteger dataLength = [data length];
    
    long diff = kCCKeySizeAES128 - (dataLength % kCCKeySizeAES128);
    long newSize = dataLength;
    
    if(diff > 0)
    {
        newSize = dataLength + diff;
    }
    
    // padding
    char dataPtr[newSize];
    memcpy(dataPtr, [data bytes], [data length]);
    for(int i = 0; i < diff; i++)
    {
        dataPtr[i + dataLength] = 0x00;
    }
    
    size_t bufferSize = newSize + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    memset(buffer, 0, bufferSize);
    
    size_t numBytesCrypted = 0;
    
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt,
                                          kCCAlgorithmAES,
                                          0x0000,
                                          keyPtr,
                                          kCCKeySizeAES128,
                                          ivPtr,
                                          dataPtr,
                                          sizeof(dataPtr),
                                          buffer,
                                          bufferSize,
                                          &numBytesCrypted);
    
    if (cryptStatus == kCCSuccess) {
        NSData *resultData = [NSData dataWithBytesNoCopy:buffer length:numBytesCrypted];
        return [AppSecurity dataHex:resultData];
    }
    free(buffer);
    return nil;
}

+ (NSString*)dataHex:(NSData *)data{
    /* Returns hexadecimal string of NSData. Empty string if data is empty.   */
    const unsigned char *dataBuffer = (const unsigned char *)[data bytes];
    if (!dataBuffer){
        return [NSString string];
    }
    
    NSUInteger          dataLength  = [data length];
    NSMutableString     *hexString  = [NSMutableString stringWithCapacity:(dataLength * 2)];
    
    for (int i = 0; i < dataLength; ++i){
        [hexString appendFormat:@"%02x", (unsigned int)dataBuffer[i]];
    }
    //LOG(@"hexString: %@", hexString);
    return [NSString stringWithString:hexString];
}

+ (int)hexInt:(char)c{
    for (int i=0; i<16; i++) {
        if ([digits characterAtIndex:i] == c) {
            return i;
        }
    }
    return -1;
}

+ (NSData*)hexDecode:(NSData*)tmp{
    //hex to char
    char raw[tmp.length];
    unsigned char encrypted[tmp.length/2];
    
    [tmp getBytes:raw length:tmp.length];
    for (int i=0, j=0; i<tmp.length/2; i++) {
        
        char c0 = raw[j];
        j += 1;
        char c1 = raw[j];
        j += 1;
        
        int f = [self hexInt:c0] << 4;
        f = f | [self hexInt:c1];
        
        encrypted[i] = f & 0xFF;
    }
    //
    tmp = [NSData dataWithBytes:encrypted length:tmp.length/2];
    return tmp;
}

-(NSString*)aes128Decrypt:(NSString*)text{
    
    NSData* data = [text dataUsingEncoding:NSASCIIStringEncoding];
    //hex to char
    data = [AppSecurity hexDecode:data];
    
    char keyPtr[kCCKeySizeAES128 + 1];
    memset(keyPtr, 0, sizeof(keyPtr));
    [_aesSalt getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    char ivPtr[kCCBlockSizeAES128 + 1];
    memset(ivPtr, 0, sizeof(ivPtr));
    [_aesIV getCString:ivPtr maxLength:sizeof(ivPtr) encoding:NSUTF8StringEncoding];
    
    NSUInteger dataLength = [data length];
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    
    size_t numBytesCrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt,
                                          kCCAlgorithmAES128,
                                          0x0000,
                                          keyPtr,
                                          kCCBlockSizeAES128,
                                          ivPtr,
                                          [data bytes],
                                          dataLength,
                                          buffer,
                                          bufferSize,
                                          &numBytesCrypted);
    
    if (cryptStatus == kCCSuccess) {
        NSData *resultData = [NSData dataWithBytesNoCopy:buffer length:numBytesCrypted];
        NSString* str = [[NSString alloc] initWithData:resultData encoding:NSUTF8StringEncoding];
        for (int i=0; i<str.length; i++) {
            unichar c = [str characterAtIndex:i];
            if (c == 0) {
                str = [str substringToIndex:i];
                break;
            }
        }
        return str;
    }
    
    free(buffer);
    return nil;
    
}

@end
