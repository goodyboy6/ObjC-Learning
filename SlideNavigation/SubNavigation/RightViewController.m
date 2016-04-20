//
//  RightViewController.m
//  SubNavigation
//
//  Created by yixiaoluo on 16/4/1.
//  Copyright © 2016年 alibaba.com. All rights reserved.
//

#import "RightViewController.h"

@implementation RightViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"%@_%@", NSStringFromClass(self.class), NSStringFromSelector(_cmd));
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"%@_%@", NSStringFromClass(self.class), NSStringFromSelector(_cmd));
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSLog(@"%@_%@", NSStringFromClass(self.class), NSStringFromSelector(_cmd));
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    NSLog(@"%@_%@", NSStringFromClass(self.class), NSStringFromSelector(_cmd));
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    NSLog(@"%@_%@", NSStringFromClass(self.class), NSStringFromSelector(_cmd));
}

@end
