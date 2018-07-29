//
//  TestViewController.m
//  JKClipImageTool
//
//  Created by albert on 2017/5/15.
//  Copyright © 2017年 安永博. All rights reserved.
//

#import "TestViewController.h"
#import "JKImageClipTool.h"
#import "ClipCircleViewController.h"

@interface TestViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;

/** 是否裁剪为正方形 */
@property (nonatomic, assign) BOOL isClipSquare;

/** 是否裁剪为圆形*/
@property (nonatomic, assign) BOOL isClipCircle;

/** 是否按比例裁剪*/
@property (nonatomic, assign) BOOL isCropScale;
@end

@implementation TestViewController

- (IBAction)clip:(id)sender {
    
    self.isClipSquare = YES;
    self.isClipCircle = NO;
    self.isCropScale  = NO;
    
    [self pictureAlert];
}

- (IBAction)freeClip:(id)sender {
    
    self.isClipCircle = NO;
    self.isClipSquare = NO;
    self.isCropScale  = NO;
    
    [self pictureAlert];
}

- (IBAction)circleClip:(id)sender {
    
    self.isClipCircle = YES;
    self.isCropScale  = NO;
    
    [self pictureAlert];
}

- (IBAction)cropScale:(id)sender {
    
    self.isCropScale  = YES;
    self.isClipSquare = NO;
    self.isClipCircle = NO;
    
    [self pictureAlert];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    
    UILongPressGestureRecognizer *longPressGes = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(saveImage:)];
    [self.imageView addGestureRecognizer:longPressGes];
    self.imageView.userInteractionEnabled = YES;
}

- (void)saveImage:(UILongPressGestureRecognizer *)ges{
    
    if (!self.imageView.image) {
        return;
    }
    
    if (ges.state == UIGestureRecognizerStateBegan) {
        UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:(UIAlertControllerStyleActionSheet)];
        
        [alertVc addAction:[UIAlertAction actionWithTitle:@"保存到相册" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            UIImageWriteToSavedPhotosAlbum(self.imageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
        }]];
        
        [alertVc addAction:[UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        
        [self presentViewController:alertVc animated:YES completion:nil];
    }
    
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    
    if (error) {
        return;
    }
    
    self.tipLabel.alpha = 0;
    self.tipLabel.hidden = NO;
    
    [UIView animateWithDuration:0.5 animations:^{
        
        self.tipLabel.alpha = 1;
        
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.5 delay:0.5 options:0 animations:^{
            
            self.tipLabel.alpha = 0;
            
        } completion:^(BOOL finished) {
            
            self.tipLabel.hidden = YES;
        }];
    }];
}

- (void)pictureAlert{
    
    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:(UIAlertControllerStyleActionSheet)];
    
    UIAlertAction *actionTakePhoto = [UIAlertAction actionWithTitle:@"拍照" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        [self updateIconWithSourType:(UIImagePickerControllerSourceTypeCamera)];
    }];
    
    UIAlertAction *actionSelectPhoto = [UIAlertAction actionWithTitle:@"从相册选择" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        [self updateIconWithSourType:(UIImagePickerControllerSourceTypePhotoLibrary)];
    }];
    UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:nil];
    
    [alertVc addAction:actionTakePhoto];
    [alertVc addAction:actionSelectPhoto];
    [alertVc addAction:actionCancel];
    
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertVc animated:YES completion:nil];
}

- (void)updateIconWithSourType:(UIImagePickerControllerSourceType)sourceType{
    
    if (![UIImagePickerController isSourceTypeAvailable:sourceType]) return;
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType = sourceType;
    imagePicker.allowsEditing = NO;//(sourceType == UIImagePickerControllerSourceTypePhotoLibrary && self.isClipSquare);
    
    imagePicker.delegate = self;
    [self presentViewController:imagePicker animated:YES completion:nil];
}

#pragma mark - <UIImagePickerControllerDelegate>
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    UIImage *pickImage = nil;
    
//    if (self.isClipSquare && picker.sourceType == UIImagePickerControllerSourceTypePhotoLibrary) {
//
//        pickImage = info[UIImagePickerControllerEditedImage];
//        self.imageView.image = pickImage;
//        [self dismissViewControllerAnimated:YES completion:nil];
//        return;
//    }
    
    pickImage = info[UIImagePickerControllerOriginalImage];
    
    if (self.isClipCircle) {
        
        [picker dismissViewControllerAnimated:YES completion:^{
            
            ClipCircleViewController *vc = [[ClipCircleViewController alloc] init];
            vc.pickImage = pickImage;
            
            [vc setComplete:^(UIImage *image) {
                
                self.imageView.image = image;
            }];
            
            [vc setCancel:^{
                
            }];
            
            [self.navigationController pushViewController:vc animated:YES];
        }];
        
        return;
    }
    
    if (self.isCropScale) {
        
        [JKImageClipTool showWithImage:pickImage superView:nil cropSize:CGSizeMake(414, 736) autoSavaToAlbum:NO complete:^(UIImage *image) {
            
            self.imageView.image = image;
            
        } cancel:^{
            
        }];
        
    }else if (self.isClipSquare) {
        
        [JKImageClipTool showWithImage:pickImage superView:nil imageClipType:(JKImageClipTypeSquare) autoSavaToAlbum:NO complete:^(UIImage *image) {
            
            self.imageView.image = image;
            
        } cancel:^{
            
        }];
        
    }else{
        
        [JKImageClipTool showWithImage:pickImage superView:nil imageClipType:(JKImageClipTypeFree) autoSavaToAlbum:NO complete:^(UIImage *image) {
            
            self.imageView.image = image;
            
        } cancel:^{
            
        }];
    }
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
