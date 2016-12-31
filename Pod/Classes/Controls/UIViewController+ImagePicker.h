//
//  UIViewController+ImagePicker.h
//  k12
//
//  Created by Yaming on 3/13/15.
//  Copyright (c) 2015 www.github.com/yamingd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <objc/runtime.h>

@protocol ImagePickerDelegate <NSObject>

- (void)imagePickerDidSelecteImages:(NSArray*)images;

@optional

- (void)pickerConfigController:(UIImagePickerController*)controller;

@end

@interface UIViewController(ImagePicker) <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (strong, nonatomic) NSString* pickerTag;

- (void)openImageSelectViews:(UIView*)sender;

- (BOOL)isHasCamera;

@end
