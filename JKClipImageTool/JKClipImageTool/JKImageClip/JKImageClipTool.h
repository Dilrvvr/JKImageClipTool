//
//  JKImageClipTool.h
//  JKClipImageTool
//
//  Created by albert on 2017/5/19.
//  Copyright © 2017年 安永博. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    
    JKImageClipTypeJustShowImage = 0,  // 仅仅展示图片
    JKImageClipTypeSquare = 1, // 裁剪方形图片
    JKImageClipTypeCircle = 2, // 裁剪圆形图片
    JKImageClipTypeFree = 3,   // 自由裁剪图片
    
} JKImageClipType;

@interface JKImageClipTool : NSObject
/**
 * 裁剪图片
 * image : 要裁剪的图片
 * imageClipType : 裁剪样式
 * autoSavaToAlbum : 是否自动将截图保存到相册
 * complete : 截图完成的回调
 * cancel : 点击取消的回调
 */
+ (void)showWithImage:(UIImage *)image imageClipType:(JKImageClipType)imageClipType autoSavaToAlbum:(BOOL)autoSavaToAlbum complete:(void(^)(UIImage *image))complete cancel:(void(^)(void))cancel;
@end
