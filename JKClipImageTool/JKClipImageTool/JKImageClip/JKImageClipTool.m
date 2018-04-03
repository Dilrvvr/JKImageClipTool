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

static JKSqureImageClipView *squreView_;

static JKFreeImageClipView *freeView_;

@implementation JKImageClipTool

/**
 * 裁剪图片
 * image : 要裁剪的图片
 * superView : 父视图，注意frame一定要是屏幕大小，否则可能会出现问题
 *             传入父试图，则自己处理父视图显示动画，如果传nil，则默认添加到keywindow
 * imageClipType : 裁剪样式
 * autoSavaToAlbum : 是否自动将截图保存到相册
 * complete : 截图完成的回调
 * cancel : 点击取消的回调
 */
+ (void)showWithImage:(UIImage *)image superView:(UIView *)superView imageClipType:(JKImageClipType)imageClipType autoSavaToAlbum:(BOOL)autoSavaToAlbum complete:(void(^)(UIImage *image))complete cancel:(void(^)(void))cancel{
    
    switch (imageClipType) {
            
        case JKImageClipTypeJustShowImage:
        {
            [JKFreeImageClipView showWithImage:image superView:superView complete:complete cancel:cancel];
        }
            break;
            
        case JKImageClipTypeSquare:
        {
            [JKSqureImageClipView showWithImage:image superView:superView isCircle:NO autoSavaToAlbum:autoSavaToAlbum complete:complete cancel:cancel];
        }
            break;
            
        case JKImageClipTypeCircle:
        {
            [JKSqureImageClipView showWithImage:image superView:superView isCircle:YES autoSavaToAlbum:autoSavaToAlbum complete:complete cancel:cancel];
        }
            break;
            
        case JKImageClipTypeFree:
        {
            [JKFreeImageClipView showWithImage:image superView:superView autoSavaToAlbum:autoSavaToAlbum complete:complete cancel:cancel];
        }
            break;
            
        default:
            break;
    }
}



+ (void)hideBottomView{
    
    [squreView_ hideBottomView];
    [freeView_ hideBottomView];
}

+ (void)setTopInset:(CGFloat)topInset{
    
}

+ (void)cancelButtonClick{
    
    [squreView_ cancelButtonClick];
    [freeView_ cancelButtonClick];
}

+ (void)verifyButtonClick{
    
    [squreView_ verifyButtonClick];
    [freeView_ verifyButtonClick];
}
@end
