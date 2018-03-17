//
//  JKFreeImageClipRectView.m
//  JKClipImageTool
//
//  Created by albert on 2017/5/18.
//  Copyright © 2017年 安永博. All rights reserved.
//

#import "JKFreeImageClipRectView.h"

@interface JKFreeImageClipRectView ()

@end

@implementation JKFreeImageClipRectView

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
    
    UIImageView *top_left_imageView = [[UIImageView alloc] init];
    top_left_imageView.image = [UIImage imageWithContentsOfFile:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"JKClipImageToolResouce.bundle/images/corner_top_left@3x.png"]];//[UIImage imageNamed:@"corner_top_left"];
    [self addSubview:top_left_imageView];
    _top_left_imageView = top_left_imageView;
    
    top_left_imageView.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *top_left_imageViewCons1 = [NSLayoutConstraint constraintWithItem:top_left_imageView attribute:(NSLayoutAttributeTop) relatedBy:(NSLayoutRelationEqual) toItem:self attribute:(NSLayoutAttributeTop) multiplier:1 constant:-2];
    NSLayoutConstraint *top_left_imageViewCons2 = [NSLayoutConstraint constraintWithItem:top_left_imageView attribute:(NSLayoutAttributeLeft) relatedBy:(NSLayoutRelationEqual) toItem:self attribute:(NSLayoutAttributeLeft) multiplier:1 constant:-2];
    NSLayoutConstraint *top_left_imageViewCons3 = [NSLayoutConstraint constraintWithItem:top_left_imageView attribute:(NSLayoutAttributeWidth) relatedBy:(NSLayoutRelationEqual) toItem:nil attribute:(NSLayoutAttributeNotAnAttribute) multiplier:1 constant:30];
    NSLayoutConstraint *top_left_imageViewCons4 = [NSLayoutConstraint constraintWithItem:top_left_imageView attribute:(NSLayoutAttributeHeight) relatedBy:(NSLayoutRelationEqual) toItem:nil attribute:(NSLayoutAttributeNotAnAttribute) multiplier:1 constant:30];
    
    [self addConstraints:@[top_left_imageViewCons1, top_left_imageViewCons2, top_left_imageViewCons3, top_left_imageViewCons4]];
    
    
    
    
    UIImageView *top_right_imageView = [[UIImageView alloc] init];
    top_right_imageView.image = [UIImage imageWithContentsOfFile:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"JKClipImageToolResouce.bundle/images/corner_top_right@3x.png"]];//[UIImage imageNamed:@"corner_top_right"];
    [self addSubview:top_right_imageView];
    _top_right_imageView = top_right_imageView;
    
    top_right_imageView.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *top_right_imageViewCons1 = [NSLayoutConstraint constraintWithItem:top_right_imageView attribute:(NSLayoutAttributeTop) relatedBy:(NSLayoutRelationEqual) toItem:self attribute:(NSLayoutAttributeTop) multiplier:1 constant:-2];
    NSLayoutConstraint *top_right_imageViewCons2 = [NSLayoutConstraint constraintWithItem:top_right_imageView attribute:(NSLayoutAttributeRight) relatedBy:(NSLayoutRelationEqual) toItem:self attribute:(NSLayoutAttributeRight) multiplier:1 constant:2];
    NSLayoutConstraint *top_right_imageViewCons3 = [NSLayoutConstraint constraintWithItem:top_right_imageView attribute:(NSLayoutAttributeWidth) relatedBy:(NSLayoutRelationEqual) toItem:nil attribute:(NSLayoutAttributeNotAnAttribute) multiplier:1 constant:30];
    NSLayoutConstraint *top_right_imageViewCons4 = [NSLayoutConstraint constraintWithItem:top_right_imageView attribute:(NSLayoutAttributeHeight) relatedBy:(NSLayoutRelationEqual) toItem:nil attribute:(NSLayoutAttributeNotAnAttribute) multiplier:1 constant:30];
    
    [self addConstraints:@[top_right_imageViewCons1, top_right_imageViewCons2, top_right_imageViewCons3, top_right_imageViewCons4]];
    
    
    
    
    UIImageView *middle_imageView = [[UIImageView alloc] init];
//    middle_imageView.backgroundColor = [UIColor redColor];
    [self addSubview:middle_imageView];
    _middle_imageView = middle_imageView;
    
    middle_imageView.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *middle_imageViewCons1 = [NSLayoutConstraint constraintWithItem:middle_imageView attribute:(NSLayoutAttributeCenterX) relatedBy:(NSLayoutRelationEqual) toItem:self attribute:(NSLayoutAttributeCenterX) multiplier:1 constant:0];
    NSLayoutConstraint *middle_imageViewCons2 = [NSLayoutConstraint constraintWithItem:middle_imageView attribute:(NSLayoutAttributeCenterY) relatedBy:(NSLayoutRelationEqual) toItem:self attribute:(NSLayoutAttributeCenterY) multiplier:1 constant:0];
    NSLayoutConstraint *middle_imageViewCons3 = [NSLayoutConstraint constraintWithItem:middle_imageView attribute:(NSLayoutAttributeWidth) relatedBy:(NSLayoutRelationEqual) toItem:nil attribute:(NSLayoutAttributeNotAnAttribute) multiplier:1 constant:30];
    NSLayoutConstraint *middle_imageViewCons4 = [NSLayoutConstraint constraintWithItem:middle_imageView attribute:(NSLayoutAttributeHeight) relatedBy:(NSLayoutRelationEqual) toItem:nil attribute:(NSLayoutAttributeNotAnAttribute) multiplier:1 constant:30];
    
    [self addConstraints:@[middle_imageViewCons1, middle_imageViewCons2, middle_imageViewCons3, middle_imageViewCons4]];
    
    
    
    
    UIImageView *bottom_left_imageView = [[UIImageView alloc] init];
    bottom_left_imageView.image = [UIImage imageWithContentsOfFile:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"JKClipImageToolResouce.bundle/images/corner_bottom_left@3x.png"]];//[UIImage imageNamed:@"corner_bottom_left"];
    [self addSubview:bottom_left_imageView];
    _bottom_left_imageView = bottom_left_imageView;
    
    bottom_left_imageView.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *bottom_left_imageViewCons1 = [NSLayoutConstraint constraintWithItem:bottom_left_imageView attribute:(NSLayoutAttributeBottom) relatedBy:(NSLayoutRelationEqual) toItem:self attribute:(NSLayoutAttributeBottom) multiplier:1 constant:2];
    NSLayoutConstraint *bottom_left_imageViewCons2 = [NSLayoutConstraint constraintWithItem:bottom_left_imageView attribute:(NSLayoutAttributeLeft) relatedBy:(NSLayoutRelationEqual) toItem:self attribute:(NSLayoutAttributeLeft) multiplier:1 constant:-2];
    NSLayoutConstraint *bottom_left_imageViewCons3 = [NSLayoutConstraint constraintWithItem:bottom_left_imageView attribute:(NSLayoutAttributeWidth) relatedBy:(NSLayoutRelationEqual) toItem:nil attribute:(NSLayoutAttributeNotAnAttribute) multiplier:1 constant:30];
    NSLayoutConstraint *bottom_left_imageViewCons4 = [NSLayoutConstraint constraintWithItem:bottom_left_imageView attribute:(NSLayoutAttributeHeight) relatedBy:(NSLayoutRelationEqual) toItem:nil attribute:(NSLayoutAttributeNotAnAttribute) multiplier:1 constant:30];
    
    [self addConstraints:@[bottom_left_imageViewCons1, bottom_left_imageViewCons2, bottom_left_imageViewCons3, bottom_left_imageViewCons4]];
    
    
    
    
    UIImageView *bottom_right_imageView = [[UIImageView alloc] init];
    bottom_right_imageView.image = [UIImage imageWithContentsOfFile:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"JKClipImageToolResouce.bundle/images/corner_bottom_right@3x.png"]];
    [self addSubview:bottom_right_imageView];
    _bottom_right_imageView = bottom_right_imageView;
    
    bottom_right_imageView.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *bottom_right_imageViewCons1 = [NSLayoutConstraint constraintWithItem:bottom_right_imageView attribute:(NSLayoutAttributeBottom) relatedBy:(NSLayoutRelationEqual) toItem:self attribute:(NSLayoutAttributeBottom) multiplier:1 constant:2];
    NSLayoutConstraint *bottom_right_imageViewCons2 = [NSLayoutConstraint constraintWithItem:bottom_right_imageView attribute:(NSLayoutAttributeRight) relatedBy:(NSLayoutRelationEqual) toItem:self attribute:(NSLayoutAttributeRight) multiplier:1 constant:2];
    NSLayoutConstraint *bottom_right_imageViewCons3 = [NSLayoutConstraint constraintWithItem:bottom_right_imageView attribute:(NSLayoutAttributeWidth) relatedBy:(NSLayoutRelationEqual) toItem:nil attribute:(NSLayoutAttributeNotAnAttribute) multiplier:1 constant:30];
    NSLayoutConstraint *bottom_right_imageViewCons4 = [NSLayoutConstraint constraintWithItem:bottom_right_imageView attribute:(NSLayoutAttributeHeight) relatedBy:(NSLayoutRelationEqual) toItem:nil attribute:(NSLayoutAttributeNotAnAttribute) multiplier:1 constant:30];
    
    [self addConstraints:@[bottom_right_imageViewCons1, bottom_right_imageViewCons2, bottom_right_imageViewCons3, bottom_right_imageViewCons4]];
    
//    self.top_left_imageView.backgroundColor     = [UIColor redColor];
//    self.top_right_imageView.backgroundColor    = [UIColor redColor];
//    self.bottom_left_imageView.backgroundColor  = [UIColor redColor];
//    self.bottom_right_imageView.backgroundColor = [UIColor redColor];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGContextSaveGState(ctx);
    
    [[UIColor whiteColor] set];
    CGContextSetLineWidth(ctx, 2);
    
    CGContextMoveToPoint(ctx, 0, 0);
    CGContextAddLineToPoint(ctx, rect.size.width, 0);
    CGContextAddLineToPoint(ctx, rect.size.width, rect.size.height);
    CGContextAddLineToPoint(ctx, 0, rect.size.height);
    CGContextAddLineToPoint(ctx, 0, 0);
    
    CGContextStrokePath(ctx);
    
    CGContextRestoreGState(ctx);
    
    [[UIColor whiteColor] set];
    CGContextSetLineWidth(ctx, 0.5);
    
    // 横线
    CGContextMoveToPoint(ctx, 0, rect.size.height / 3);
    CGContextAddLineToPoint(ctx, rect.size.width, rect.size.height / 3);
    
    CGContextMoveToPoint(ctx, 0, rect.size.height / 3 * 2);
    CGContextAddLineToPoint(ctx, rect.size.width, rect.size.height / 3 * 2);
    
    
    // 竖线
    CGContextMoveToPoint(ctx, rect.size.width / 3, 0);
    CGContextAddLineToPoint(ctx, rect.size.width / 3, rect.size.height);
    
    CGContextMoveToPoint(ctx, rect.size.width / 3 * 2, 0);
    CGContextAddLineToPoint(ctx, rect.size.width / 3 * 2, rect.size.height);
    
    CGContextStrokePath(ctx);
}

- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    
    [self setNeedsDisplayInRect:self.bounds];
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    
    if ([self.top_left_imageView pointInside:[self convertPoint:point toView:self.top_left_imageView] withEvent:event]         ||
        [self.top_right_imageView pointInside:[self convertPoint:point toView:self.top_right_imageView] withEvent:event]    ||
        [self.bottom_left_imageView pointInside:[self convertPoint:point toView:self.bottom_left_imageView] withEvent:event]  ||
        [self.bottom_right_imageView pointInside:[self convertPoint:point toView:self.bottom_right_imageView] withEvent:event] ||
        [self.middle_imageView pointInside:[self convertPoint:point toView:self.middle_imageView] withEvent:event]) {
        
        return self;
    }
    
    return nil;
}
@end
