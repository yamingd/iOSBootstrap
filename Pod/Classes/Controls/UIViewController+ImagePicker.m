//
//  UIViewController+ImagePicker.m
//  k12
//
//  Created by Yaming on 3/13/15.
//  Copyright (c) 2015 www.github.com/yamingd. All rights reserved.
//

#import "UIViewController+ImagePicker.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>
#import "boost.h"
#import "DeviceHelper.h"

@implementation UIViewController(ImagePicker)

- (BOOL)isHasCamera
{
    return ([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear] || [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront]);
}

-(void)openImageSelectViews
{
    //选择头像
    UIActionSheet *actionSheet = nil;
    if ([self isHasCamera]) {
        actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                  delegate:self
                                         cancelButtonTitle:@"取消"
                                    destructiveButtonTitle:nil
                                         otherButtonTitles:@"拍照", @"从手机相册选择", nil];
    } else {
        actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                  delegate:self
                                         cancelButtonTitle:@"取消"
                                    destructiveButtonTitle:nil
                                         otherButtonTitles:@"从手机相册选择", nil];
    }
    if(actionSheet)
    {
        [actionSheet showInView:self.view];
    }
}

#pragma mark - UIActionSheetDelegate

- (BOOL)assertAuthIsAvailible:(UIImagePickerControllerSourceType)type
{
    NSString* title = [DeviceHelper getAppName];
    
    if (type == UIImagePickerControllerSourceTypePhotoLibrary) {
        ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
        if(author == ALAuthorizationStatusRestricted || author == ALAuthorizationStatusDenied){
            NSString* msg = [NSString stringWithFormat:@"请到 “设置－%@－照片” 选项中，允许%@访问您手机的照片。", title, title];
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"无法选择照片" message:msg delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil];
            [av show];
            return NO;
        }
    } else if (type == UIImagePickerControllerSourceTypeCamera) {
        NSString *mediaType = AVMediaTypeVideo;
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
        if(authStatus == ALAuthorizationStatusRestricted || authStatus == ALAuthorizationStatusDenied){
            NSString* msg = [NSString stringWithFormat:@"请到 “设置－%@－相机” 选项中，允许%@访问您手机的相机。", title, title];
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"无法拍照" message:msg delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil];
            [av show];
            return NO;
        }
    }
    return YES;
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == actionSheet.cancelButtonIndex) {
        return;
    } else if (buttonIndex == actionSheet.destructiveButtonIndex) {
        return;
    }
    
    WEAKSELF_DEFINE
    
    // 访问权限判断
    if (buttonIndex == actionSheet.firstOtherButtonIndex && [weakSelf isHasCamera]) {
        if (![self assertAuthIsAvailible:UIImagePickerControllerSourceTypeCamera]) {
            return;
        }
    } else {
        if (![self assertAuthIsAvailible:UIImagePickerControllerSourceTypePhotoLibrary]) {
            return;
        }
    }
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = weakSelf;
    imagePicker.allowsEditing = YES;
    imagePicker.view.backgroundColor = [UIColor clearColor];
    
    if (buttonIndex == actionSheet.firstOtherButtonIndex && [weakSelf isHasCamera]) {
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker.cameraDevice = UIImagePickerControllerCameraDeviceFront;
    } else {
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [weakSelf presentViewController:imagePicker animated:YES completion:NULL];
    }];
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *selectedImage = [info objectForKey:UIImagePickerControllerEditedImage];
//    NSData* imgData = UIImageJPEGRepresentation(selectedImage, 1.0);
    NSData* imgData = [self compressImage:selectedImage compressRatio:.7 maxCompressRatio:.5];
    NSString* iconName = [NSString stringWithFormat:@"%ld.jpeg", [NSNumber numberWithDouble:[NSDate date].timeIntervalSince1970].longValue];
    
    if ([self respondsToSelector:@selector(imagePickerDidSelecteImages:)]) {
        [self performSelector:@selector(imagePickerDidSelecteImages:) withObject:@[imgData, iconName]];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma mark - image compress

- (NSData *)compressImageToDefaultFormat:(UIImage *)image
{
    return [self compressImage:image compressRatio:.7 maxCompressRatio:.5];
}

- (NSData *)compressImage:(UIImage *)image compressRatio:(CGFloat)ratio maxCompressRatio:(CGFloat)maxRatio
{
    
    //We define the max and min resolutions to shrink to
    int MIN_UPLOAD_RESOLUTION = 1136 * 640;
    int MAX_UPLOAD_SIZE = 50;
    
    float factor;
    float currentResolution = image.size.height * image.size.width;
    
    //We first shrink the image a little bit in order to compress it a little bit more
    if (currentResolution > MIN_UPLOAD_RESOLUTION) {
        factor = sqrt(currentResolution / MIN_UPLOAD_RESOLUTION) * 2;
        image = [self scaleDown:image withSize:CGSizeMake(image.size.width / factor, image.size.height / factor)];
    }
    
    //Compression settings
    CGFloat compression = ratio;
    CGFloat maxCompression = maxRatio;
    
    //We loop into the image data to compress accordingly to the compression ratio
    NSData *imageData = UIImageJPEGRepresentation(image, compression);
    while ([imageData length] > MAX_UPLOAD_SIZE && compression > maxCompression) {
        compression -= 0.10;
        imageData = UIImageJPEGRepresentation(image, compression);
    }
    
    //Retuns the compressed image
    return imageData;
}

- (UIImage*)scaleDown:(UIImage*)image withSize:(CGSize)newSize
{
    
    //We prepare a bitmap with the new size
    UIGraphicsBeginImageContextWithOptions(newSize, YES, 0.0);
    
    //Draws a rect for the image
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    
    //We set the scaled image from the context
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return scaledImage;
}


@end
