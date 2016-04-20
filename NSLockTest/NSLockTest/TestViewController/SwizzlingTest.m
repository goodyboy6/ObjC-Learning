//
//  SwizzlingTestViewController.m
//  NSLockTest
//
//  Created by yixiaoluo on 15/2/28.
//  Copyright (c) 2015年 cn.gikoo. All rights reserved.
//

#import "SwizzlingTest.h"

@interface SwizzlingTest ()

@property (weak, nonatomic) NSString *weakString;//check runlopp

@end

@implementation SwizzlingTest

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSLog(@"%@ - %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    NSLog(@"details see class: UIViewController+SwizzlingTest.h");
    NSString *hello = [[NSString alloc] initWithCString:"it will be released at the end of current runloop" encoding:NSUTF8StringEncoding];
    
    self.weakString = hello;
    NSLog(@"%@ - %@", self.weakString, NSStringFromSelector(_cmd));
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSLog(@"%@ - %@", self.weakString, NSStringFromSelector(_cmd));
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSLog(@"%@ - %@", self.weakString, NSStringFromSelector(_cmd));
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"-2--%@ - %@", self.weakString, NSStringFromSelector(_cmd));
    });
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end


#import <objc/runtime.h>
@implementation UIViewController (SwizzlingTest)

+ (void)load
{
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        
//        SEL originalSelector = @selector(viewDidLoad);
//        SEL swizzledSelector = @selector(swizzling_viewDidLoad);
//        
//        Method originalMethod = class_getInstanceMethod([self class], originalSelector);
//        Method swillzedMethod = class_getInstanceMethod([self class], swizzledSelector);
//        
//        method_exchangeImplementations(originalMethod, swillzedMethod);
//    });
}

- (void)swizzling_viewDidLoad
{
    [self swizzling_viewDidLoad];
    NSLog(@"%@+swizzling - %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
}

@end
