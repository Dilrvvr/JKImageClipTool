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

@interface JKClipImageBaseView : UIView <UIScrollViewDelegate ,JKClipImageProtocol>

/** backgroundView */
@property (nonatomic, weak) UIView *backgroundView;

/** contentView */
@property (nonatomic, weak) UIView *contentView;

/** scrollView */
@property (nonatomic, weak) UIScrollView *scrollView;

/** imageView */
@property (nonatomic, weak) UIImageView *imageView;

/** bottomControlView */
@property (nonatomic, weak) UIView *bottomControlView;

/** cancelButton */
@property (nonatomic, weak) UIButton *cancelButton;

/** verifyButton */
@property (nonatomic, weak) UIButton *verifyButton;

/** 图片 */
@property (nonatomic, strong) UIImage *targetImage;

/** 是否传入了父试图 */
@property (nonatomic, assign) BOOL isCustomSuperView;

/** 是否自动保存截图到相册 */
@property (nonatomic, assign) BOOL isAutoSavaToAlbum;

/** 截图完成的block */
@property (nonatomic, copy) void (^completeHandler)(UIImage *image);

/** 取消的block */
@property (nonatomic, copy) void (^cancelHandler)(void);

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
