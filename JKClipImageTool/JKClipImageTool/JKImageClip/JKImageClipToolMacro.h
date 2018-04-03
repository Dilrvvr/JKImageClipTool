//
//  JKImageClipToolMacro.h
//  JKClipImageTool
//
//  Created by albert on 2018/1/29.
//  Copyright © 2018年 安永博. All rights reserved.
//

#ifndef JKImageClipToolMacro_h
#define JKImageClipToolMacro_h



#define JKImageClipScreenW [UIScreen mainScreen].bounds.size.width
#define JKImageClipScreenH [UIScreen mainScreen].bounds.size.height
#define JKImageClipScreenBounds [UIScreen mainScreen].bounds
#define JKImageClipScreenScale ([UIScreen mainScreen].scale)
#define JKFreeImageClipViewIsIphoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)




#endif /* JKImageClipToolMacro_h */
