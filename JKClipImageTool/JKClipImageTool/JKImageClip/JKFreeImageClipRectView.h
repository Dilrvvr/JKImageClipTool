//
//  JKFreeImageClipRectView.h
//  JKClipImageTool
//
//  Created by albert on 2017/5/18.
//  Copyright © 2017年 安永博. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JKFreeImageClipRectView : UIView
/** 左上角 */
@property (nonatomic, weak, readonly) UIImageView *top_left_imageView;

/** 右上角 */
@property (nonatomic, weak, readonly) UIImageView *top_right_imageView;

/** 左下角 */
@property (nonatomic, weak, readonly) UIImageView *bottom_left_imageView;

/** 右下角 */
@property (nonatomic, weak, readonly) UIImageView *bottom_right_imageView;

/** middle */
@property (nonatomic, weak, readonly) UIImageView *middle_imageView;
@end
