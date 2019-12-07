//
//  JKClipImageSquareTypeView.m
//  JKClipImageTool
//
//  Created by albert on 2017/5/17.
//  Copyright © 2017年 安永博. All rights reserved.
//

#import "JKClipImageSquareTypeView.h"
#import "JKClipImageConst.h"

@interface JKClipImageSquareTypeView () <UICollectionViewDelegate>
{
    CGFloat maxH;
}

/** shapeLayer */
@property (nonatomic, strong) CAShapeLayer *shapeLayer;

/** 图片 */
@property (nonatomic, strong) UIImage *image;

/** 是否裁剪为圆形 */
@property (nonatomic, assign) BOOL isCircle;

/** 是否传入了父试图 */
@property (nonatomic, assign) BOOL isHaveSuperView;

/** 宽高比 */
@property (nonatomic, assign) CGSize cropSize;
@end

@implementation JKClipImageSquareTypeView

/**
 * 裁剪正方形图片
 * targetImage : 要裁剪的图片
 * isCircle : 是否裁剪为圆形
 * cropSize : 要裁剪的宽高比
 * isAutoSavaToAlbum : 是否自动将截图保存到相册
 * cancelHandler : 点击取消的回调
 * completeHandler : 截图完成的回调
 */
+ (instancetype)showWithSuperView:(UIView *)superView
                      targetImage:(UIImage *)targetImage
                         clipSize:(CGSize)clipSize
                         isCircle:(BOOL)isCircle
                isAutoSavaToAlbum:(BOOL)isAutoSavaToAlbum
                    cancelHandler:(void(^)(void))cancelHandler
                  completeHandler:(void(^)(UIImage *image))completeHandler{
    
    if (!targetImage) { return nil; }
    
    JKClipImageSquareTypeView *icv = [[JKClipImageSquareTypeView alloc] init];
    icv.image = targetImage;
    icv.cropSize = clipSize;
    icv.isCircle = isCircle;
    icv.isAutoSavaToAlbum = isAutoSavaToAlbum;
    icv.cancelHandler = cancelHandler;
    icv.completeHandler = completeHandler;
    
    if (superView) {
        
        icv.isHaveSuperView = YES;
        
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
    
}

/** 构造函数初始化时调用 注意调用super */
- (void)initialization{
    [super initialization];
    
}

/** 创建UI */
- (void)createUI{
    [super createUI];
    
    self.backgroundColor = [UIColor blackColor];
    self.frame = JKClipImageScreenBounds;
    
    [self setExclusiveTouch:YES];
    
    CGFloat screenH = MAX(JKClipImageScreenWidth, JKClipImageScreenHeight);
    
    maxH = (JKClipImageIsDeviceX() ? screenH - 100 - 100 : screenH - 66 - 66);
    
    
    
    self.scrollView.minimumZoomScale = 1;
    self.scrollView.maximumZoomScale = 3;
    
    self.imageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap:)];
    doubleTap.numberOfTapsRequired = 2;
    [self addGestureRecognizer:doubleTap];
    
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
    
    if (newSuperview == nil) { return; }
    
    [self shapeLayer];
    
    [self calculateImageViewSize];
    
    if (self.isHaveSuperView) {
        
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

- (void)layoutSubviews{
    [super layoutSubviews];
    
    self.scrollView.frame = self.bounds;
}


#pragma mark
#pragma mark - 点击事件

- (void)doubleTap:(UITapGestureRecognizer *)doubleTap{
    
    CGPoint touchPoint = [doubleTap locationInView:self.imageView];
    
    CGPoint point = [self.imageView convertPoint:touchPoint fromView:self.imageView];
    
    if (![self.imageView pointInside:point withEvent:nil]) { return; }
    
    // 双击缩小
    if (self.scrollView.zoomScale != 1) {
        [self.scrollView setZoomScale:1 animated:YES];
        
        return;
    }
    
    // 双击放大
    [self.scrollView zoomToRect:CGRectMake(touchPoint.x - 5, touchPoint.y - 5, 10, 10) animated:YES];
}

- (void)cancelButtonClick{
    
    if (self.scrollView.isDragging ||
        self.scrollView.isDecelerating ||
        self.scrollView.isZooming) {
        
        return;
    }
    
    self.userInteractionEnabled = NO;
    
    if (self.isHaveSuperView) {
        
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
        self.scrollView.isZooming) {
        
        return;
    }
    
    self.userInteractionEnabled = NO;
    
    if (self.isHaveSuperView) {
        
        !self.completeHandler ? : self.completeHandler([self clipImage]);
        
        [self removeFromSuperview];
        
        return;
    }
    
    [UIView animateWithDuration:0.25 animations:^{
        
        self.frame = CGRectMake(JKClipImageScreenWidth, 0, JKClipImageScreenWidth, JKClipImageScreenHeight);
        
    } completion:^(BOOL finished) {
        
        !self.completeHandler ? : self.completeHandler([self clipImage]);
        
        [self removeFromSuperview];
    }];
}


#pragma mark
#pragma mark - 发送请求


#pragma mark
#pragma mark - 处理数据


#pragma mark
#pragma mark - 赋值

- (void)setCropSize:(CGSize)cropSize{
    
    CGFloat W = cropSize.width;
    CGFloat H = cropSize.height;
    CGFloat scale = W / H;
    
    CGFloat screenW = MIN(JKClipImageScreenWidth, JKClipImageScreenHeight);
    
    if (MIN(W, H) <= 0) {
        
        W = screenW;
        H = screenW;
    }
    
    if (W > screenW) {
        
        W = screenW;
        H = W / scale;
    }
    
    if (H > maxH) {
        
        H = maxH;
        W = H * scale;
    }
    
    _cropSize = CGSizeMake(W, H);
}

- (void)setImage:(UIImage *)image{
    
    if (!image) { return; }
    
    _image = image;
    
    self.imageView.image = image;
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
    
    [self calculateInset];
    
    //NSLog(@"图片frame--->%@", NSStringFromCGRect(self.imageView.frame));
}


#pragma mark
#pragma mark - Property

- (CAShapeLayer *)shapeLayer{
    if (!_shapeLayer) {
        _shapeLayer = [CAShapeLayer layer];
        _shapeLayer.fillColor = [[UIColor blackColor] colorWithAlphaComponent:0.7].CGColor;
        _shapeLayer.fillRule = kCAFillRuleEvenOdd;
        //        _shapeLayer.lineWidth = 1;
        _shapeLayer.strokeColor = [UIColor whiteColor].CGColor;
        //        _shapeLayer.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7].CGColor;
        _shapeLayer.frame = JKClipImageScreenBounds;
        UIBezierPath *fullPath = [UIBezierPath bezierPathWithRect:CGRectMake(-1, -1, JKClipImageScreenWidth + 2, JKClipImageScreenHeight + 2)];
        
        UIBezierPath *path = nil;
        
        if (_isCircle) {
            
            path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(1, (JKClipImageScreenHeight - JKClipImageScreenWidth) * 0.5, JKClipImageScreenWidth - 2, JKClipImageScreenWidth) cornerRadius:(JKClipImageScreenWidth - 2) * 0.5];
            
        } else {
            
            CGFloat screenW = MIN(JKClipImageScreenWidth, JKClipImageScreenHeight);
            
            path = [UIBezierPath bezierPathWithRect:CGRectMake((screenW - self.cropSize.width) * 0.5 + 1, (JKClipImageIsDeviceX() ? 100 : 66) + (maxH - self.cropSize.height) * 0.5, self.cropSize.width - 2, self.cropSize.height)];
        }
        
        [fullPath appendPath:path];
        [fullPath setUsesEvenOddFillRule:YES];
        
        _shapeLayer.path = fullPath.CGPath;
        //        _shapeLayer.opacity = 0.4;
        [self.contentView.layer insertSublayer:_shapeLayer above:self.scrollView.layer];
    }
    return _shapeLayer;
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
    
    [self calculateInset];
    
    self.scrollView.contentOffset = CGPointMake(0, -self.scrollView.contentInset.top + (self.imageView.frame.size.height - self.cropSize.height) * 0.5);
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    
    if (error) {
        //NSLog(@"自动保存截图失败！");
    }
    //NSLog(@"自动保存截图成功！");
}

#pragma mark
#pragma mark - Private Function

- (void)calculateInset{
    
    // 计算内边距，注意只能使用frame
    CGFloat offsetX = (JKClipImageScreenWidth - (self.cropSize.width)) * 0.5;
    CGFloat offsetY = self.imageView.frame.size.height >= self.cropSize.height ? (JKClipImageScreenHeight - (self.cropSize.height)) * 0.5 : (JKClipImageScreenHeight - self.imageView.frame.size.height) * 0.5;//(JKClipImageScreenHeight - self.imageView.frame.size.height) * 0.5;
    
    // 当小于0的时候，放大的图片将无法滚动，因为内边距为负数时限制了它可以滚动的范围
    offsetX = (offsetX < 0) ? 0 : offsetX;
    offsetY = (offsetY < 0) ? 0 : offsetY;
    
    self.scrollView.contentInset = UIEdgeInsetsMake(offsetY, offsetX, offsetY, offsetX);//UIEdgeInsets(top: offsetY, left: offsetX, bottom: offsetY, right: offsetX)
}

- (UIImage *)clipImage{
    
    self.shapeLayer.hidden = YES;
    
    // NO代表透明
    UIGraphicsBeginImageContextWithOptions(self.imageView.frame.size, NO, 0.0);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    [self.imageView.layer renderInContext:ctx];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    CGRect rect1 = CGRectMake((JKClipImageScreenWidth - self.cropSize.width) * 0.5, (JKClipImageScreenHeight - self.cropSize.height) * 0.5, self.cropSize.width, self.cropSize.height);
    
    CGRect rect = [self convertRect:rect1 toView:self.imageView];
    
    rect.origin.x = rect.origin.x < 0 ? 0 : rect.origin.x * JKClipImageScreenScale;
    rect.origin.y = rect.origin.y < 0 ? 0 : rect.origin.y * JKClipImageScreenScale;
    
    rect.size.width = rect.size.width > self.imageView.frame.size.width ? self.imageView.frame.size.width * JKClipImageScreenScale : rect.size.width * JKClipImageScreenScale;
    rect.size.height = rect.size.height > self.imageView.frame.size.height ? self.imageView.frame.size.height * JKClipImageScreenScale : rect.size.height * JKClipImageScreenScale;
    
    //NSLog(@"图片尺寸--->%@", NSStringFromCGSize(image.size));
    //NSLog(@"截取范围--->%@", NSStringFromCGRect(rect));
    
    CGImageRef imageRef = CGImageCreateWithImageInRect(image.CGImage, rect);
    
    UIImage *newImage = [UIImage imageWithCGImage:imageRef];
    
    if (_isCircle) {
        
        newImage = [self clipCircleImage:newImage];
    }
    
    CGImageRelease(imageRef);
    
    if (self.isAutoSavaToAlbum) {
        UIImageWriteToSavedPhotosAlbum(newImage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    }
    return newImage;
}

- (UIImage *)clipCircleImage:(UIImage *)originalImage{
    
    // NO代表透明
    UIGraphicsBeginImageContextWithOptions(originalImage.size, NO, 0.0);
    
    // 获取上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    // 添加一个圆
    CGRect rect = CGRectMake(0, 0, originalImage.size.width, originalImage.size.height);
    CGContextAddEllipseInRect(ctx, rect);
    
    // 裁剪
    CGContextClip(ctx);
    
    // 将图片画上去
    [originalImage drawInRect:rect];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}
@end
