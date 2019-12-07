//
//  JKClipImageConst.h
//  JKClipImageTool
//
//  Created by albert on 2019/12/7.
//  Copyright © 2019 安永博. All rights reserved.
//

#import <UIKit/UIKit.h>

#pragma mark
#pragma mark - Enum

typedef enum : NSUInteger {
    
    /** 仅仅展示图片 */
    JKClipImageTypeJustShowImage = 0,
    
    /** 裁剪方形图片 */
    JKClipImageTypeSquare = 1,
    
    /** 裁剪圆形图片 */
    JKClipImageTypeCircle = 2,
    
    /** 自由裁剪图片 */
    JKClipImageTypeFree = 3,
    
    /** 仅仅展示图片，带导航条 是否带导航条是为了控制上边距 */
    JKClipImageTypeJustShowImageWithNavBar = 4,
    
    /** 自由裁剪图片，带导航条 是否带导航条是为了控制上边距 */
    JKClipImageTypeFreeWithNavBar = 5,
    
} JKClipImageType;



#pragma mark
#pragma mark - Protocol

@protocol JKImageClipActionProtocol

/** 取消 */
- (void)cancelButtonClick;

/** 确定 */
- (void)verifyButtonClick;

/** 隐藏底部view */
- (void)hideBottomView;
@end



#pragma mark
#pragma mark - 宏定义

/** 屏幕bounds */
#define JKClipImageScreenBounds ([UIScreen mainScreen].bounds)
/** 屏幕scale */
#define JKClipImageScreenScale ([UIScreen mainScreen].scale)
/** 屏幕宽度 */
#define JKClipImageScreenWidth ([UIScreen mainScreen].bounds.size.width)
/** 屏幕高度 */
#define JKClipImageScreenHeight ([UIScreen mainScreen].bounds.size.height)

/// 当前导航条高度
#define JKClipImageCurrentTabBarHeight (JKClipImageIsLandscape() ? self.tabBarController.tabBar.frame.size.height : JKClipImageTabBarHeight())

// 快速设置颜色
#define JKClipImageColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]
#define JKClipImageColorAlpha(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]

#define JKClipImageSystemBlueColor [UIColor colorWithRed:0.f green:122.0/255.0 blue:255.0/255.0 alpha:1]

#define JKClipImageSystemRedColor [UIColor colorWithRed:255.0/255.0 green:59.0/255.0 blue:48.0/255.0 alpha:1]


#pragma mark
#pragma mark - 适配

/// 屏幕适配
CGFloat JKClipImageAdaptScreenSize (CGFloat origin);

/// 是否X设备
BOOL JKClipImageIsDeviceX (void);

/// 是否iPad
BOOL JKClipImageIsDeviceiPad (void);

/// 当前是否横屏
BOOL JKClipImageIsLandscape (void);

/// 状态栏高度
CGFloat JKClipImageStatusBarHeight (void);

/// 导航条高度
CGFloat JKClipImageNavigationBarHeight (void);

/// tabBar高度
CGFloat JKClipImageTabBarHeight (void);

/// X设备底部indicator高度
UIKIT_EXTERN CGFloat const JKClipImageHomeIndicatorHeight;

/// 当前设备底部indicator高度 非X为0
CGFloat JKClipImageCurrentHomeIndicatorHeight (void);

/// 使用KVC获取当前的状态栏的view
UIView * JKClipImageStatusBarView (void);


/// 让手机振动一下
void JKClipImageCibrateDevice (void);

/// 颜色适配
UIColor * JKClipImageAdaptColor (UIColor *lightColor, UIColor *darkColor);

/// UIView截图
UIImage * JKClipImageSnapshotWithView (UIView *view);
