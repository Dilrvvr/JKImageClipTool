//
//  JKClipImageTool.m
//  JKClipImageTool
//
//  Created by albert on 2017/5/19.
//  Copyright © 2017年 安永博. All rights reserved.
//

#import "JKClipImageTool.h"

#import "JKClipImageSquareTypeView.h"
#import "JKClipImageFreeTypeView.h"

@implementation JKClipImageTool

/**
 * 裁剪图片
 * superView : 父视图，注意frame一定要是屏幕大小，否则可能会出现问题
 *             传入父试图，则自己处理父视图显示动画，如果传nil，则默认添加到keywindow
 * targetImage : 要裁剪的图片
 * clipImageType : 裁剪样式，带导航条则必须要传superView，否则无效
 * clipImageSize : 裁剪比例 JKClipImageTypeRatio需传该参数
 * isAutoSavaToAlbum : 是否自动将截图保存到相册
 * completeHandler : 截图完成的回调
 * cancelHandler : 点击取消的回调
 * return value: 返回的对象是对应的view，使用id+协议方便操作
 */
+ (id<JKImageClipProtocol>)showWithSuperView:(UIView *)superView
                                 targetImage:(UIImage *)targetImage
                               clipImageType:(JKClipImageType)clipImageType
                               clipImageSize:(CGSize)clipImageSize
                           isAutoSavaToAlbum:(BOOL)isAutoSavaToAlbum
                               cancelHandler:(void(^)(void))cancelHandler
                             completeHandler:(void(^)(UIImage *image))completeHandler{
    
    switch (clipImageType) {
            
        case JKClipImageTypeJustShowImage:
        {
            return [JKClipImageFreeTypeView showWithSuperView:superView targetImage:targetImage isJustShowImage:YES isShowNavigationBar:NO isAutoSavaToAlbum:NO cancelHandler:cancelHandler completeHandler:completeHandler];
        }
            break;
            
        case JKClipImageTypeSquare:
        {
            return [JKClipImageSquareTypeView showWithSuperView:superView targetImage:targetImage clipSize:CGSizeZero isCircle:NO isAutoSavaToAlbum:isAutoSavaToAlbum cancelHandler:cancelHandler completeHandler:completeHandler];
        }
            break;
            
        case JKClipImageTypeRatio:
        {
            return [JKClipImageSquareTypeView showWithSuperView:superView targetImage:targetImage clipSize:clipImageSize isCircle:NO isAutoSavaToAlbum:isAutoSavaToAlbum cancelHandler:cancelHandler completeHandler:completeHandler];
        }
            break;
            
        case JKClipImageTypeCircle:
        {
            return [JKClipImageSquareTypeView showWithSuperView:superView targetImage:targetImage clipSize:CGSizeZero isCircle:YES isAutoSavaToAlbum:isAutoSavaToAlbum cancelHandler:cancelHandler completeHandler:completeHandler];
        }
            break;
            
        case JKClipImageTypeFree:
        {
            return [JKClipImageFreeTypeView showWithSuperView:superView targetImage:targetImage isJustShowImage:NO isShowNavigationBar:NO isAutoSavaToAlbum:isAutoSavaToAlbum cancelHandler:cancelHandler completeHandler:completeHandler];
        }
            break;
            
        case JKClipImageTypeJustShowImageWithNavBar:
        {
            return [JKClipImageFreeTypeView showWithSuperView:superView targetImage:targetImage isJustShowImage:YES isShowNavigationBar:YES isAutoSavaToAlbum:NO cancelHandler:cancelHandler completeHandler:completeHandler];
        }
            break;
            
        case JKClipImageTypeFreeWithNavBar:
        {
            return [JKClipImageFreeTypeView showWithSuperView:superView targetImage:targetImage isJustShowImage:NO isShowNavigationBar:YES isAutoSavaToAlbum:isAutoSavaToAlbum cancelHandler:cancelHandler completeHandler:completeHandler];
        }
            break;
            
        default:
            break;
    }
}
@end
