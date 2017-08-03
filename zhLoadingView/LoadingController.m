//
//  LoadingController.m
//  SnailLoadingView
//
//  Created by zhanghao on 2017/3/22.
//  Copyright © 2017年 zhanghao. All rights reserved.
//

#import "LoadingController.h"
#import "zhLoadingView.h"

@interface LoadingController ()

@end

@implementation LoadingController

- (void)viewWillAppear:(BOOL)animated {
    NSString *selString = [NSString stringWithFormat:@"example%lu", _loadingType];
    SEL sel = NSSelectorFromString(selString);
    if ([self respondsToSelector:sel]) {
        self.title = selString;
        [self performSelector:sel withObject:nil afterDelay:0];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.view zh_endLoading];
}

#pragma mark Example -

- (void)example1 {
    [self.view zh_beginLoading];
}

- (void)example2 {
    
    zhLoadingView *loadingView = [zhLoadingView new];
    loadingView.anulusWidth = 5;
    loadingView.anulusAngle = 75;
    loadingView.anulusColor1 = [UIColor redColor];
    loadingView.anulusColor2 = [UIColor darkGrayColor];
    self.view.zh_loadingView = loadingView;
    
    [self.view zh_beginLoading];
}

- (void)example3 {
    
    // 可以在"zhLoadingView.m" 文件中 “lazily create the loadingView” 设置成默认的！
    zhLoadingView *loadingView = [[zhLoadingView alloc] initWithFrame:CGRectMake(0, 0, 90, 90)];
    loadingView.onlyLogo = YES;
    loadingView.loadingImage = [UIImage imageNamed:@"loading_pink"];
    self.view.zh_loadingView = loadingView;
    
    [self.view zh_beginLoading];
}

@end
