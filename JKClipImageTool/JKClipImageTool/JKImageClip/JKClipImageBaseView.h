//
//  JKClipImageBaseView.h
//  JKClipImageTool
//
//  Created by albert on 2019/12/7.
//  Copyright © 2019 安永博. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JKClipImageConst.h"

NS_ASSUME_NONNULL_BEGIN

@interface JKClipImageBaseView : UIView <JKImageClipActionProtocol>

/** backgroundView */
@property (nonatomic, weak) UIView *backgroundView;

/** contentView */
@property (nonatomic, weak) UIView *contentView;

/** bottomView */
@property (nonatomic, weak) UIView *bottomView;

- (void)cancelButtonClick;

- (void)verifyButtonClick;

- (void)hideBottomView;

#pragma mark
#pragma mark - Private

/** 初始化自身属性 交给子类重写 super自动调用该方法 */
- (void)initializeProperty NS_REQUIRES_SUPER;

/** 构造函数初始化时调用 注意调用super */
- (void)initialization NS_REQUIRES_SUPER;

/** 创建UI 交给子类重写 super自动调用该方法 */
- (void)createUI NS_REQUIRES_SUPER;

/** 布局UI 交给子类重写 super自动调用该方法 */
- (void)layoutUI NS_REQUIRES_SUPER;

/** 初始化数据 交给子类重写 super自动调用该方法 */
- (void)initializeUIData NS_REQUIRES_SUPER;
@end

NS_ASSUME_NONNULL_END
