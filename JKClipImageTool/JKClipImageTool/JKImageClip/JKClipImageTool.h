//
//  JKClipImageTool.h
//  JKClipImageTool
//
//  Created by albert on 2017/5/19.
//  Copyright © 2017年 安永博. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JKClipImageConst.h"

@interface JKClipImageTool : NSObject

// ========================================Attention========================================

// 当你需要把视图放在一个控制器的view中，并带有导航条时，需要的操作请查阅<JKImageClipActionProtocol>协议
// 具体可参照ClipCircleViewController的写法

// important!! 暂不支持横屏操作，请保证使用时处于竖屏状态！！！

// ========================================Attention========================================

/**
 * 裁剪图片
 * image : 要裁剪的图片
 * superView : 父视图，注意frame一定要是屏幕大小，否则可能会出现问题
 *             传入父试图，则自己处理父视图显示动画，如果传nil，则默认添加到keywindow
 * imageClipType : 裁剪样式，带导航条则必须要传superView，否则无效
 * autoSavaToAlbum : 是否自动将截图保存到相册
 * completeHandler : 截图完成的回调
 * cancelHandler : 点击取消的回调
 * return value: 返回的对象是对应的view，使用id+协议方便操作，如不放心内存问题，可在不用的时候将返回值置为nil
 */
+ (id<JKImageClipActionProtocol>)showWithImage:(UIImage *)image
                                     superView:(UIView *)superView
                                 imageClipType:(JKClipImageType)imageClipType
                               autoSavaToAlbum:(BOOL)autoSavaToAlbum
                                      complete:(void(^)(UIImage *image))complete
                                        cancel:(void(^)(void))cancel;

/**
 * 按比例裁剪图片
 * image : 要裁剪的图片
 * superView : 父视图，注意frame一定要是屏幕大小，否则可能会出现问题
 *             传入父试图，则自己处理父视图显示动画，如果传nil，则默认添加到keywindow
 * clipSize : 裁剪比例
 * autoSavaToAlbum : 是否自动将截图保存到相册
 * completeHandler : 截图完成的回调
 * cancelHandler : 点击取消的回调
 * return value: 返回的对象是对应的view，使用id+协议方便操作，如不放心内存问题，可在不用的时候将返回值置为nil
 */
+ (id<JKImageClipActionProtocol>)showWithImage:(UIImage *)image
                                     superView:(UIView *)superView
                                      cropSize:(CGSize)cropSize
                               autoSavaToAlbum:(BOOL)autoSavaToAlbum
                                      complete:(void(^)(UIImage *image))complete
                                        cancel:(void(^)(void))cancel;
@end
