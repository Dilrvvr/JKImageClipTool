//
//  JKImageClipActionProtocol.h
//  JKClipImageTool
//
//  Created by albert on 2018/4/3.
//  Copyright © 2018年 安永博. All rights reserved.
//

#ifndef JKImageClipActionProtocol_h
#define JKImageClipActionProtocol_h


@protocol JKImageClipActionProtocol

/** 取消 */
- (void)cancelButtonClick;

/** 确定 */
- (void)verifyButtonClick;

/** 隐藏底部view */
- (void)hideBottomView;
@end

#endif /* JKImageClipActionProtocol_h */
