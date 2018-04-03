//
//  JKImageClipTool.h
//  JKClipImageTool
//
//  Created by albert on 2017/5/19.
//  Copyright © 2017年 安永博. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JKImageClipActionProtocol.h"

typedef enum : NSUInteger {
    
    JKImageClipTypeJustShowImage = 0,  // 仅仅展示图片
    JKImageClipTypeSquare = 1, // 裁剪方形图片
    JKImageClipTypeCircle = 2, // 裁剪圆形图片
    JKImageClipTypeFree = 3,   // 自由裁剪图片
    JKImageClipTypeJustShowImageWithNavBar = 4, // 仅仅展示图片，带导航条
    JKImageClipTypeFreeWithNavBar = 5, // 自由裁剪图片，带导航条
    
} JKImageClipType;

@interface JKImageClipTool : NSObject
/**
 * 裁剪图片
 * image : 要裁剪的图片
 * superView : 父视图，注意frame一定要是屏幕大小，否则可能会出现问题
 *             传入父试图，则自己处理父视图显示动画，如果传nil，则默认添加到keywindow
 * imageClipType : 裁剪样式，带导航条则必须要传superView，否则无效
 * autoSavaToAlbum : 是否自动将截图保存到相册
 * complete : 截图完成的回调
 * cancel : 点击取消的回调
 * return value: 返回的对象是对应的view，使用id+协议方便操作，如不放心内存问题，可在不用的时候将返回值置为nil
 */
+ (id<JKImageClipActionProtocol>)showWithImage:(UIImage *)image superView:(UIView *)superView imageClipType:(JKImageClipType)imageClipType autoSavaToAlbum:(BOOL)autoSavaToAlbum complete:(void(^)(UIImage *image))complete cancel:(void(^)(void))cancel;
@end
