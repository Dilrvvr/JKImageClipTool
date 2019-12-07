//
//  JKClipImageTool.m
//  JKClipImageTool
//
//  Created by albert on 2017/5/19.
//  Copyright © 2017年 安永博. All rights reserved.
//

#import "JKClipImageTool.h"

#import "JKSqureImageClipView.h"
#import "JKClipImageFreeTypeView.h"

@implementation JKClipImageTool

/**
 * 裁剪图片
 * image : 要裁剪的图片
 * superView : 父视图，注意frame一定要是屏幕大小，否则可能会出现问题
 *             传入父试图，则自己处理父视图显示动画，如果传nil，则默认添加到keywindow
 * imageClipType : 裁剪样式
 * autoSavaToAlbum : 是否自动将截图保存到相册
 * completeHandler : 截图完成的回调
 * cancelHandler : 点击取消的回调
 */
+ (id<JKImageClipActionProtocol>)showWithImage:(UIImage *)image superView:(UIView *)superView imageClipType:(JKImageClipType)imageClipType autoSavaToAlbum:(BOOL)autoSavaToAlbum complete:(void(^)(UIImage *image))complete cancel:(void(^)(void))cancel{
    
    switch (imageClipType) {
            
        case JKImageClipTypeJustShowImage:
        {
            return [JKClipImageFreeTypeView showWithSuperView:superView targetImage:image isJustShowImage:YES isShowNavigationBar:NO isAutoSavaToAlbum:NO cancelHandler:cancel completeHandler:complete];
        }
            break;
            
        case JKImageClipTypeSquare:
        {
            return [JKSqureImageClipView showWithImage:image superView:superView isCircle:NO autoSavaToAlbum:autoSavaToAlbum complete:complete cancel:cancel];
        }
            break;
            
        case JKImageClipTypeCircle:
        {
            return [JKSqureImageClipView showWithImage:image superView:superView isCircle:YES autoSavaToAlbum:autoSavaToAlbum complete:complete cancel:cancel];
        }
            break;
            
        case JKImageClipTypeFree:
        {
            return [JKClipImageFreeTypeView showWithSuperView:superView targetImage:image isJustShowImage:NO isShowNavigationBar:NO isAutoSavaToAlbum:autoSavaToAlbum cancelHandler:cancel completeHandler:complete];
        }
            break;
            
        case JKImageClipTypeJustShowImageWithNavBar:
        {
            return [JKClipImageFreeTypeView showWithSuperView:superView targetImage:image isJustShowImage:YES isShowNavigationBar:YES isAutoSavaToAlbum:NO cancelHandler:cancel completeHandler:complete];
        }
            break;
            
        case JKImageClipTypeFreeWithNavBar:
        {
            return [JKClipImageFreeTypeView showWithSuperView:superView targetImage:image isJustShowImage:NO isShowNavigationBar:YES isAutoSavaToAlbum:autoSavaToAlbum cancelHandler:cancel completeHandler:complete];
        }
            break;
            
        default:
            break;
    }
}


/**
 * 裁剪图片
 * image : 要裁剪的图片
 * superView : 父视图，注意frame一定要是屏幕大小，否则可能会出现问题
 *             传入父试图，则自己处理父视图显示动画，如果传nil，则默认添加到keywindow
 * cropSize : 裁剪比例
 * autoSavaToAlbum : 是否自动将截图保存到相册
 * completeHandler : 截图完成的回调
 * cancelHandler : 点击取消的回调
 * return value: 返回的对象是对应的view，使用id+协议方便操作，如不放心内存问题，可在不用的时候将返回值置为nil
 */
+ (id<JKImageClipActionProtocol>)showWithImage:(UIImage *)image superView:(UIView *)superView cropSize:(CGSize)cropSize autoSavaToAlbum:(BOOL)autoSavaToAlbum complete:(void(^)(UIImage *image))complete cancel:(void(^)(void))cancel{
    
    return [JKSqureImageClipView showWithImage:image superView:superView cropSize:cropSize autoSavaToAlbum:autoSavaToAlbum complete:complete cancel:cancel];
}
@end
