//
//  JKClipImageFreeTypeView.m
//  JKClipImageTool
//
//  Created by albert on 2017/5/18.
//  Copyright © 2017年 安永博. All rights reserved.
//

#import "JKClipImageFreeTypeView.h"
#import "JKClipImageFreeTypeCoverView.h"
#import "JKClipImageFreeTypeRectView.h"
#import "JKClipImageConst.h"

@interface JKClipImageFreeTypeView () <UIScrollViewDelegate>
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
    
    CGFloat JKFreeImageClipViewTopMinInset;
    CGFloat JKFreeImageClipViewBottomViewH;
}

/** 遮盖view */
@property (nonatomic, weak) JKClipImageFreeTypeCoverView *coverView;

/** rectView */
@property (nonatomic, weak) JKClipImageFreeTypeRectView *rectView;

/** 拖动的角 */
@property (nonatomic, assign) int startCorner;

/** 是否仅展示图片 */
@property (nonatomic, assign) BOOL isJustShowImage;
@end

/// 通用间距
static CGFloat const JKClipImageFreeTypeViewCommonMargin = 20;

@implementation JKClipImageFreeTypeView

/**
 * 自由裁剪图片
 * superView : 父视图
 * targetImage : 要处理的图片
 * isJustShowImage : 是否仅展示图片
 * isShowNavigationBar : 是否有导航条，注意必须有父视图，这里才有效，设为YES则会隐藏底部确定取消按钮
 * isAutoSavaToAlbum : 是否自动将截图保存到相册
 * cancelHandler : 点击取消的回调
 * completeHandler : 截图完成的回调
 */
+ (instancetype)showWithSuperView:(UIView *)superView
                      targetImage:(UIImage *)targetImage
                  isJustShowImage:(BOOL)isJustShowImage
              isShowNavigationBar:(BOOL)isShowNavigationBar
                isAutoSavaToAlbum:(BOOL)isAutoSavaToAlbum
                    cancelHandler:(void(^)(void))cancelHandler
                  completeHandler:(void(^)(UIImage *image))completeHandler{
    
    if (!targetImage) { return nil; }
    
    JKClipImageFreeTypeView *icv = [[JKClipImageFreeTypeView alloc] init];
    
    icv->JKFreeImageClipViewTopMinInset = (JKClipImageIsDeviceX() ? 54 : 30);
    icv->JKFreeImageClipViewBottomViewH = (JKClipImageIsDeviceX() ? 94 : 60);
    
    if (superView && isShowNavigationBar) {
        
        icv->JKFreeImageClipViewTopMinInset = (JKClipImageIsDeviceX() ? 98 : 78);
        icv->JKFreeImageClipViewBottomViewH = (JKClipImageIsDeviceX() ? 34 : 0);
    }
    
    icv.isJustShowImage = isJustShowImage;
    icv.isAutoSavaToAlbum = isAutoSavaToAlbum;
    icv.cancelHandler = cancelHandler;
    icv.completeHandler = completeHandler;
    icv.targetImage = targetImage;
    
    if (superView) {
        
        icv.isCustomSuperView = YES;
        
        [superView addSubview:icv];
        
    } else {
        
        [[UIApplication sharedApplication].delegate.window addSubview:icv];
    }
    
    return icv;
}

#pragma mark
#pragma mark - 初始化

/** 初始化自身属性 */
- (void)initializeProperty{
    [super initializeProperty];
    
    self.frame = JKClipImageScreenBounds;
    
    self.backgroundColor = [UIColor blackColor];
    
    minWH = 60;
}

/** 构造函数初始化时调用 注意调用super */
- (void)initialization{
    [super initialization];
    
    // 双击手势
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap:)];
    doubleTap.numberOfTapsRequired = 2;
    [self.contentView addGestureRecognizer:doubleTap];
}

/** 创建UI */
- (void)createUI{
    [super createUI];
    
    // 遮盖view
    [self createCoverViewUI];
}

- (void)createCoverViewUI{
    
    if (self.isJustShowImage) return;
    
    // 遮盖view
    JKClipImageFreeTypeCoverView *coverView = [[JKClipImageFreeTypeCoverView alloc] init];
    coverView.center = self.center;
    [self.contentView addSubview:coverView];
    _coverView = coverView;
    
    // 方框view
    JKClipImageFreeTypeRectView *rectView = [[JKClipImageFreeTypeRectView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
    rectView.center = self.center;
    [self.contentView addSubview:rectView];
    _rectView = rectView;
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [rectView addGestureRecognizer:pan];
}

/** 布局UI */
- (void)layoutUI{
    [super layoutUI];
    
}

/** 初始化UI数据 */
- (void)initializeUIData{
    [super initializeUIData];
    
}

#pragma mark
#pragma mark - Override

- (void)willMoveToSuperview:(UIView *)newSuperview{
    [super willMoveToSuperview:newSuperview];
    
    if (!newSuperview) { return; }
    
    if (self.isCustomSuperView) {
        
        self.frame = JKClipImageScreenBounds;
        
        return;
    }
    
    self.bottomView.userInteractionEnabled = NO;
    
    self.frame = CGRectMake(JKClipImageScreenWidth, 0, JKClipImageScreenWidth, JKClipImageScreenHeight);
    
    [UIView animateWithDuration:0.25 animations:^{
        
        self.frame = JKClipImageScreenBounds;
        
    } completion:^(BOOL finished) {
        
        self.bottomView.userInteractionEnabled = YES;
    }];
}

- (void)didMoveToSuperview{
    [super didMoveToSuperview];
    
    if (!self.superview) { return; }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        CGRect rect = [self.scrollView convertRect:self.imageView.frame toView:self];
        
        [UIView animateWithDuration:0.25 animations:^{
            [UIView setAnimationCurve:(UIViewAnimationCurveEaseIn)];
            
            self.rectView.frame = rect;
            
            [self.rectView layoutIfNeeded];
            
        } completion:^(BOOL finished) {
            
            self.coverView.frame = JKClipImageScreenBounds;
            self.coverView.transparentRect = self.rectView.frame;
        }];
    });
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    self.scrollView.frame = self.bounds;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    
    UITouch *touch = [touches anyObject];
    
    CGPoint touchPoint = [touch locationInView:self];
    
    //NSLog(@"touchPoint-->%@", NSStringFromCGPoint(touchPoint));
    
    self.startCorner = [self getPanStartPositionWithPoint:touchPoint];
}

#pragma mark
#pragma mark - 点击事件

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
        self.scrollView.contentInset = UIEdgeInsetsMake(self.rectView.frame.origin.y, self.rectView.frame.origin.x, JKClipImageScreenHeight - CGRectGetMaxY(self.rectView.frame), JKClipImageScreenWidth - CGRectGetMaxX(self.rectView.frame));
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
        minX = rect.origin.x < JKClipImageFreeTypeViewCommonMargin ? JKClipImageFreeTypeViewCommonMargin : rect.origin.x;
        minY = rect.origin.y < JKFreeImageClipViewTopMinInset ? JKFreeImageClipViewTopMinInset : rect.origin.y;
        maxW = CGRectGetMaxX(self.rectView.frame) - minX;
        maxH = CGRectGetMaxY(self.rectView.frame) - minY;
        
        return 1;
    }
    
    if ([self.rectView.top_right_imageView pointInside:[self convertPoint:point toView:self.rectView.top_right_imageView] withEvent:nil]) {
        
        maxY = CGRectGetMaxY(self.rectView.frame) - minWH;
        CGRect rect = [self.scrollView convertRect:self.imageView.frame toView:self];
        //minX = rect.origin.x < JKClipImageFreeTypeViewCommonMargin ? JKClipImageFreeTypeViewCommonMargin : rect.origin.x;
        minY = rect.origin.y < JKFreeImageClipViewTopMinInset ? JKFreeImageClipViewTopMinInset : rect.origin.y;
        maxW = (CGRectGetMaxX(rect) > JKClipImageScreenWidth - JKClipImageFreeTypeViewCommonMargin ? JKClipImageScreenWidth - JKClipImageFreeTypeViewCommonMargin : CGRectGetMaxX(rect)) - self.rectView.frame.origin.x;
        maxH = CGRectGetMaxY(self.rectView.frame) - minY;
        return 2;
    }
    
    if ([self.rectView.bottom_right_imageView pointInside:[self convertPoint:point toView:self.rectView.bottom_right_imageView] withEvent:nil]) {
        
        CGRect rect = [self.scrollView convertRect:self.imageView.frame toView:self];
        maxW = (CGRectGetMaxX(rect) > JKClipImageScreenWidth - JKClipImageFreeTypeViewCommonMargin ? JKClipImageScreenWidth - JKClipImageFreeTypeViewCommonMargin : CGRectGetMaxX(rect)) - self.rectView.frame.origin.x;
        maxH = (CGRectGetMaxY(rect) > JKClipImageScreenHeight - JKFreeImageClipViewBottomViewH - JKClipImageFreeTypeViewCommonMargin ? JKClipImageScreenHeight - JKFreeImageClipViewBottomViewH - JKClipImageFreeTypeViewCommonMargin : CGRectGetMaxY(rect)) - self.rectView.frame.origin.y;
        
        return 3;
    }
    
    if ([self.rectView.bottom_left_imageView pointInside:[self convertPoint:point toView:self.rectView.bottom_left_imageView] withEvent:nil]) {
        
        maxX = CGRectGetMaxX(self.rectView.frame) - minWH;
        CGRect rect = [self.scrollView convertRect:self.imageView.frame toView:self];
        minX = rect.origin.x < JKClipImageFreeTypeViewCommonMargin ? JKClipImageFreeTypeViewCommonMargin : rect.origin.x;
        
        maxW = CGRectGetMaxX(self.rectView.frame) - minX;
        maxH = (CGRectGetMaxY(rect) > JKClipImageScreenHeight - JKFreeImageClipViewBottomViewH - JKClipImageFreeTypeViewCommonMargin ? JKClipImageScreenHeight - JKFreeImageClipViewBottomViewH - JKClipImageFreeTypeViewCommonMargin : CGRectGetMaxY(rect)) - self.rectView.frame.origin.y;
        
        return 4;
    }
    
    if ([self.rectView.center_imageView pointInside:[self convertPoint:point toView:self.rectView.center_imageView] withEvent:nil]) {
        
        CGRect rect = [self.scrollView convertRect:self.imageView.frame toView:self];
        minX = rect.origin.x < JKClipImageFreeTypeViewCommonMargin ? JKClipImageFreeTypeViewCommonMargin : rect.origin.x;
        minY = rect.origin.y < JKFreeImageClipViewTopMinInset ? JKFreeImageClipViewTopMinInset : rect.origin.y;
        
        maxX = CGRectGetMaxX(rect) > JKClipImageScreenWidth - JKClipImageFreeTypeViewCommonMargin ? JKClipImageScreenWidth - JKClipImageFreeTypeViewCommonMargin - self.rectView.frame.size.width : CGRectGetMaxX(rect) - self.rectView.frame.size.width;
        maxY = CGRectGetMaxY(rect) > JKClipImageScreenHeight - JKFreeImageClipViewBottomViewH - JKClipImageFreeTypeViewCommonMargin ? JKClipImageScreenHeight - JKFreeImageClipViewBottomViewH - JKClipImageFreeTypeViewCommonMargin - self.rectView.frame.size.height : CGRectGetMaxY(rect) - self.rectView.frame.size.height;
        
        //maxW = CGRectGetMaxX(self.rectView.frame) - minX;
        //maxH = (CGRectGetMaxY(rect) > JKClipImageScreenHeight - JKFreeImageClipViewBottomViewH - commonMargin_ ? JKClipImageScreenHeight - JKFreeImageClipViewBottomViewH - commonMargin_ : CGRectGetMaxY(rect)) - self.rectView.frame.origin.y;
        
        return 5;
    }
    
    return 0;
}

- (void)doubleTap:(UITapGestureRecognizer *)doubleTap{
    
    CGPoint touchPoint = [doubleTap locationInView:self.imageView];
    
    CGPoint point = [self.imageView convertPoint:touchPoint fromView:self.imageView];
    
    if (![self.imageView pointInside:point withEvent:nil]) { return; }
    
    if (self.isJustShowImage) {
        
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
    
    if (self.scrollView.isDragging ||
        self.scrollView.isDecelerating ||
        self.scrollView.isZooming ||
        isPanning) {
        
        return;
    }
    
    self.userInteractionEnabled = NO;
    
    if (self.isCustomSuperView) {
        
        !self.cancelHandler ? : self.cancelHandler();
        
        [self removeFromSuperview];
        
        return;
    }
    
    [UIView animateWithDuration:0.25 animations:^{
        
        self.frame = CGRectMake(JKClipImageScreenWidth, 0, JKClipImageScreenWidth, JKClipImageScreenHeight);
        
    } completion:^(BOOL finished) {
        
        !self.cancelHandler ? : self.cancelHandler();
        
        [self removeFromSuperview];
    }];
}

- (void)verifyButtonClick{
    
    if (self.scrollView.isDragging ||
        self.scrollView.isDecelerating ||
        self.scrollView.isZooming ||
        isPanning) {
        
        return;
    }
    
    self.userInteractionEnabled = NO;
    
    if (self.isCustomSuperView) {
        
        !self.completeHandler ? : self.completeHandler(self.isJustShowImage ? self.targetImage : [self clipImage]);
        
        [self removeFromSuperview];
        
        return;
    }
    
    [UIView animateWithDuration:0.25 animations:^{
        
        self.frame = CGRectMake(JKClipImageScreenWidth, 0, JKClipImageScreenWidth, JKClipImageScreenHeight);
        
    } completion:^(BOOL finished) {
        
        !self.completeHandler ? : self.completeHandler(self.isJustShowImage ? self.targetImage : [self clipImage]);
        
        [self removeFromSuperview];
    }];
}

#pragma mark
#pragma mark - 发送请求


#pragma mark
#pragma mark - 处理数据


#pragma mark
#pragma mark - 赋值

- (void)setTargetImage:(UIImage *)targetImage{
    
    if (!targetImage) { return; }
    
    [super setTargetImage:targetImage];
    
    [self calculateImageViewSize];
    
    self.imageView.image = targetImage;
}

#pragma mark
#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //NSLog(@"%@", NSStringFromCGPoint(scrollView.contentOffset));
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return self.imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView{
    //    [self calculateInset];
    //NSLog(@"图片frame--->%@", NSStringFromCGRect(self.imageView.frame));
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale{
    
    if (self.isJustShowImage) return;
    
    self.scrollView.contentInset = UIEdgeInsetsMake(self.rectView.frame.origin.y, self.rectView.frame.origin.x, JKClipImageScreenHeight - CGRectGetMaxY(self.rectView.frame), JKClipImageScreenWidth - CGRectGetMaxX(self.rectView.frame));
}


#pragma mark
#pragma mark - Property

#pragma mark - 点击事件

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    if (error) {
        //NSLog(@"自动保存截图失败！");
    }
    //NSLog(@"自动保存截图成功！");
}

#pragma mark
#pragma mark - Private Function

- (void)calculateImageViewSize{
    
    //图片要显示的尺寸
    CGFloat pictureW = JKClipImageScreenWidth - JKClipImageFreeTypeViewCommonMargin * 2;
    CGFloat pictureH = pictureW * self.targetImage.size.height / self.targetImage.size.width;
    
    if (pictureH > JKClipImageScreenHeight - JKFreeImageClipViewBottomViewH - JKClipImageFreeTypeViewCommonMargin - JKFreeImageClipViewTopMinInset) {//图片高过屏幕
        
        pictureH = JKClipImageScreenHeight - JKFreeImageClipViewBottomViewH - JKClipImageFreeTypeViewCommonMargin - JKFreeImageClipViewTopMinInset;
        pictureW = pictureH * self.targetImage.size.width / self.targetImage.size.height;
        
        self.imageView.frame = CGRectMake(0, 0, pictureW, pictureH);
        //设置scrollView的contentSize
        //        self.scrollView.contentSize = CGSizeMake(pictureW, pictureH);
        //        //NSLog(@"更新了contentSize");
        
    } else {//图片不高于屏幕
        
        self.imageView.frame = CGRectMake(0, 0, pictureW, pictureH);//CGSizeMake(pictureW, pictureH);
        //图片显示在中间
        //        self.imageView.center= CGPointMake(JKClipImageScreenWidth * 0.5, JKClipImageScreenHeight * 0.5);
    }
    
    //设置scrollView的contentSize
    self.scrollView.contentSize = CGSizeMake(pictureW, pictureH);
    self.scrollView.maximumZoomScale = (JKClipImageScreenWidth - JKClipImageFreeTypeViewCommonMargin * 2) * 3 / ((pictureW >= pictureH) ? pictureH : pictureW);
    
    startPicW = pictureW;
    startPicH = pictureH;
    
    [self calculateInset];
    
    self.scrollView.contentOffset = CGPointMake(0, -self.scrollView.contentInset.top + (self.imageView.frame.size.height - JKClipImageScreenWidth) * 0.5);
}

- (void)calculateInset{
    
    // 计算内边距，注意只能使用frame
    CGFloat offsetX = (JKClipImageScreenWidth - self.imageView.frame.size.width) * 0.5;
    CGFloat offsetY = (JKClipImageScreenHeight - JKFreeImageClipViewBottomViewH - JKClipImageFreeTypeViewCommonMargin - JKFreeImageClipViewTopMinInset - self.imageView.frame.size.height) * 0.5;
    
    // 当小于0的时候，放大的图片将无法滚动，因为内边距为负数时限制了它可以滚动的范围
    offsetX = (offsetX < JKClipImageFreeTypeViewCommonMargin) ? JKClipImageFreeTypeViewCommonMargin : offsetX;
    offsetY = (offsetY < JKFreeImageClipViewTopMinInset) ? JKFreeImageClipViewTopMinInset : offsetY;
    
    self.scrollView.contentInset = UIEdgeInsetsMake(offsetY, offsetX, JKFreeImageClipViewBottomViewH + JKClipImageFreeTypeViewCommonMargin, offsetX);//UIEdgeInsets(top: offsetY, left: offsetX, bottom: offsetY, right: offsetX)
}

- (UIImage *)clipImage{
    
    self.bottomView.hidden = YES;
    self.coverView.hidden = YES;
    self.rectView.hidden = YES;
    
    // NO代表透明
    UIGraphicsBeginImageContextWithOptions(self.imageView.bounds.size, NO, JKClipImageScreenScale);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    [self.imageView.layer renderInContext:ctx];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    CGRect rect = [self convertRect:self.rectView.frame toView:self.imageView];
    
    rect.origin.x = rect.origin.x < 0 ? 0 : rect.origin.x * JKClipImageScreenScale;
    rect.origin.y = rect.origin.y < 0 ? 0 : rect.origin.y * JKClipImageScreenScale;
    rect.size.width = rect.size.width > self.imageView.frame.size.width ? self.imageView.frame.size.width * JKClipImageScreenScale : rect.size.width * JKClipImageScreenScale;
    rect.size.height = rect.size.height > self.imageView.frame.size.height ? self.imageView.frame.size.height * JKClipImageScreenScale : rect.size.height * JKClipImageScreenScale;
    
    //NSLog(@"图片尺寸--->%@", NSStringFromCGSize(image.size));
    //NSLog(@"截取范围--->%@", NSStringFromCGRect(rect));
    
    CGImageRef imageRef = CGImageCreateWithImageInRect(image.CGImage, rect);
    
    UIImage *newImage = [UIImage imageWithCGImage:imageRef];
    
    CGImageRelease(imageRef);
    
    if (self.isAutoSavaToAlbum) {
        
        UIImageWriteToSavedPhotosAlbum(newImage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    }
    
    return newImage;
}
@end
