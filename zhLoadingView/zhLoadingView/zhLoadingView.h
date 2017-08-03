//
//  zhLoadingView.h
//  <https://github.com/snail-z/zhLoadingView.git>
//
//  Created by zhanghao on 16/2/18.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import <UIKit/UIKit.h>
@class zhLoadingView;

@interface UIView (zhLoading)

// 自定义LoadingView
@property (nonatomic, strong) zhLoadingView *zh_loadingView;

- (void)zh_beginLoading;

- (void)zh_endLoading;

@end

@interface zhLoadingView : UIView

@property (nonatomic, assign, readonly) BOOL isLoading;

@property (nonatomic, assign) BOOL onlyLogo;                            // 是否只显示logoImage，默认NO

@property (nonatomic, strong) UIImage *loadingImage;                    // 设置loading图片

@property (nonatomic, strong) UIColor *anulusColor1;
@property (nonatomic, strong) UIColor *anulusColor2;                    // 设置两条圆环颜色

@property (nonatomic, assign) CGFloat anulusWidth;                      // 圆环的宽度

@property (nonatomic, assign) CGFloat anulusAngle;                      // 圆环的间距(单位:角度 值:0~90)

@property (nonatomic, strong) CAMediaTimingFunction *timingFunction;    // 动画速度控制函数

- (void)updateContents;
- (void)startAnimation;
- (void)stopAnimation;

@end
