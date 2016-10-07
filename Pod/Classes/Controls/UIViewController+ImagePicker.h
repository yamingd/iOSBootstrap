//
//  UIViewController+ImagePicker.h
//  k12
//
//  Created by Yaming on 3/13/15.
//  Copyright (c) 2015 www.github.com/yamingd. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ImagePickerDelegate <NSObject>

-(void)imagePickerDidSelecteImages:(NSArray*)images;

@end

@interface UIViewController(ImagePicker) <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

-(void)openImageSelectViews;

- (BOOL)isHasCamera;

@end
