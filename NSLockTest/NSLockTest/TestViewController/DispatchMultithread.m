//
//  DispatchMultithreadTestViewController.m
//  NSLockTest
//
//  Created by yixiaoluo on 15/2/26.
//  Copyright (c) 2015年 cn.gikoo. All rights reserved.
//

#import "DispatchMultithread.h"

@interface DispatchMultithread ()

@end

@implementation DispatchMultithread

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //semaphore可以用来控制多进程个数
    dispatch_group_t group = dispatch_group_create();
//    dispatch_semaphore_t semaphore = dispatch_semaphore_create(10);
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    for (int i = 0; i < 100; i++)
    {
//        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        dispatch_group_async(group, queue, ^{
            NSLog(@"%i",i);
            sleep(2);
//            dispatch_semaphore_signal(semaphore);
        });
    }
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        NSLog(@"dispatch_group_notify");
    });
    
    [self testRetainCycle];
}

- (void)testRetainCycle
{
    //the block will be copied into heap.
    //if here is 'weak self', dealloc is called at first, then the block is called. a safe way is to add check 'if(weakSelf == nil){ return; }'
    //if use 'self' directly, the block is called at first, then system will nil the block(break the retain cycle), the next step is to call dealloc
    
    //    __weak typeof(self) weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog(@"%@ - %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    });
}

- (void)dealloc
{
    NSLog(@"%@ - %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
