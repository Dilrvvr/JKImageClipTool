//
//  JKClipImageSquareTypeView.h
//  JKClipImageTool
//
//  Created by albert on 2017/5/17.
//  Copyright © 2017年 安永博. All rights reserved.
//  正方形图片裁剪

#import "JKClipImageBaseView.h"

@interface JKClipImageSquareTypeView : JKClipImageBaseView <JKImageClipProtocol>

/**
 * 裁剪正方形图片
 * targetImage : 要裁剪的图片
 * isCircle : 是否裁剪为圆形
 * clipSize : 要裁剪的宽高比
 * isAutoSavaToAlbum : 是否自动将截图保存到相册
 * cancelHandler : 点击取消的回调
 * completeHandler : 截图完成的回调
 */
+ (instancetype)showWithSuperView:(UIView *)superView
                      targetImage:(UIImage *)targetImage
                         clipSize:(CGSize)clipSize
                         isCircle:(BOOL)isCircle
                isAutoSavaToAlbum:(BOOL)isAutoSavaToAlbum
                    cancelHandler:(void(^)(void))cancelHandler
                  completeHandler:(void(^)(UIImage *image))completeHandler;
@end
