//
//  JKFreeImageClipView.h
//  JKClipImageTool
//
//  Created by albert on 2017/5/18.
//  Copyright © 2017年 安永博. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JKFreeImageClipView : UIView

- (void)hideBottomView;
- (void)cancelButtonClick;
- (void)verifyButtonClick;

/**
 * 自由裁剪图片
 * image : 要裁剪的图片
 * autoSavaToAlbum : 是否自动将截图保存到相册
 * complete : 截图完成的回调
 * cancel : 点击取消的回调
 */
+ (instancetype)showWithImage:(UIImage *)image superView:(UIView *)superView autoSavaToAlbum:(BOOL)autoSavaToAlbum complete:(void(^)(UIImage *image))complete cancel:(void(^)(void))cancel;

/**
 * 仅展示图片
 * image : 要展示的图片
 * complete : 点击确定的回调
 * cancel : 点击取消的回调
 */
+ (instancetype)showWithImage:(UIImage *)image superView:(UIView *)superView complete:(void(^)(UIImage *image))complete cancel:(void(^)(void))cancel;
@end
