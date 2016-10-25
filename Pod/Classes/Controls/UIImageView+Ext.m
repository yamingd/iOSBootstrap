//
//  UIImageView+Ext.m
//  EnglishCafe
//  https://github.com/rs/SDWebImage
//  Created by yaming_deng on 14/5/14.
//  Copyright (c) 2014 www.github.com/yamingd. All rights reserved.
//

#import "UIImageView+Ext.h"

@implementation UIImageView (Ext)

- (void)setImageWith:(NSString *)urlOrName
         placeholder:(NSString *)holderName{
    
    UIImage* holder = nil;
    if (holderName) {
        holder = [UIImage imageNamed:holderName];
    }
    if (urlOrName.length == 0) {
        [self setImage:holder];
        return;
    }
    if ([urlOrName hasPrefix:@"http://"]) {
        [self sd_setImageWithURL:[NSURL URLWithString:urlOrName] placeholderImage:holder options:SDWebImageProgressiveDownload];
    }else{
        [self setImage:[UIImage imageNamed:urlOrName]];
    }
    
}

- (void)setImageWithHolder:(NSString *)urlOrName
               placeholder:(UIImage *)holder{
    
    if (urlOrName.length == 0) {
        [self setImage:holder];
        return;
    }
    if ([urlOrName hasPrefix:@"http://"]) {
        [self sd_setImageWithURL:[NSURL URLWithString:urlOrName] placeholderImage:holder options:SDWebImageProgressiveDownload];
    }else{
        [self setImage:[UIImage imageNamed:urlOrName]];
    }
}

- (void)setImageWith:(NSString *)urlOrName
         placeholder:(NSString *)holderName
           completed:(SDWebImageCompletionBlock)completedBlock{
    
    
    UIImage* holder = nil;
    if (holderName) {
        holder = [UIImage imageNamed:holderName];
    }
    if (urlOrName.length == 0) {
        [self setImage:holder];
        return;
    }
    if ([urlOrName hasPrefix:@"http://"]) {
        [self sd_setImageWithURL:[NSURL URLWithString:urlOrName] placeholderImage:holder options:SDWebImageProgressiveDownload completed:completedBlock];
    }else{
        [self setImage:[UIImage imageNamed:urlOrName]];
    }
    
}

- (void)circleCover
{
    [self roundCover:CGRectGetWidth(self.frame)/2];
}

- (void)roundCover:(float)radius{
    CALayer * layer = [self layer];
    [layer setMasksToBounds:YES];
    [layer setCornerRadius:radius];
}

@end
