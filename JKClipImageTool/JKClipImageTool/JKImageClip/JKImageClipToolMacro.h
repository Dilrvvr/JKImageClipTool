//
//  JKImageClipToolMacro.h
//  JKClipImageTool
//
//  Created by albert on 2018/1/29.
//  Copyright © 2018年 安永博. All rights reserved.
//

#ifndef JKImageClipToolMacro_h
#define JKImageClipToolMacro_h



#define JKScreenW [UIScreen mainScreen].bounds.size.width
#define JKScreenH [UIScreen mainScreen].bounds.size.height
#define JKScreenBounds [UIScreen mainScreen].bounds
#define JKScreenScale ([UIScreen mainScreen].scale)
#define JKFreeImageClipViewIsIphoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)
#define JKFreeImageClipViewBottomViewH (JKFreeImageClipViewIsIphoneX ? 94 : 60)




#endif /* JKImageClipToolMacro_h */
