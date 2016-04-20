//
//  ChildViewController.m
//  NSLockTest
//
//  Created by yixiaoluo on 15/2/27.
//  Copyright (c) 2015年 cn.gikoo. All rights reserved.
//

#import "DetailViewController.h"
#import "DispatchTimerTest.h"
#import "LockTest.h"
#import "IsEqualTest.h"
#import "DispatchMultithread.h"
#import "SwizzlingTest.h"
#import "NSOperationTest.h"
#import "ProxyTest.h"
#import "ViewTest.h"
#import "SegueTest.h"
#import "BezierPath.h"
#import "KVC_KVO_.h"
#import "RunLoop.h"
#import "Copying.h"
#import "LoadView.h"

#import "UIStoryboard+Shared.h"

@interface DetailViewController ()

@property (nonatomic) UIViewController *currentController;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)setType:(TestType)type
{
    if (type == _type) {
        return;
    }
    
    _type = type;
    
    UIViewController *controller = nil;
    switch (type) {
        case kTestNSLock:
            controller = [[LockTest alloc] init];
            break;
        case kTestDispatchTimer:
            controller = [[DispatchTimerTest alloc] initWithStyle:UITableViewStylePlain];
            break;
        case kTestIsEqualAndHash:
            controller = [[IsEqualTest alloc] init];
            break;
        case kTestMultithread:
            controller = [[DispatchMultithread alloc] init];
            break;
        case kTestSwizzling:
            controller = [[SwizzlingTest alloc] init];
            break;
        case kTestNSOperation:
            controller = [[NSOperationTest alloc] init];
            break;
        case kTestNSProxy:
            controller = [[ProxyTest alloc] init];
            break;
        case kTestUIView:
            controller = [[UIStoryboard shared] instantiateViewControllerWithIdentifier:@"ViewTest"];
            break;
        case kTestSegue:
            controller = [[UIStoryboard shared] instantiateViewControllerWithIdentifier:@"SegueTest"];
            break;
        case kTestBezierPath:
            controller = [[BezierPath alloc] init];
            break;
        case kTestModel:
        {
            KVC_KVO_ *vc = [[KVC_KVO_ alloc] init];
            controller = [[UINavigationController alloc] initWithRootViewController:vc];
        }
            break;
        case kTestRunLoop:
        {
            controller = [[RunLoop alloc] init];
        }
            break;
        case kTestCopying:
            controller = [[Copying alloc] init];
            break;
        case kTestViewProperty:
            controller = [[LoadView alloc] init];
        default:
            break;
    }
    
    if (controller != nil) {
        [self.currentController.view removeFromSuperview];
        [self.currentController removeFromParentViewController];
        
        [self.childViewControllers makeObjectsPerformSelector:@selector(removeFromParentViewController)];
        [self addChildViewController:controller];
        
        [self.view addSubview:controller.view];
        [controller didMoveToParentViewController:self];
        self.currentController = controller;
    }
}

@end
