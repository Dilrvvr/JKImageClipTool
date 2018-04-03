//
//  JKFreeImageClipView.h
//  JKClipImageTool
//
//  Created by albert on 2017/5/18.
//  Copyright © 2017年 安永博. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JKImageClipActionProtocol.h"

@interface JKFreeImageClipView : UIView <JKImageClipActionProtocol>

/**
 * 自由裁剪图片
 * image : 要裁剪的图片
 * superView : 父视图
 * isHaveNavBar : 是否有导航条，注意必须有父视图，这里才有效，设为YES则会隐藏底部确定取消按钮
 * autoSavaToAlbum : 是否自动将截图保存到相册
 * complete : 截图完成的回调
 * cancel : 点击取消的回调
 */
+ (instancetype)showWithImage:(UIImage *)image superView:(UIView *)superView isHaveNavBar:(BOOL)isHaveNavBar autoSavaToAlbum:(BOOL)autoSavaToAlbum complete:(void(^)(UIImage *image))complete cancel:(void(^)(void))cancel;

/**
 * 仅展示图片
 * image : 要展示的图片
 * complete : 点击确定的回调
 * cancel : 点击取消的回调
 */
+ (instancetype)showWithImage:(UIImage *)image superView:(UIView *)superView isHaveNavBar:(BOOL)isHaveNavBar complete:(void(^)(UIImage *image))complete cancel:(void(^)(void))cancel;
@end
