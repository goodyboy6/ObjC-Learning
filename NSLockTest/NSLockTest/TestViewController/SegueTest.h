//
//  SegueTestViewController.h
//  NSLockTest
//
//  Created by yixiaoluo on 15/3/9.
//  Copyright (c) 2015年 cn.gikoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SegueTest : UIViewController

@property (weak, nonatomic) IBOutlet UIView *firstView;
@property (weak, nonatomic) IBOutlet UIView *secondView;
@property (weak, nonatomic) IBOutlet UIView *thirdView;

@property (weak, nonatomic) IBOutlet UIButton *clickIt;

@end

@interface Child1 : UIViewController

@end

@interface Child2 : UIViewController

@end

@interface Child3 : UIViewController

@end

@interface PrivateSegue : UIStoryboardSegue

@end