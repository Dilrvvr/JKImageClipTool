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
    
    [self setExclusiveTouch:YES];
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
    
    UIView *bottomControlView = [[UIView alloc] initWithFrame:CGRectMake(0, JKClipImageScreenHeight - 60 - (JKClipImageIsDeviceX() ? 34 : 0), JKClipImageScreenWidth, 60 + (JKClipImageIsDeviceX() ? 34 : 0))];
    bottomControlView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.85];
    [self.contentView addSubview:bottomControlView];
    _bottomControlView = bottomControlView;
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, JKClipImageScreenWidth, 0.5)];
    lineView.userInteractionEnabled = NO;
    lineView.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.5];
    [self.bottomControlView addSubview:lineView];
    
    UIButton *cancelButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
    [cancelButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    [cancelButton setTitle:@"取消" forState:(UIControlStateNormal)];
    cancelButton.frame = CGRectMake(0, 0, 90, 60);
    [bottomControlView addSubview:cancelButton];
    _cancelButton = cancelButton;
    
    [cancelButton addTarget:self action:@selector(cancelButtonClick) forControlEvents:(UIControlEventTouchUpInside)];
    
    UIButton *verifyButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
    [verifyButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    [verifyButton setTitle:@"确定" forState:(UIControlStateNormal)];
    verifyButton.frame = CGRectMake(JKClipImageScreenWidth - 90, 0, 90, 60);
    [bottomControlView addSubview:verifyButton];
    _verifyButton = verifyButton;
    
    [verifyButton addTarget:self action:@selector(verifyButtonClick) forControlEvents:(UIControlEventTouchUpInside)];
}

/** 布局UI 交给子类重写 super自动调用该方法 */
- (void)layoutUI{
    
}

/** 初始化UI数据 交给子类重写 super自动调用该方法 */
- (void)initializeUIData{
    
    [self.contentView bringSubviewToFront:self.bottomControlView];
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
#pragma mark - JKClipImageProtocol

- (void)cancelButtonClick{
    
}

- (void)verifyButtonClick{
    
}

- (void)hideBottomView{
    
    self.bottomControlView.hidden = YES;
}



#pragma mark
#pragma mark - Property

- (UIScrollView *)scrollView{
    if (!_scrollView) {
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:JKClipImageScreenBounds];
        scrollView.delegate = self;
        scrollView.backgroundColor = [UIColor clearColor];
        
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.showsHorizontalScrollIndicator = NO;
        
        scrollView.minimumZoomScale = 1;
        
        scrollView.alwaysBounceVertical = YES;
        scrollView.alwaysBounceHorizontal = YES;
        
        SEL selector = NSSelectorFromString(@"setContentInsetAdjustmentBehavior:");
        
        if ([scrollView respondsToSelector:selector]) {
            
            IMP imp = [scrollView methodForSelector:selector];
            void (*func)(id, SEL, NSInteger) = (void *)imp;
            func(scrollView, selector, 2);
            
            // [tbView performSelector:@selector(setContentInsetAdjustmentBehavior:) withObject:@(2)];
        }
        
        if (@available(iOS 13.0, *)) {
            [scrollView setAutomaticallyAdjustsScrollIndicatorInsets:NO];
        }
        
        [self.contentView insertSubview:scrollView atIndex:0];
        _scrollView = scrollView;
    }
    return _scrollView;
}

- (UIImageView *)imageView{
    if (!_imageView) {
        UIImageView *imageView = [[UIImageView alloc] init];
        [self.scrollView addSubview:imageView];
        imageView.backgroundColor = [UIColor clearColor];
        _imageView = imageView;
    }
    return _imageView;
}

@end
