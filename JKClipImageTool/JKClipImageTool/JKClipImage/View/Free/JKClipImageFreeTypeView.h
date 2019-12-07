//
//  JKClipImageFreeTypeView.h
//  JKClipImageTool
//
//  Created by albert on 2017/5/18.
//  Copyright © 2017年 安永博. All rights reserved.
//

#import "JKClipImageBaseView.h"
#import "JKClipImageConst.h"

@interface JKClipImageFreeTypeView : JKClipImageBaseView

/**
 * 自由裁剪图片
 * superView : 父视图
 * targetImage : 要处理的图片
 * isJustShowImage : 是否仅展示图片
 * isShowNavigationBar : 是否有导航条，注意必须有父视图，这里才有效，设为YES则会隐藏底部确定取消按钮
 * isAutoSavaToAlbum : 是否自动将截图保存到相册
 * cancelHandler : 点击取消的回调 
 * completeHandler : 截图完成的回调
 */
+ (instancetype)showWithSuperView:(UIView *)superView
                      targetImage:(UIImage *)targetImage
                  isJustShowImage:(BOOL)isJustShowImage
              isShowNavigationBar:(BOOL)isShowNavigationBar
                isAutoSavaToAlbum:(BOOL)isAutoSavaToAlbum
                    cancelHandler:(void(^)(void))cancelHandler
                  completeHandler:(void(^)(UIImage *image))completeHandler;
@end
