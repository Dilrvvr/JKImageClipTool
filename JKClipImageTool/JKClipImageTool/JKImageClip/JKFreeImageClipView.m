//
//  JKFreeImageClipView.m
//  JKClipImageTool
//
//  Created by albert on 2017/5/18.
//  Copyright © 2017年 安永博. All rights reserved.
//

#import "JKFreeImageClipView.h"
#import "JKFreeImageClipCoverView.h"
#import "JKFreeImageClipRectView.h"
#import "JKImageClipToolMacro.h"

#define JKFreeImageClipViewTopMinInset (JKFreeImageClipViewIsIphoneX ? 54 : 30)

@interface JKFreeImageClipView () <UIScrollViewDelegate>
{
    CGFloat maxX;
    CGFloat maxY;
    CGFloat minX;
    CGFloat minY;
    CGFloat maxW;
    CGFloat maxH;
    CGFloat minWH;
    CGFloat startPicW;
    CGFloat startPicH;
    BOOL isPanning;
}
/** scrollView */
@property (nonatomic, weak) UIScrollView *scrollView;

/** imageView */
@property (nonatomic, weak) UIImageView *imageView;

/** shapeLayer */
@property (nonatomic, strong) CAShapeLayer *shapeLayer;

/** bottomView */
@property (nonatomic, weak) UIView *bottomView;

/** 遮盖view */
@property (nonatomic, weak) JKFreeImageClipCoverView *coverView;

/** rectView */
@property (nonatomic, weak) JKFreeImageClipRectView *rectView;

/** 截图完成的block */
@property (nonatomic, copy) void (^complete)(UIImage *image);

/** 取消的block */
@property (nonatomic, copy) void (^cancel)(void);

/** 图片 */
@property (nonatomic, strong) UIImage *image;

/** 拖动的角 */
@property (nonatomic, assign) int startCorner;

/** 是否自动保存截图到相册 */
@property (nonatomic, assign) BOOL autoSavaToAlbum;
@end

// 通用间距
static CGFloat const commonMargin_ = 20;


@implementation JKFreeImageClipView

static BOOL isClip = YES;

/**
 * 自由裁剪图片
 * image : 要裁剪的图片
 * autoSavaToAlbum : 是否自动将截图保存到相册
 * complete : 截图完成的回调
 */
+ (void)showWithImage:(UIImage *)image autoSavaToAlbum:(BOOL)autoSavaToAlbum complete:(void(^)(UIImage *image))complete cancel:(void(^)(void))cancel{
    if (!image) {
        return;
    }
    
    isClip = YES;
    
    JKFreeImageClipView *icv = [[JKFreeImageClipView alloc] init];
    icv.image = image;
    icv.complete = complete;
    icv.cancel = cancel;
    icv.autoSavaToAlbum = autoSavaToAlbum;
    [[UIApplication sharedApplication].delegate.window addSubview:icv];
}

/**
 * 仅展示图片
 * image : 要展示的图片
 * complete : 点击确定的回调
 */
+ (void)showWithImage:(UIImage *)image complete:(void(^)(UIImage *image))complete cancel:(void(^)(void))cancel{
    if (!image) {
        return;
    }
    
    isClip = NO;
    
    JKFreeImageClipView *icv = [[JKFreeImageClipView alloc] init];
    icv.image = image;
    icv.complete = complete;
    icv.cancel = cancel;
    [[UIApplication sharedApplication].delegate.window addSubview:icv];
}

#pragma mark - 懒加载
- (UIScrollView *)scrollView{
    if (!_scrollView) {
        // scrollView
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:JKScreenBounds];
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
        
        [self insertSubview:scrollView atIndex:0];
        _scrollView = scrollView;
    }
    return _scrollView;
}

- (UIImageView *)imageView{
    if (!_imageView) {
        
        // imageView
        UIImageView *imageView = [[UIImageView alloc] init];
        [self.scrollView addSubview:imageView];
        imageView.backgroundColor = [UIColor clearColor];
        _imageView = imageView;
    }
    return _imageView;
}

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

- (void)initialization{
    self.backgroundColor = [UIColor blackColor];
    self.frame = JKScreenBounds;
    minWH = 60;
    
    [[UIView appearance] setExclusiveTouch:YES];
    
    // 双击手势
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap:)];
    doubleTap.numberOfTapsRequired = 2;
    [self addGestureRecognizer:doubleTap];
    
    // 遮盖view
    [self setupCoverView];
    
    // 底部控件
    [self setupBottomView];
}

- (void)setupCoverView{
    
    if (!isClip) return;
    
    // 遮盖view
    JKFreeImageClipCoverView *coverView = [[JKFreeImageClipCoverView alloc] init];
    coverView.center = self.center;
    [self addSubview:coverView];
    self.coverView = coverView;
    
    // 方框view
    JKFreeImageClipRectView *rectView = [[JKFreeImageClipRectView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
    rectView.center = self.center;
    [self addSubview:rectView];
    self.rectView = rectView;
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [rectView addGestureRecognizer:pan];
}

- (void)setupBottomView{
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, JKScreenH - 60 - (JKFreeImageClipViewIsIphoneX ? 34 : 0), JKScreenW, 60 + (JKFreeImageClipViewIsIphoneX ? 34 : 0))];
    bottomView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.85];
    [self addSubview:bottomView];
    self.bottomView = bottomView;
    
    UIButton *cancelButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
    [cancelButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    [cancelButton setTitle:@"取消" forState:(UIControlStateNormal)];
    cancelButton.frame = CGRectMake(0, 0, 90, 60);
    [bottomView addSubview:cancelButton];
    
    [cancelButton addTarget:self action:@selector(cancelButtonClick) forControlEvents:(UIControlEventTouchUpInside)];
    
    UIButton *verifyButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
    [verifyButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    [verifyButton setTitle:@"确定" forState:(UIControlStateNormal)];
    verifyButton.frame = CGRectMake(JKScreenW - 90, 0, 90, 60);
    [bottomView addSubview:verifyButton];
    
    [verifyButton addTarget:self action:@selector(verifyButtonClick) forControlEvents:(UIControlEventTouchUpInside)];
}

#pragma mark - 截图框处理
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    
    CGPoint touchPoint = [touch locationInView:self];
    
    //NSLog(@"touchPoint-->%@", NSStringFromCGPoint(touchPoint));
    
    self.startCorner = [self getPanStartPositionWithPoint:touchPoint];
}

- (void)pan:(UIPanGestureRecognizer *)pan{
    
    CGPoint point = [pan translationInView:pan.view];
    
    if (pan.state == UIGestureRecognizerStateBegan) {
        isPanning = YES;
    }
    
    switch (self.startCorner) {
        case 1: // 左上角
        {
            //NSLog(@"左上角");
            pan.view.frame = CGRectMake(
                                        (pan.view.frame.origin.x + point.x > maxX ? maxX : (pan.view.frame.origin.x + point.x < minX ? minX : pan.view.frame.origin.x + point.x)),
                                        (pan.view.frame.origin.y + point.y > maxY ? maxY : (pan.view.frame.origin.y + point.y < minY ? minY : pan.view.frame.origin.y + point.y)),
                                        (pan.view.frame.size.width - point.x < minWH ? minWH : (pan.view.frame.size.width - point.x > maxW ? maxW : pan.view.frame.size.width - point.x)),
                                        (pan.view.frame.size.height - point.y < minWH ? minWH : (pan.view.frame.size.height - point.y > maxH ? maxH : pan.view.frame.size.height - point.y))
                                        );
        }
            break;
            
        case 2: // 右上角
        {
            //NSLog(@"右上角");
            pan.view.frame = CGRectMake(
                                        pan.view.frame.origin.x,
                                        (pan.view.frame.origin.y + point.y > maxY ? maxY : (pan.view.frame.origin.y + point.y < minY ? minY : pan.view.frame.origin.y + point.y)),
                                        (pan.view.frame.size.width + point.x < minWH ? minWH : (pan.view.frame.size.width + point.x > maxW ? maxW : pan.view.frame.size.width + point.x)),
                                        (pan.view.frame.size.height - point.y < minWH ? minWH : (pan.view.frame.size.height - point.y > maxH ? maxH : pan.view.frame.size.height - point.y))
                                        );
        }
            break;
            
        case 3: // 右下角
        {
            //NSLog(@"右下角");
            pan.view.frame = CGRectMake(
                                        pan.view.frame.origin.x,
                                        pan.view.frame.origin.y,
                                        (pan.view.frame.size.width + point.x < minWH ? minWH : (pan.view.frame.size.width + point.x > maxW ? maxW : pan.view.frame.size.width + point.x)),
                                        (pan.view.frame.size.height + point.y < minWH ? minWH : (pan.view.frame.size.height + point.y > maxH ? maxH : pan.view.frame.size.height + point.y))
                                        );
        }
            break;
            
        case 4: // 左下角
        {
            //NSLog(@"左下角");
            pan.view.frame = CGRectMake(
                                        (pan.view.frame.origin.x + point.x > maxX ? maxX : (pan.view.frame.origin.x + point.x < minX ? minX : pan.view.frame.origin.x + point.x)),
                                        pan.view.frame.origin.y,
                                        (pan.view.frame.size.width - point.x < minWH ? minWH : (pan.view.frame.size.width - point.x > maxW ? maxW : pan.view.frame.size.width - point.x)),
                                        (pan.view.frame.size.height + point.y < minWH ? minWH : (pan.view.frame.size.height + point.y > maxH ? maxH : pan.view.frame.size.height + point.y))
                                        );
        }
            break;
            
        case 5: // 中间
        {
            //NSLog(@"中间");
            pan.view.transform = CGAffineTransformTranslate(pan.view.transform, point.x, point.y);
            pan.view.frame = CGRectMake(
                                        (pan.view.frame.origin.x > maxX ? maxX : (pan.view.frame.origin.x < minX ? minX : pan.view.frame.origin.x)),
                                        (pan.view.frame.origin.y > maxY ? maxY : (pan.view.frame.origin.y < minY ? minY : pan.view.frame.origin.y)),
                                        pan.view.frame.size.width,
                                        pan.view.frame.size.height
                                        );
        }
            break;
        default:
            break;
    }
    
    //
    
    self.coverView.transparentRect = pan.view.frame;
    
    [pan setTranslation:CGPointZero inView:pan.view];
    
    if (pan.state == UIGestureRecognizerStateEnded) {
        //NSLog(@"结束拖拽转换坐标--->%@", NSStringFromCGRect([self.scrollView convertRect:self.imageView.frame toView:self]));
        self.scrollView.contentInset = UIEdgeInsetsMake(self.rectView.frame.origin.y, self.rectView.frame.origin.x, JKScreenH - CGRectGetMaxY(self.rectView.frame), JKScreenW - CGRectGetMaxX(self.rectView.frame));
        self.scrollView.minimumZoomScale = (self.rectView.frame.size.width / startPicW < (self.rectView.frame.size.height / startPicH) ? (self.rectView.frame.size.height / startPicH) : self.rectView.frame.size.width / startPicW);
        isPanning = NO;
    }
}

// 按照顺时针1、2、3、4判断是哪个角 5代表中间
- (int)getPanStartPositionWithPoint:(CGPoint)point{
    if ([self.rectView.top_left_imageView pointInside:[self convertPoint:point toView:self.rectView.top_left_imageView] withEvent:nil]) {
        
        maxX = CGRectGetMaxX(self.rectView.frame) - minWH;
        maxY = CGRectGetMaxY(self.rectView.frame) - minWH;
        CGRect rect = [self.scrollView convertRect:self.imageView.frame toView:self];
        minX = rect.origin.x < commonMargin_ ? commonMargin_ : rect.origin.x;
        minY = rect.origin.y < JKFreeImageClipViewTopMinInset ? JKFreeImageClipViewTopMinInset : rect.origin.y;
        maxW = CGRectGetMaxX(self.rectView.frame) - minX;
        maxH = CGRectGetMaxY(self.rectView.frame) - minY;
        return 1;
    }
    
    if ([self.rectView.top_right_imageView pointInside:[self convertPoint:point toView:self.rectView.top_right_imageView] withEvent:nil]) {
        
        maxY = CGRectGetMaxY(self.rectView.frame) - minWH;
        CGRect rect = [self.scrollView convertRect:self.imageView.frame toView:self];
//        minX = rect.origin.x < commonMargin_ ? commonMargin_ : rect.origin.x;
        minY = rect.origin.y < JKFreeImageClipViewTopMinInset ? JKFreeImageClipViewTopMinInset : rect.origin.y;
        maxW = (CGRectGetMaxX(rect) > JKScreenW - commonMargin_ ? JKScreenW - commonMargin_ : CGRectGetMaxX(rect)) - self.rectView.frame.origin.x;
        maxH = CGRectGetMaxY(self.rectView.frame) - minY;
        return 2;
    }
    
    if ([self.rectView.bottom_right_imageView pointInside:[self convertPoint:point toView:self.rectView.bottom_right_imageView] withEvent:nil]) {
        
        CGRect rect = [self.scrollView convertRect:self.imageView.frame toView:self];
        maxW = (CGRectGetMaxX(rect) > JKScreenW - commonMargin_ ? JKScreenW - commonMargin_ : CGRectGetMaxX(rect)) - self.rectView.frame.origin.x;
        maxH = (CGRectGetMaxY(rect) > JKScreenH - JKFreeImageClipViewBottomViewH - commonMargin_ ? JKScreenH - JKFreeImageClipViewBottomViewH - commonMargin_ : CGRectGetMaxY(rect)) - self.rectView.frame.origin.y;
        return 3;
    }
    
    if ([self.rectView.bottom_left_imageView pointInside:[self convertPoint:point toView:self.rectView.bottom_left_imageView] withEvent:nil]) {
        
        maxX = CGRectGetMaxX(self.rectView.frame) - minWH;
        CGRect rect = [self.scrollView convertRect:self.imageView.frame toView:self];
        minX = rect.origin.x < commonMargin_ ? commonMargin_ : rect.origin.x;
        
        maxW = CGRectGetMaxX(self.rectView.frame) - minX;
        maxH = (CGRectGetMaxY(rect) > JKScreenH - JKFreeImageClipViewBottomViewH - commonMargin_ ? JKScreenH - JKFreeImageClipViewBottomViewH - commonMargin_ : CGRectGetMaxY(rect)) - self.rectView.frame.origin.y;
        return 4;
    }
    
    if ([self.rectView.middle_imageView pointInside:[self convertPoint:point toView:self.rectView.middle_imageView] withEvent:nil]) {
        
        CGRect rect = [self.scrollView convertRect:self.imageView.frame toView:self];
        minX = rect.origin.x < commonMargin_ ? commonMargin_ : rect.origin.x;
        minY = rect.origin.y < JKFreeImageClipViewTopMinInset ? JKFreeImageClipViewTopMinInset : rect.origin.y;
        
        
        maxX = CGRectGetMaxX(rect) > JKScreenW - commonMargin_ ? JKScreenW - commonMargin_ - self.rectView.frame.size.width : CGRectGetMaxX(rect) - self.rectView.frame.size.width;
        maxY = CGRectGetMaxY(rect) > JKScreenH - JKFreeImageClipViewBottomViewH - commonMargin_ ? JKScreenH - JKFreeImageClipViewBottomViewH - commonMargin_ - self.rectView.frame.size.height : CGRectGetMaxY(rect) - self.rectView.frame.size.height;
        
//        maxW = CGRectGetMaxX(self.rectView.frame) - minX;
//        maxH = (CGRectGetMaxY(rect) > JKScreenH - JKFreeImageClipViewBottomViewH - commonMargin_ ? JKScreenH - JKFreeImageClipViewBottomViewH - commonMargin_ : CGRectGetMaxY(rect)) - self.rectView.frame.origin.y;
        return 5;
    }
    
    return 0;
}

#pragma mark - 重写系统方法
- (void)willMoveToSuperview:(UIView *)newSuperview{
    [super willMoveToSuperview:newSuperview];
    
    if (!newSuperview) {
        return;
    }
    self.bottomView.userInteractionEnabled = NO;
    
    self.frame = CGRectMake(JKScreenW, 0, JKScreenW, JKScreenH);
    
    [UIView animateWithDuration:0.25 animations:^{
        self.frame = JKScreenBounds;
    }];
}

- (void)didMoveToSuperview{
    [super didMoveToSuperview];
    if (!self.superview) {
        return;
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:(UIStatusBarAnimationSlide)];
        CGRect rect = [self convertRect:self.imageView.frame toView:self];
        rect.origin.x = -self.scrollView.contentOffset.x;
        rect.origin.y = -self.scrollView.contentOffset.y;
        //NSLog(@"转换--->%@", NSStringFromCGRect(rect));
        
        [UIView animateWithDuration:0.25 animations:^{
            [UIView setAnimationCurve:(UIViewAnimationCurveEaseIn)];
            self.rectView.frame = rect;
            [self.rectView layoutIfNeeded];
            
        } completion:^(BOOL finished) {
            self.coverView.frame = JKScreenBounds;
            self.coverView.transparentRect = self.rectView.frame;
            self.bottomView.userInteractionEnabled = YES;
        }];
        
    });
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    self.scrollView.frame = self.bounds;
}

#pragma mark - 设置图片
- (void)setImage:(UIImage *)image{
    if (!image) {
        return;
    }
    
    _image = image;
    
    [self calculateImageViewSize];
    
    self.imageView.image = image;
}

- (void)calculateImageViewSize{
    
    //图片要显示的尺寸
    CGFloat pictureW = JKScreenW - commonMargin_ * 2;
    CGFloat pictureH = pictureW * self.image.size.height / self.image.size.width;
    
    if (pictureH > JKScreenH - JKFreeImageClipViewBottomViewH - commonMargin_ - JKFreeImageClipViewTopMinInset) {//图片高过屏幕
        
        pictureH = JKScreenH - JKFreeImageClipViewBottomViewH - commonMargin_ - JKFreeImageClipViewTopMinInset;
        pictureW = pictureH * self.image.size.width / self.image.size.height;
        
        self.imageView.frame = CGRectMake(0, 0, pictureW, pictureH);
        //设置scrollView的contentSize
        //        self.scrollView.contentSize = CGSizeMake(pictureW, pictureH);
        //        //NSLog(@"更新了contentSize");
        
    }else{//图片不高于屏幕
        
        self.imageView.frame = CGRectMake(0, 0, pictureW, pictureH);//CGSizeMake(pictureW, pictureH);
        //图片显示在中间
        //        self.imageView.center= CGPointMake(JKScreenW * 0.5, JKScreenH * 0.5);
    }
    //设置scrollView的contentSize
    self.scrollView.contentSize = CGSizeMake(pictureW, pictureH);
    self.scrollView.maximumZoomScale = (JKScreenW - commonMargin_ * 2) * 3 / ((pictureW >= pictureH) ? pictureH : pictureW);
    
    startPicW = pictureW;
    startPicH = pictureH;
    
    [self setInset];
    
    self.scrollView.contentOffset = CGPointMake(0, -self.scrollView.contentInset.top + (self.imageView.frame.size.height - JKScreenW) * 0.5);
}

#pragma mark - 点击事件
- (void)doubleTap:(UITapGestureRecognizer *)doubleTap{
    CGPoint touchPoint = [doubleTap locationInView:self.imageView];
    
    CGPoint point = [self.imageView convertPoint:touchPoint fromView:self.imageView];
    
    if (![self.imageView pointInside:point withEvent:nil]) {
        return;
    }
    
    if (!isClip) {
        
        self.scrollView.zoomScale == 1 ? [self.scrollView zoomToRect:CGRectMake(touchPoint.x - 15, touchPoint.y - 15, 30, 30) animated:YES] : [self.scrollView setZoomScale:1 animated:YES];
        
        return;
    }
    
   
    if (self.imageView.frame.size.width <= self.rectView.frame.size.width || self.imageView.frame.size.height <= self.rectView.frame.size.height) {
        
        // 双击放大
        [self.scrollView zoomToRect:CGRectMake(touchPoint.x - 15, touchPoint.y - 15, 30, 30) animated:YES];
        return;
    }
    
    // 双击缩小
    CGFloat scaleW = self.imageView.frame.size.width / self.rectView.frame.size.width;
    CGFloat scaleH = self.imageView.frame.size.height / self.rectView.frame.size.height;
    CGFloat scale = (scaleW < scaleH ? (self.rectView.frame.size.width / startPicW) : (self.rectView.frame.size.height / startPicH));
    [self.scrollView setZoomScale:scale animated:YES];
}

- (void)cancelButtonClick{
    if (self.scrollView.isDragging || self.scrollView.isDecelerating || self.scrollView.isZooming || isPanning) {
        return;
    }
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    
    self.userInteractionEnabled = NO;
    
    [UIView animateWithDuration:0.25 animations:^{
        self.frame = CGRectMake(JKScreenW, 0, JKScreenW, JKScreenH);
        
    } completion:^(BOOL finished) {
        
        !self.cancel ? : self.cancel();
        [self removeFromSuperview];
    }];
}

- (void)verifyButtonClick{
    if (self.scrollView.isDragging || self.scrollView.isDecelerating || self.scrollView.isZooming || isPanning) {
        return;
    }
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    
    self.userInteractionEnabled = NO;
    
    [UIView animateWithDuration:0.25 animations:^{
        self.frame = CGRectMake(JKScreenW, 0, JKScreenW, JKScreenH);
        
    } completion:^(BOOL finished) {
        
        !self.complete ? : self.complete(isClip ? [self clipImage] : self.image);
        
        [self removeFromSuperview];
    }];
}

- (UIImage *)clipImage{
    //    if (self.imageView.frame.size.height < JKScreenW) {
    
    self.shapeLayer.hidden = YES;
    
    self.bottomView.hidden = YES;
    self.coverView.hidden = YES;
    self.rectView.hidden = YES;
    
    // NO代表透明
    UIGraphicsBeginImageContextWithOptions(self.frame.size, NO, 0.0);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    [self.layer renderInContext:ctx];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    CGRect rect = CGRectMake(self.rectView.frame.origin.x * JKScreenScale, self.rectView.frame.origin.y * JKScreenScale, self.rectView.frame.size.width * JKScreenScale, self.rectView.frame.size.height * JKScreenScale);
    
    //NSLog(@"图片尺寸--->%@", NSStringFromCGSize(image.size));
    //NSLog(@"截取范围--->%@", NSStringFromCGRect(rect));
    
    CGImageRef imageRef = CGImageCreateWithImageInRect(image.CGImage, rect);
    
    UIImage *newImage = [UIImage imageWithCGImage:imageRef];
    
    CGImageRelease(imageRef);
    
    if (self.autoSavaToAlbum) {
        UIImageWriteToSavedPhotosAlbum(newImage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    }
    
    return newImage;
    //    }
    //
    //    //NSLog(@"图片尺寸--->%@", NSStringFromCGSize(self.image.size));
    //
    //    CGRect rect = CGRectMake(0, (JKScreenH - JKScreenW) * 0.5, JKScreenW, JKScreenW);
    //
    //    CGRect convertRect = [self convertRect:rect toView:self.imageView];
    //    //NSLog(@"转换后范围--->%@", NSStringFromCGRect(convertRect));
    //
    //    convertRect = CGRectMake(
    //                             convertRect.origin.x / self.imageView.frame.size.width * self.image.size.width * JKScreenScale,
    //                             convertRect.origin.y / self.imageView.frame.size.height * self.image.size.height * JKScreenScale,
    //                             convertRect.size.width / self.imageView.frame.size.width * self.image.size.width * JKScreenScale,
    //                             convertRect.size.width / self.imageView.frame.size.width * self.image.size.width * JKScreenScale);
    //    //NSLog(@"截取范围--->%@", NSStringFromCGRect(rect));
    //
    //    CGImageRef imageRef = CGImageCreateWithImageInRect(self.image.CGImage, convertRect);
    //
    //    UIImage *newImage = [UIImage imageWithCGImage:imageRef];
    //
    //    CGImageRelease(imageRef);
    //
    //    return newImage;
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    if (error) {
        //NSLog(@"自动保存截图失败！");
    }
    //NSLog(@"自动保存截图成功！");
}

#pragma mark - scrollView delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //NSLog(@"%@", NSStringFromCGPoint(scrollView.contentOffset));
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return self.imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView{
//    [self setInset];
    //NSLog(@"图片frame--->%@", NSStringFromCGRect(self.imageView.frame));
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale{
    
    if (!isClip) return;
    
    self.scrollView.contentInset = UIEdgeInsetsMake(self.rectView.frame.origin.y, self.rectView.frame.origin.x, JKScreenH - CGRectGetMaxY(self.rectView.frame), JKScreenW - CGRectGetMaxX(self.rectView.frame));
}

- (void)setInset{
    
    // 计算内边距，注意只能使用frame
    CGFloat offsetX = (JKScreenW - self.imageView.frame.size.width) * 0.5;
    CGFloat offsetY = (JKScreenH - JKFreeImageClipViewBottomViewH - commonMargin_ - JKFreeImageClipViewTopMinInset - self.imageView.frame.size.height) * 0.5;
    
    // 当小于0的时候，放大的图片将无法滚动，因为内边距为负数时限制了它可以滚动的范围
    offsetX = (offsetX < commonMargin_) ? commonMargin_ : offsetX;
    offsetY = (offsetY < JKFreeImageClipViewTopMinInset) ? JKFreeImageClipViewTopMinInset : offsetY;
    
    self.scrollView.contentInset = UIEdgeInsetsMake(offsetY, offsetX, JKFreeImageClipViewBottomViewH + commonMargin_, offsetX);//UIEdgeInsets(top: offsetY, left: offsetX, bottom: offsetY, right: offsetX)
}

- (void)dealloc{
    //NSLog(@"%d, %s",__LINE__, __func__);
}
@end
