//
//  RunLoop.m
//  NSLockTest
//
//  Created by yixiaoluo on 15/4/17.
//  Copyright (c) 2015年 cn.gikoo. All rights reserved.
//

#import "RunLoop.h"

@implementation RunLoop{
    NSInteger _totalTimes;
    NSTimer *_timer;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self performSelectorInBackground:@selector(startATimerInBackground) withObject:nil];
    NSLog(@"%@ - %@ - %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), [NSThread currentThread]);
}

- (void)startATimerInBackground
{
    @autoreleasepool {
        NSRunLoop *currentRunLoop = [NSRunLoop currentRunLoop];
        
        NSLog(@"--timer start--");

        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(ddescription) userInfo:nil repeats:YES];
        [currentRunLoop addTimer:timer forMode:NSRunLoopCommonModes];
        [timer fire];
        
        _timer = timer;
        
        [currentRunLoop run];
        
        NSLog(@"--timer finished--");
        
        //here we observe current runloop start and end status when no input after [_time invalidate]
        
    }
}

- (void)ddescription
{
    NSLog(@"%@ - %@ - %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), [NSThread currentThread]);
    
    _totalTimes++;
    
    //make crash: ui refresh in background thread
    self.view.frame = CGRectInset(self.view.frame, 20, 20);
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [_timer invalidate];
}

- (void)dealloc
{
    [_timer invalidate];
}

#pragma mark - check observer life cycle



@end
