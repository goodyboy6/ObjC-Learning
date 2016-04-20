//
//  ProxyViewController.h
//  NSLockTest
//
//  Created by yixiaoluo on 15/3/3.
//  Copyright (c) 2015年 cn.gikoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProxyTest : UIViewController

@end

@interface TestProxy : NSProxy

- (instancetype)init;
- (void)method1;

@end
