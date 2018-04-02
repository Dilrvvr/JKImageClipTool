//
//  JKSqureImageClipView.h
//  JKClipImageTool
//
//  Created by albert on 2017/5/17.
//  Copyright © 2017年 安永博. All rights reserved.
//  正方形图片裁剪

#import <UIKit/UIKit.h>

@interface JKSqureImageClipView : UIView

/**
 * 裁剪正方形图片
 * image : 要裁剪的图片
 * isCircle : 是否裁剪为圆形
 * autoSavaToAlbum : 是否自动将截图保存到相册
 * complete : 截图完成的回调
 */
+ (void)showWithImage:(UIImage *)image isCircle:(BOOL)isCircle autoSavaToAlbum:(BOOL)autoSavaToAlbum complete:(void(^)(UIImage *image))complete cancel:(void(^)(void))cancel;
@end
