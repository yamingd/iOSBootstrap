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
#import "UIImage+ImageCompress.h"

@implementation UIViewController(ImagePicker)

ADD_DYNAMIC_PROPERTY(NSString*, pickerTag, setPickerTag);

- (BOOL)isHasCamera
{
    return ([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear] || [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront]);
}

-(void)openImageSelectViews
{

    UIAlertController * view=   [UIAlertController
                                 alertControllerWithTitle:nil
                                 message:nil
                                 preferredStyle:UIAlertControllerStyleActionSheet];
    
    if ([self isHasCamera]) {
        UIAlertAction* action1 = [UIAlertAction
                                  actionWithTitle:@"拍照"
                                  style:UIAlertActionStyleDefault
                                  handler:^(UIAlertAction * action)
                                  {
                                      [view dismissViewControllerAnimated:YES completion:nil];
                                      [self picker_openImagePickerWithCamera];
                                      
                                  }];
        [view addAction:action1];
    }
    
    UIAlertAction* action2 = [UIAlertAction
                             actionWithTitle:@"从手机相册选择"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [view dismissViewControllerAnimated:YES completion:nil];
                                 [self picker_openImagePickerWithPhotoLibrary];
                                 
                             }];
    
    UIAlertAction* action3 = [UIAlertAction
                              actionWithTitle:@"取消"
                              style:UIAlertActionStyleCancel
                              handler:^(UIAlertAction * action)
                              {
                                  [view dismissViewControllerAnimated:YES completion:nil];
                                  
                              }];
    
    
    [view addAction:action2];
    [view addAction:action3];
    
    [self presentViewController:view animated:YES completion:nil];
}

#pragma mark - UIActionSheetDelegate

- (BOOL)assertAuthIsAvailible:(UIImagePickerControllerSourceType)type
{
    NSString* title = [DeviceHelper getAppName];
    
    if (type == UIImagePickerControllerSourceTypePhotoLibrary) {
        ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
        if(author == ALAuthorizationStatusRestricted || author == ALAuthorizationStatusDenied){
            NSString* msg = [NSString stringWithFormat:@"请到 “设置－%@－照片” 选项中，允许%@访问您手机的照片。", title, title];
            [self picker_showAlertMessage:@"无法选择照片" message:msg];
            return NO;
        }
    } else if (type == UIImagePickerControllerSourceTypeCamera) {
        NSString *mediaType = AVMediaTypeVideo;
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
        if(authStatus == ALAuthorizationStatusRestricted || authStatus == ALAuthorizationStatusDenied){
            NSString* msg = [NSString stringWithFormat:@"请到 “设置－%@－相机” 选项中，允许%@访问您手机的相机。", title, title];
            [self picker_showAlertMessage:@"无法拍照" message:msg];
            return NO;
        }
    }
    return YES;
}

- (void)picker_showAlertMessage:(NSString*)title message:(NSString*)message{
    
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:title
                                  message:message
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction
                         actionWithTitle:@"知道了"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             //Do some thing here
                             [self dismissViewControllerAnimated:YES completion:nil];
                             
                         }];
    [alert addAction:ok]; // add action to uialertcontroller
    
    [self presentViewController:alert animated:YES completion:nil];
    
}

- (void)picker_openImagePickerWithCamera{
    if (![self assertAuthIsAvailible:UIImagePickerControllerSourceTypeCamera]) {
        return;
    }
    
    WEAKSELF_DEFINE
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = weakSelf;
    imagePicker.allowsEditing = YES;
    imagePicker.view.backgroundColor = [UIColor clearColor];
    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    imagePicker.cameraDevice = UIImagePickerControllerCameraDeviceRear;
    [self picker_config:imagePicker];
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [weakSelf presentViewController:imagePicker animated:YES completion:NULL];
    }];
}

- (void)picker_config:(UIImagePickerController*)controller{
    if ([self respondsToSelector:@selector(pickerConfigController:)]) {
        [self performSelector:@selector(pickerConfigController:) withObject:controller];
    }
}

- (void)picker_openImagePickerWithPhotoLibrary{
    if (![self assertAuthIsAvailible:UIImagePickerControllerSourceTypePhotoLibrary]) {
        return;
    }
    
    WEAKSELF_DEFINE
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = weakSelf;
    imagePicker.allowsEditing = YES;
    imagePicker.view.backgroundColor = [UIColor clearColor];
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self picker_config:imagePicker];
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [weakSelf presentViewController:imagePicker animated:YES completion:NULL];
    }];

}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    UIImage *selectedImage = nil;
    if (picker.allowsEditing) {
        selectedImage = [info objectForKey:UIImagePickerControllerEditedImage];
    }else{
        selectedImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    }
    
    NSData* imgData = [UIImage compressImage:selectedImage compressRatio:.7 maxCompressRatio:.5];
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

@end
