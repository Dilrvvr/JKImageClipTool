//
//  JKClipImageConst.m
//  JKClipImageTool
//
//  Created by albert on 2019/12/7.
//  Copyright © 2019 安永博. All rights reserved.
//

#import "JKClipImageConst.h"
#import <AudioToolbox/AudioToolbox.h>

#pragma mark
#pragma mark - 适配

/// 屏幕适配
CGFloat JKClipImageAdaptScreenSize (CGFloat origin) {
    
    UIWindow *keyWindow = [UIApplication sharedApplication].delegate.window;
    
    CGFloat width = MIN(keyWindow.frame.size.width, keyWindow.frame.size.height);
    
    if (width < 375) { return origin; }
    
    CGFloat scale = width / 375;
    
    return origin * scale;
}

/// 是否X设备
BOOL JKClipImageIsDeviceX (void) {
    
    static BOOL JKClipImageIsDeviceX_ = NO;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        if (@available(iOS 11.0, *)) {
            
            if (!JKClipImageIsDeviceiPad()) {
                
                JKClipImageIsDeviceX_ = [UIApplication sharedApplication].delegate.window.safeAreaInsets.bottom > 0;
            }
        }
    });
    
    return JKClipImageIsDeviceX_;
}

/// 是否iPad
BOOL JKClipImageIsDeviceiPad (void){
    
    static BOOL JKClipImageIsDeviceiPad_ = NO;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        if (@available(iOS 11.0, *)) {
            
            JKClipImageIsDeviceiPad_ = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
        }
    });
    
    return JKClipImageIsDeviceiPad_;
}

/// 当前是否横屏
BOOL JKClipImageIsLandscape (void) {
    
    return [UIScreen mainScreen].bounds.size.width > [UIScreen mainScreen].bounds.size.height;
}

/// 状态栏高度
CGFloat JKClipImageStatusBarHeight (void) {
    
    return JKClipImageIsDeviceX() ? 44.f : 20.f;
}

/// 导航条高度
CGFloat JKClipImageNavigationBarHeight (void) {
    
    if (JKClipImageIsDeviceiPad()) { // iPad
        
        return JKClipImageIsLandscape() ? 70.f : 64.f;
        
    } else { // iPhone
        
        return JKClipImageIsLandscape() ? 44.f : (JKClipImageIsDeviceX() ? 88.f : 64.f);
    }
}

/// tabBar高度
CGFloat JKClipImageTabBarHeight (void) {
    
    return (JKClipImageIsDeviceX() ? 83.f : 49.f);
}

/// X设备底部indicator高度
CGFloat const JKClipImageHomeIndicatorHeight = 34.f;

/// 当前设备底部indicator高度 非X为0
CGFloat JKClipImageCurrentHomeIndicatorHeight (void) {
    
    return JKClipImageIsDeviceX() ? 34.f : 0.f;
}

/// 使用KVC获取当前的状态栏的view
UIView * JKClipImageStatusBarView (void) {
    
    UIView *statusBar = nil;
    
    if (@available(iOS 13.0, *)) {
        
        
    } else {
        
        statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    }
    
    return statusBar;
}


/// 让手机振动一下
void JKClipImageCibrateDevice (void) {
    
    // 普通短震，3D Touch 中 Peek 震动反馈
    AudioServicesPlaySystemSound(1519);
    
    // 普通短震，3D Touch 中 Pop 震动反馈
    //AudioServicesPlaySystemSound(1520);
    
    // 连续三次短震
    //AudioServicesPlaySystemSound(1521);
    
    //AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}

/// 颜色适配
UIColor * JKClipImageAdaptColor (UIColor *lightColor, UIColor *darkColor) {
    
    if (@available(iOS 13.0, *)) {
        
        UIColor *color = [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull traitCollection) {
            
            if ([traitCollection userInterfaceStyle] == UIUserInterfaceStyleLight) {
                
                return lightColor;
            }

            return darkColor;
        }];
        
        return color;
        
    } else {
        
        return lightColor;
    }
}

/// UIView截图
UIImage * JKClipImageSnapshotWithView (UIView *view) {
    
    UIGraphicsBeginImageContextWithOptions(view.frame.size, NO, [[UIScreen mainScreen] scale]);
    
    //[view drawViewHierarchyInRect:view.bounds afterScreenUpdates:YES];
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *snapshot = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return snapshot;
}
