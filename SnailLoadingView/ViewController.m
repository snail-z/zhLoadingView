//
//  ViewController.m
//  SnailLoadingView
//
//  Created by zhanghao on 2017/3/22.
//  Copyright © 2017年 zhanghao. All rights reserved.
//

#import "ViewController.h"
#import "LoadingController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)loading1:(id)sender {
    [self push:1];
}

- (IBAction)loading2:(id)sender {
    [self push:2];
}

- (IBAction)loading3:(id)sender {
    [self push:3];
}

- (void)push:(NSInteger)pushType {
    LoadingController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"LoadingVC"];
    vc.loadingType = pushType;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
