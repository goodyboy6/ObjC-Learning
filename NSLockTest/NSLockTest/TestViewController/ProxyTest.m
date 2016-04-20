//
//  ProxyViewController.m
//  NSLockTest
//
//  Created by yixiaoluo on 15/3/3.
//  Copyright (c) 2015年 cn.gikoo. All rights reserved.
//

#import "ProxyTest.h"

@interface ProxyTest ()

@end

@implementation ProxyTest

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSLog(@"%@ - %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    
    UILabel *testLabel = [[UILabel alloc] initWithFrame:CGRectMake(200, 200, 200, 40)];
    testLabel.backgroundColor = [UIColor whiteColor];
    testLabel.font = [UIFont systemFontOfSize:90];
    testLabel.text = @"苏丹诺夫三闾大夫年历史的苦难弗兰克苏丹诺夫历史年代发明是德拉克马发生了多方面实力是父母段落分明三闾大夫";
    testLabel.tintColor = [UIColor redColor];
    testLabel.textColor = [UIColor blackColor];
    [self.view addSubview:testLabel];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    TestProxy *p = [[TestProxy alloc] init];
    [p performSelector:@selector(viewDidLoad) withObject:nil];
    [p method1];
}

@end

@implementation TestProxy{
    ProxyTest *obj1;
}

- (instancetype)init
{
    obj1 = [[ProxyTest alloc] init];
    return self;
}

- (void)method1
{
    NSLog(@"%@ - %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
}

- (void)forwardInvocation:(NSInvocation *)invocation
{
    NSLog(@"%@ - %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    //if not invoke the target, nothing will happen. because no object response to the selector
    [invocation invokeWithTarget:obj1];
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel
{
    NSLog(@"%@ - %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    //if return nil, it will crash: Terminating app due to uncaught exception 'NSInvalidArgumentException', reason: '*** -[NSProxy doesNotRecognizeSelector:viewDidLoad] called!'
    //return nil;
    
    return [obj1 methodSignatureForSelector:sel];
}

@end