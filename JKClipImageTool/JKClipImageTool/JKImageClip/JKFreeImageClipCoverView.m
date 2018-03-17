//
//  JKFreeImageClipCoverView.m
//  JKClipImageTool
//
//  Created by albert on 2017/5/18.
//  Copyright © 2017年 安永博. All rights reserved.
//

#import "JKFreeImageClipCoverView.h"

@implementation JKFreeImageClipCoverView

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
    self.backgroundColor = [UIColor clearColor];
    self.userInteractionEnabled = NO;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    [[UIColor colorWithWhite:0 alpha:0.7] setFill];
    //半透明区域
    UIRectFill(rect);
    
    //透明的区域
//    CGRect holeRection = CGRectMake(100, 200, 200, 200);
    /** union: 并集
     CGRect CGRectUnion(CGRect r1, CGRect r2)
     返回并集部分rect
     */
    
    /** Intersection: 交集
     CGRect CGRectIntersection(CGRect r1, CGRect r2)
     返回交集部分rect
     */
    CGRect holeiInterSection = CGRectIntersection(self.transparentRect, rect);
    [[UIColor clearColor] setFill];
    
    //CGContextClearRect(ctx, <#CGRect rect#>)
    //绘制
    //CGContextDrawPath(ctx, kCGPathFillStroke);
    UIRectFill(holeiInterSection);
}

- (void)setTransparentRect:(CGRect)transparentRect{
    _transparentRect = transparentRect;
    
    [self setNeedsDisplayInRect:self.bounds];
}
@end
