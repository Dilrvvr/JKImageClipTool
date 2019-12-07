//
//  JKClipImageBaseView.m
//  JKClipImageTool
//
//  Created by albert on 2019/12/7.
//  Copyright © 2019 安永博. All rights reserved.
//

#import "JKClipImageBaseView.h"

@interface JKClipImageBaseView ()

@end

@implementation JKClipImageBaseView


#pragma mark
#pragma mark - 生命周期

- (void)dealloc{
    
    NSLog(@"[ClassName: %@], %d, %s", NSStringFromClass([self class]), __LINE__, __func__);
}

#pragma mark
#pragma mark - 初始化

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initialization];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        [self initialization];
    }
    return self;
}

/** 初始化自身属性 交给子类重写 super自动调用该方法 */
- (void)initializeProperty{
    
}

/** 构造函数初始化时调用 注意调用super */
- (void)initialization{
    
    [self initializeProperty];
    [self createUI];
    [self layoutUI];
    [self initializeUIData];
}

/** 创建UI 交给子类重写 super自动调用该方法 */
- (void)createUI{
    
    UIView *backgroundView = [[UIView alloc] init];
    [self addSubview:backgroundView];
    _backgroundView = backgroundView;
    
    UIView *contentView = [[UIView alloc] init];
    [self addSubview:contentView];
    _contentView = contentView;
    
    [self createBottomControlUI];
}

- (void)createBottomControlUI{
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, JKClipImageScreenHeight - 60 - (JKClipImageIsDeviceX() ? 34 : 0), JKClipImageScreenWidth, 60 + (JKClipImageIsDeviceX() ? 34 : 0))];
    bottomView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.85];
    [self.contentView addSubview:bottomView];
    _bottomView = bottomView;
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, JKClipImageScreenWidth, 0.5)];
    lineView.userInteractionEnabled = NO;
    lineView.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.5];
    [self.bottomView addSubview:lineView];
    
    UIButton *cancelButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
    [cancelButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    [cancelButton setTitle:@"取消" forState:(UIControlStateNormal)];
    cancelButton.frame = CGRectMake(0, 0, 90, 60);
    [bottomView addSubview:cancelButton];
    
    [cancelButton addTarget:self action:@selector(cancelButtonClick) forControlEvents:(UIControlEventTouchUpInside)];
    
    UIButton *verifyButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
    [verifyButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    [verifyButton setTitle:@"确定" forState:(UIControlStateNormal)];
    verifyButton.frame = CGRectMake(JKClipImageScreenWidth - 90, 0, 90, 60);
    [bottomView addSubview:verifyButton];
    
    [verifyButton addTarget:self action:@selector(verifyButtonClick) forControlEvents:(UIControlEventTouchUpInside)];
}

/** 布局UI 交给子类重写 super自动调用该方法 */
- (void)layoutUI{
    
}

/** 初始化UI数据 交给子类重写 super自动调用该方法 */
- (void)initializeUIData{
    
    [self.contentView bringSubviewToFront:self.bottomView];
}

#pragma mark
#pragma mark - Override

- (void)layoutSubviews{
    [super layoutSubviews];
    
    self.backgroundView.frame = self.bounds;
    
    self.contentView.frame = self.bounds;
}

#pragma mark
#pragma mark - 点击事件


#pragma mark
#pragma mark - 发送请求


#pragma mark
#pragma mark - 处理数据


#pragma mark
#pragma mark - 赋值

#pragma mark
#pragma mark - JKImageClipActionProtocol

- (void)hideBottomView{
    
    self.bottomView.hidden = YES;
}

- (void)cancelButtonClick {
    
}


- (void)enableDeallocLog {
    
}


- (void)verifyButtonClick {
    
}



#pragma mark
#pragma mark - Property

@end
