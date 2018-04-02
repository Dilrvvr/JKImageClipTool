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
 * imageClipType : 裁剪样式
 * autoSavaToAlbum : 是否自动将截图保存到相册
 * complete : 截图完成的回调
 * cancel : 点击取消的回调
 */
+ (void)showWithImage:(UIImage *)image imageClipType:(JKImageClipType)imageClipType autoSavaToAlbum:(BOOL)autoSavaToAlbum complete:(void(^)(UIImage *image))complete cancel:(void(^)(void))cancel{
    
    switch (imageClipType) {
            
        case JKImageClipTypeJustShowImage:
        {
            [JKFreeImageClipView showWithImage:image complete:complete cancel:cancel];
        }
            break;
            
        case JKImageClipTypeSquare:
        {
            [JKSqureImageClipView showWithImage:image isCircle:NO autoSavaToAlbum:autoSavaToAlbum complete:complete cancel:cancel];
        }
            break;
            
        case JKImageClipTypeCircle:
        {
            [JKSqureImageClipView showWithImage:image isCircle:YES autoSavaToAlbum:autoSavaToAlbum complete:complete cancel:cancel];
        }
            break;
            
        case JKImageClipTypeFree:
        {
            [JKFreeImageClipView showWithImage:image autoSavaToAlbum:autoSavaToAlbum complete:complete cancel:cancel];
        }
            break;
            
        default:
            break;
    }
}
@end
