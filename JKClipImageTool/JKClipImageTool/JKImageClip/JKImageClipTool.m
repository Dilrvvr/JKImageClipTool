//
//  JKImageClipTool.m
//  JKClipImageTool
//
//  Created by albert on 2017/5/19.
//  Copyright © 2017年 安永博. All rights reserved.
//

#import "JKImageClipTool.h"

#import "JKSqureImageClipView.h"
#import "JKFreeImageClipView.h"

@implementation JKImageClipTool

/**
 * 裁剪图片
 * image : 要裁剪的图片
 * isJustShowImage : 是否仅用于展示图片
 * isSquare : 是否裁剪正方形
 * autoSavaToAlbum : 是否自动将截图保存到相册
 * complete : 截图完成的回调
 * cancel : 点击取消的回调
 */
+ (void)showWithImage:(UIImage *)image isJustShowImage:(BOOL)isJustShowImage isSquare:(BOOL)isSquare autoSavaToAlbum:(BOOL)autoSavaToAlbum complete:(void(^)(UIImage *image))complete cancel:(void(^)(void))cancel{
    
    if (isJustShowImage) {
        [JKFreeImageClipView showWithImage:image complete:complete cancel:cancel];
        return;
    }
    
    if (isSquare) {
        [JKSqureImageClipView showWithImage:image autoSavaToAlbum:autoSavaToAlbum complete:complete cancel:cancel];
        return;
    }
    
    [JKFreeImageClipView showWithImage:image autoSavaToAlbum:autoSavaToAlbum complete:complete cancel:cancel];
}
@end
