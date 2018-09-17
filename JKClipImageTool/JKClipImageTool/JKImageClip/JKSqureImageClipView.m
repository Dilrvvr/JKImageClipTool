//
//  JKSqureImageClipView.m
//  JKClipImageTool
//
//  Created by albert on 2017/5/17.
//  Copyright © 2017年 安永博. All rights reserved.
//

#import "JKSqureImageClipView.h"
#import "JKImageClipToolMacro.h"

@interface JKSqureImageClipView () <UICollectionViewDelegate>
{
    BOOL _enableDeallocLog;
    CGFloat maxH;
}
/** scrollView */
@property (nonatomic, weak) UIScrollView *scrollView;

/** imageView */
@property (nonatomic, weak) UIImageView *imageView;

/** shapeLayer */
@property (nonatomic, strong) CAShapeLayer *shapeLayer;

/** bottomView */
@property (nonatomic, weak) UIView *bottomView;

/** 截图完成的block */
@property (nonatomic, copy) void (^complete)(UIImage *image);

/** 取消的block */
@property (nonatomic, copy) void (^cancel)(void);

/** 图片 */
@property (nonatomic, strong) UIImage *image;

/** 是否裁剪为圆形 */
@property (nonatomic, assign) BOOL isCircle;

/** 是否自动保存截图到相册 */
@property (nonatomic, assign) BOOL autoSavaToAlbum;

/** 是否传入了父试图 */
@property (nonatomic, assign) BOOL isHaveSuperView;

/** 宽高比 */
@property (nonatomic, assign) CGSize cropSize;
@end

@implementation JKSqureImageClipView

/**
 * 裁剪正方形图片
 * image : 要裁剪的图片
 * isCircle : 是否裁剪为圆形
 * autoSavaToAlbum : 是否自动将截图保存到相册
 * complete : 截图完成的回调
 */
+ (instancetype)showWithImage:(UIImage *)image superView:(UIView *)superView isCircle:(BOOL)isCircle autoSavaToAlbum:(BOOL)autoSavaToAlbum complete:(void(^)(UIImage *image))complete cancel:(void(^)(void))cancel{
    
    if (!image) {
        return nil;
    }
    
    JKSqureImageClipView *icv = [[JKSqureImageClipView alloc] init];
    icv.isCircle = isCircle;
    icv.complete = complete;
    icv.cancel = cancel;
    icv.autoSavaToAlbum = autoSavaToAlbum;
    
    CGFloat WH = MIN(JKImageClipScreenW, JKImageClipScreenH);
    
    icv->_cropSize = CGSizeMake(WH, WH);
    icv.image = image;
    
    if (superView) {
        
        icv.isHaveSuperView = YES;
        [superView addSubview:icv];
        
    }else{
        
        [[UIApplication sharedApplication].delegate.window addSubview:icv];
    }
    
    return icv;
}

/**
 * 裁剪正方形图片
 * image : 要裁剪的图片
 * cropSize : 要裁剪的宽高比
 * autoSavaToAlbum : 是否自动将截图保存到相册
 * complete : 截图完成的回调
 */
+ (instancetype)showWithImage:(UIImage *)image superView:(UIView *)superView cropSize:(CGSize)cropSize autoSavaToAlbum:(BOOL)autoSavaToAlbum complete:(void(^)(UIImage *image))complete cancel:(void(^)(void))cancel{
    
    if (!image || cropSize.width <= 0 || cropSize.height <= 0) {
        return nil;
    }
    
    JKSqureImageClipView *icv = [[JKSqureImageClipView alloc] init];
    icv.isCircle = NO;
    icv.complete = complete;
    icv.cancel = cancel;
    icv.autoSavaToAlbum = autoSavaToAlbum;
    
    icv.cropSize = cropSize;
    
    icv.image = image;
    
    if (superView) {
        
        icv.isHaveSuperView = YES;
        [superView addSubview:icv];
        
    }else{
        
        [[UIApplication sharedApplication].delegate.window addSubview:icv];
    }
    
    return icv;
}

- (CAShapeLayer *)shapeLayer{
    if (!_shapeLayer) {
        _shapeLayer = [CAShapeLayer layer];
        _shapeLayer.fillColor = [[UIColor blackColor] colorWithAlphaComponent:0.7].CGColor;
        _shapeLayer.fillRule = kCAFillRuleEvenOdd;
        //        _shapeLayer.lineWidth = 1;
        _shapeLayer.strokeColor = [UIColor whiteColor].CGColor;
        //        _shapeLayer.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7].CGColor;
        _shapeLayer.frame = JKImageClipScreenBounds;
        UIBezierPath *fullPath = [UIBezierPath bezierPathWithRect:CGRectMake(-1, -1, JKImageClipScreenW + 2, JKImageClipScreenH + 2)];
        
        UIBezierPath *path = nil;
        
        if (_isCircle) {
            
            path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(1, (JKImageClipScreenH - JKImageClipScreenW) * 0.5, JKImageClipScreenW - 2, JKImageClipScreenW) cornerRadius:(JKImageClipScreenW - 2) * 0.5];
            
        }else{
            
            CGFloat screenW = MIN(JKImageClipScreenW, JKImageClipScreenH);
            
            path = [UIBezierPath bezierPathWithRect:CGRectMake((screenW - self.cropSize.width) * 0.5 + 1, (JKFreeImageClipViewIsIphoneX ? 100 : 66) + (maxH - self.cropSize.height) * 0.5, self.cropSize.width - 2, self.cropSize.height)];
        }
        
        [fullPath appendPath:path];
        [fullPath setUsesEvenOddFillRule:YES];
        
        _shapeLayer.path = fullPath.CGPath;
        //        _shapeLayer.opacity = 0.4;
        [self.layer insertSublayer:_shapeLayer above:self.scrollView.layer];
    }
    return _shapeLayer;
}

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
    self.frame = JKImageClipScreenBounds;
    
    [self setExclusiveTouch:YES];
    
    CGFloat screenH = MAX(JKImageClipScreenW, JKImageClipScreenH);
    
    maxH = (JKFreeImageClipViewIsIphoneX ? screenH - 100 - 100 : screenH - 66 - 66);
    
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.delegate = self;
    scrollView.backgroundColor = [UIColor clearColor];
    
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    
    scrollView.minimumZoomScale = 1;
    scrollView.maximumZoomScale = 3;
    
    scrollView.alwaysBounceVertical = YES;
    scrollView.alwaysBounceHorizontal = YES;
    
    SEL selector = NSSelectorFromString(@"setContentInsetAdjustmentBehavior:");
    
    if ([scrollView respondsToSelector:selector]) {
        
        IMP imp = [scrollView methodForSelector:selector];
        void (*func)(id, SEL, NSInteger) = (void *)imp;
        func(scrollView, selector, 2);
        
        // [tbView performSelector:@selector(setContentInsetAdjustmentBehavior:) withObject:@(2)];
    }
    
    [self addSubview:scrollView];
    self.scrollView = scrollView;
    
    UIImageView *imageView = [[UIImageView alloc] init];
    [scrollView addSubview:imageView];
    imageView.backgroundColor = [UIColor clearColor];
    self.imageView = imageView;
    
    imageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap:)];
    doubleTap.numberOfTapsRequired = 2;
    [self addGestureRecognizer:doubleTap];
    
    [self setupBottomView];
}

- (void)setupBottomView{
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, JKImageClipScreenH - (JKFreeImageClipViewIsIphoneX ? 94 : 60), JKImageClipScreenW, (JKFreeImageClipViewIsIphoneX ? 94 : 60))];
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
    verifyButton.frame = CGRectMake(JKImageClipScreenW - 90, 0, 90, 60);
    [bottomView addSubview:verifyButton];
    
    [verifyButton addTarget:self action:@selector(verifyButtonClick) forControlEvents:(UIControlEventTouchUpInside)];
}

- (void)willMoveToSuperview:(UIView *)newSuperview{
    [super willMoveToSuperview:newSuperview];
    
    if (newSuperview == nil) {
        return;
    }
    
    [self shapeLayer];
    [self calculateImageViewSize];
    
    if (self.isHaveSuperView) {
        
        self.frame = JKImageClipScreenBounds;
        
        return;
    }
    
    self.bottomView.userInteractionEnabled = NO;
    
    self.frame = CGRectMake(JKImageClipScreenW, 0, JKImageClipScreenW, JKImageClipScreenH);
    
    [UIView animateWithDuration:0.25 animations:^{
        self.frame = JKImageClipScreenBounds;
        
    } completion:^(BOOL finished) {
        
        self.bottomView.userInteractionEnabled = YES;
    }];
}

- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    self.scrollView.frame = self.bounds;
}

- (void)setImage:(UIImage *)image{
    if (!image) {
        return;
    }
    
    _image = image;
    
    self.imageView.image = image;
}

- (void)setCropSize:(CGSize)cropSize{
    
    CGFloat W = cropSize.width;
    CGFloat H = cropSize.height;
    CGFloat scale = W / H;
    
    CGFloat screenW = MIN(JKImageClipScreenW, JKImageClipScreenH);
    
    W = screenW;
    H = W / scale;
    
    if (H > maxH) {
        
        H = maxH;
        W = H * scale;
    }
    
    _cropSize = CGSizeMake(W, H);
}

- (void)calculateImageViewSize{
    
    //图片要显示的尺寸
    CGFloat pictureW = self.cropSize.width;
    CGFloat pictureH = self.cropSize.width * self.image.size.height / self.image.size.width;
    
    if (pictureH < self.cropSize.height) {
        
        pictureW = pictureW * self.cropSize.height / pictureH;
        
        pictureH = self.cropSize.height;
    }
    
    self.imageView.frame = CGRectMake(0, 0, pictureW, pictureH);
    
    //设置scrollView的contentSize
    self.scrollView.contentSize = CGSizeMake(pictureW, pictureH);
    
    [self setInset];
    
    self.scrollView.contentOffset = CGPointMake(0, -self.scrollView.contentInset.top + (self.imageView.frame.size.height - self.cropSize.height) * 0.5);
}

#pragma mark - 点击事件
- (void)doubleTap:(UITapGestureRecognizer *)doubleTap{
    CGPoint touchPoint = [doubleTap locationInView:self.imageView];
    
    CGPoint point = [self.imageView convertPoint:touchPoint fromView:self.imageView];
    
    if (![self.imageView pointInside:point withEvent:nil]) {
        return;
    }
    
    // 双击缩小
    if (self.scrollView.zoomScale != 1) {
        [self.scrollView setZoomScale:1 animated:YES];
        
        return;
    }
    
    // 双击放大
    [self.scrollView zoomToRect:CGRectMake(touchPoint.x - 5, touchPoint.y - 5, 10, 10) animated:YES];
}

- (void)cancelButtonClick{
    if (self.scrollView.isDragging || self.scrollView.isDecelerating || self.scrollView.isZooming) {
        return;
    }
    
    self.userInteractionEnabled = NO;
    
    if (self.isHaveSuperView) {
        
        !self.cancel ? : self.cancel();
        
        [self removeFromSuperview];
        
        return;
    }
    
    [UIView animateWithDuration:0.25 animations:^{
        self.frame = CGRectMake(JKImageClipScreenW, 0, JKImageClipScreenW, JKImageClipScreenH);
        
    } completion:^(BOOL finished) {
        
        !self.cancel ? : self.cancel();
        [self removeFromSuperview];
    }];
}

- (void)verifyButtonClick{
    if (self.scrollView.isDragging || self.scrollView.isDecelerating || self.scrollView.isZooming) {
        return;
    }
    
    self.userInteractionEnabled = NO;
    
    if (self.isHaveSuperView) {
        
        !self.complete ? : self.complete([self clipImage]);
        
        [self removeFromSuperview];
        
        return;
    }
    
    [UIView animateWithDuration:0.25 animations:^{
        
        self.frame = CGRectMake(JKImageClipScreenW, 0, JKImageClipScreenW, JKImageClipScreenH);
        
    } completion:^(BOOL finished) {
        
        !self.complete ? : self.complete([self clipImage]);
        
        [self removeFromSuperview];
    }];
}

- (void)hideBottomView{
    
    self.bottomView.hidden = YES;
}

- (UIImage *)clipImage{
    //    if (self.imageView.frame.size.height < JKImageClipScreenW) {
    
    self.shapeLayer.hidden = YES;
    
    // NO代表透明
    UIGraphicsBeginImageContextWithOptions(self.imageView.frame.size, NO, 0.0);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    [self.imageView.layer renderInContext:ctx];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    CGRect rect1 = CGRectMake((JKImageClipScreenW - self.cropSize.width) * 0.5, (JKImageClipScreenH - self.cropSize.height) * 0.5, self.cropSize.width, self.cropSize.height);
    
    CGRect rect = [self convertRect:rect1 toView:self.imageView];
    
    rect.origin.x = rect.origin.x < 0 ? 0 : rect.origin.x * JKImageClipScreenScale;
    rect.origin.y = rect.origin.y < 0 ? 0 : rect.origin.y * JKImageClipScreenScale;
    
    rect.size.width = rect.size.width > self.imageView.frame.size.width ? self.imageView.frame.size.width * JKImageClipScreenScale : rect.size.width * JKImageClipScreenScale;
    rect.size.height = rect.size.height > self.imageView.frame.size.height ? self.imageView.frame.size.height * JKImageClipScreenScale : rect.size.height * JKImageClipScreenScale;
    
    /*
    if (rect.size.height != rect.size.width) {
        
        rect.size.width = MIN(rect.size.height, rect.size.width);
        rect.size.height = rect.size.width;
    } */
    
    //NSLog(@"图片尺寸--->%@", NSStringFromCGSize(image.size));
    //NSLog(@"截取范围--->%@", NSStringFromCGRect(rect));
    
    CGImageRef imageRef = CGImageCreateWithImageInRect(image.CGImage, rect);
    
    UIImage *newImage = [UIImage imageWithCGImage:imageRef];
    
    if (_isCircle) {
        
        newImage = [self jk_circleImage:newImage];
    }
    
    CGImageRelease(imageRef);
    
    if (self.autoSavaToAlbum) {
        UIImageWriteToSavedPhotosAlbum(newImage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    }
    return newImage;
    //    }
    //
    //    //NSLog(@"图片尺寸--->%@", NSStringFromCGSize(self.image.size));
    //
    //    CGRect rect = CGRectMake(0, (JKImageClipScreenH - JKImageClipScreenW) * 0.5, JKImageClipScreenW, JKImageClipScreenW);
    //
    //    CGRect convertRect = [self convertRect:rect toView:self.imageView];
    //    //NSLog(@"转换后范围--->%@", NSStringFromCGRect(convertRect));
    //
    //    convertRect = CGRectMake(
    //                             convertRect.origin.x / self.imageView.frame.size.width * self.image.size.width * JKImageClipScreenScale,
    //                             convertRect.origin.y / self.imageView.frame.size.height * self.image.size.height * JKImageClipScreenScale,
    //                             convertRect.size.width / self.imageView.frame.size.width * self.image.size.width * JKImageClipScreenScale,
    //                             convertRect.size.width / self.imageView.frame.size.width * self.image.size.width * JKImageClipScreenScale);
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

- (UIImage *)jk_circleImage:(UIImage *)originalImage{
    
    //NO代表透明
    UIGraphicsBeginImageContextWithOptions(originalImage.size, NO, 0.0);
    
    //获取上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    //添加一个圆
    CGRect rect = CGRectMake(0, 0, originalImage.size.width, originalImage.size.height);
    CGContextAddEllipseInRect(ctx, rect);
    
    //裁剪
    CGContextClip(ctx);
    
    //将图片画上去
    [originalImage drawInRect:rect];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
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
    [self setInset];
    //NSLog(@"图片frame--->%@", NSStringFromCGRect(self.imageView.frame));
}

- (void)setInset{
    // 计算内边距，注意只能使用frame
    CGFloat offsetX = (JKImageClipScreenW - (self.cropSize.width)) * 0.5;
    CGFloat offsetY = self.imageView.frame.size.height >= self.cropSize.height ? (JKImageClipScreenH - (self.cropSize.height)) * 0.5 : (JKImageClipScreenH - self.imageView.frame.size.height) * 0.5;//(JKImageClipScreenH - self.imageView.frame.size.height) * 0.5;
    
    // 当小于0的时候，放大的图片将无法滚动，因为内边距为负数时限制了它可以滚动的范围
    offsetX = (offsetX < 0) ? 0 : offsetX;
    offsetY = (offsetY < 0) ? 0 : offsetY;
    
    self.scrollView.contentInset = UIEdgeInsetsMake(offsetY, offsetX, offsetY, offsetX);//UIEdgeInsets(top: offsetY, left: offsetX, bottom: offsetY, right: offsetX)
}

/** 允许dealloc打印，用于检查循环引用 */
- (void)enableDeallocLog{
    
    _enableDeallocLog = YES;
}

- (void)dealloc{
    
    if (_enableDeallocLog) {
        
        NSLog(@"%d, %s",__LINE__, __func__);
    }
}
@end
