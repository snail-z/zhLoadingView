//
//  zhLoadingView.m
//  <https://github.com/snail-z/zhLoadingView.git>
//
//  Created by zhanghao on 16/2/18.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import "zhLoadingView.h"
#import <objc/runtime.h>

#pragma mark UIView Category -

static void *UIViewSnailLoadingViewKey = &UIViewSnailLoadingViewKey;

@implementation UIView (zhLoading)

- (zhLoadingView *)zh_loadingView {
  
    id loadingView = objc_getAssociatedObject(self, UIViewSnailLoadingViewKey);
   
    // lazily create the loadingView
    if (nil == loadingView) {
        loadingView = [[zhLoadingView alloc] init];
        self.zh_loadingView = loadingView;
        
        // You can set loading image and more.
        self.zh_loadingView.loadingImage = [UIImage imageNamed:@"loading_apple"];
    }
    
    return loadingView;
}

- (void)setZh_loadingView:(zhLoadingView *)zh_loadingView {
    objc_setAssociatedObject(self, UIViewSnailLoadingViewKey, zh_loadingView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)zh_beginLoading {
    self.zh_loadingView.center = self.center;
    [self.zh_loadingView updateContents];
    [self addSubview:self.zh_loadingView];
    [self.zh_loadingView startAnimation];
}

- (void)zh_endLoading {
    if (self.zh_loadingView) {
        [self.zh_loadingView stopAnimation];
    }
}

@end

#pragma mark SnailLoadingView Implementation -

@interface zhLoadingView ()

@property (nonatomic, strong) CALayer *anulusLayer;
@property (nonatomic, strong) UIImageView *logoView;

@end

@implementation zhLoadingView

- (instancetype)init {
    return [self initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (frame.size.width == 0 && frame.size.height == 0) {
        frame.size.width = frame.size.height = 60;
    }
    if (![super initWithFrame:frame]) return nil;
  
    _loadingImage   = nil;
    _onlyLogo       = NO;
    _anulusWidth    = 2;
    _anulusAngle    = 50;
    _anulusColor1   = [UIColor greenColor];
    _anulusColor2   = [UIColor orangeColor];
    _timingFunction = [CAMediaTimingFunction functionWithControlPoints:1.00 :1.00 :0.00 :0.00];
    
    return self;
}

- (void)updateContents {
    if (_onlyLogo) {
        _logoView = [[UIImageView alloc] init];
        _logoView.image = _loadingImage;
        _logoView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.width);
        _logoView.center = CGPointMake(self.frame.size.width * 0.5, self.frame.size.height * 0.5);
        _logoView.backgroundColor = [UIColor clearColor];
        [self addSubview:_logoView];
    } else {
        _anulusLayer = [CALayer layer];
        _anulusLayer.backgroundColor = [UIColor clearColor].CGColor;
        _anulusLayer.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);

        CAShapeLayer *bottomLayer = [self drawAnulusColor:_anulusColor1
                                               startAngle:_anulusAngle
                                                 endAngle:180 - _anulusAngle];
        [_anulusLayer addSublayer:bottomLayer];
        
        CAShapeLayer *topLayer = [self drawAnulusColor:_anulusColor2
                                            startAngle:180 + _anulusAngle
                                              endAngle:360 - _anulusAngle];
        [_anulusLayer addSublayer:topLayer];
        [self.layer addSublayer:_anulusLayer];
        
        _logoView = [[UIImageView alloc] initWithImage:_loadingImage];
        CGFloat lineWidth = topLayer.lineWidth;
        if (bottomLayer.lineWidth > topLayer.lineWidth) lineWidth = bottomLayer.lineWidth;
        // 正方形: 边长 * sqrt(2) = 对角线长 = 该圆直径 -> 边长 = 该圆直径 / sqrt(2).
        CGFloat width = floor(_anulusLayer.frame.size.height / sqrt(2)) - lineWidth;
        _logoView.frame  = CGRectMake(0, 0, width, width);
        _logoView.center = CGPointMake(_anulusLayer.frame.origin.x + _anulusLayer.frame.size.width * 0.5,
                                       _anulusLayer.frame.origin.y + _anulusLayer.frame.size.height * 0.5);
        _logoView.backgroundColor = [UIColor clearColor];
        [self addSubview:_logoView];
    }
}

- (CAShapeLayer *)drawAnulusColor:(UIColor *)color
                       startAngle:(CGFloat)startAngle
                         endAngle:(CGFloat)endAngle {
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.strokeColor = color.CGColor;
    shapeLayer.lineWidth = _anulusWidth;
    shapeLayer.lineCap = kCALineCapRound;
    
    CGPoint center = CGPointMake(CGRectGetMidX(_anulusLayer.bounds), CGRectGetMidY(_anulusLayer.bounds));
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithArcCenter:center radius:_anulusLayer.frame.size.height / 2 startAngle:startAngle / 180.0 * M_PI endAngle:endAngle / 180.0 * M_PI clockwise:YES];
    shapeLayer.path = bezierPath.CGPath;
    
    return shapeLayer;
}

#pragma mark - start animation

- (void)startAnimation {
    
    if (_isLoading) return;
    _isLoading = YES;
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    animation.fromValue = @(0);
    animation.toValue = @(2 * M_PI);
    animation.duration = 0.65f;
    animation.repeatCount = INFINITY;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.timingFunction = _timingFunction;
    if (_onlyLogo) {
        [_logoView.layer addAnimation:animation forKey:@"zh_logo_rotation_z"];
    } else {
        [_anulusLayer addAnimation:animation forKey:@"zh_anulus_rotation_z"];
        CAKeyframeAnimation* keyAnimation = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
        keyAnimation.duration = 2.0;
        keyAnimation.values = @[@(0.1), @(1.0), @(0.1)];
        keyAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        keyAnimation.repeatCount = INFINITY;
        keyAnimation.fillMode = kCAFillModeBackwards;
        keyAnimation.removedOnCompletion = NO;
        [_logoView.layer addAnimation:keyAnimation forKey:@"zh_logo_opacity"];
    }
}

#pragma mark - end animation

- (void)stopAnimation {
    
    _isLoading = NO;
    
    [_anulusLayer removeAllAnimations];
    [_anulusLayer removeFromSuperlayer];
    [_logoView.layer removeAllAnimations];
    [_logoView removeFromSuperview];
    [self removeFromSuperview];
}

@end
