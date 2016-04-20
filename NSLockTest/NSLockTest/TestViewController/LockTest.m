//
//  LockTestViewController.m
//  NSLockTest
//
//  Created by yixiaoluo on 15/2/26.
//  Copyright (c) 2015年 cn.gikoo. All rights reserved.
//

#import "LockTest.h"
#import <pthread.h>

@interface LockTest ()

@end

@implementation LockTest

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    [self lock1];
//    [self lock2];
//    [self lock3];
//    [self lock4];
    [self lock5];
}

#pragma mark - Lock
- (void)lock1
{
    NSLock *testLock = [[NSLock alloc] init];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [testLock lock];
        [self method1];
        
        sleep(5);
        
        [testLock unlock];
    });
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        sleep(1);
        [testLock lock];
        [self method2];
        [testLock unlock];
    });
}

- (void)lock2
{
    //@synchronized(obj)
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        @synchronized(self){
            [self method1];
            sleep(5);
        }
    });
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        sleep(1);
        @synchronized(self){
            [self method2];
        }
    });
}

- (void)lock3
{
    //c pthread_mutex_t
    __block pthread_mutex_t mutex;
    pthread_mutex_init(&mutex, NULL);
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        pthread_mutex_lock(&mutex);
        [self method1];
        sleep(5);
        pthread_mutex_unlock(&mutex);
    });
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        sleep(1);
        
        pthread_mutex_lock(&mutex);
        [self method2];
        pthread_mutex_unlock(&mutex);
    });
}


#pragma mark - GCD
- (void)lock4
{
    //gcd semaphore
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(1);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        [self method1];
        sleep(5);
        dispatch_semaphore_signal(semaphore);
    });
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        sleep(1);
        
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        [self method2];
        dispatch_semaphore_signal(semaphore);
    });
}

- (void)lock5
{
    //serial queue
    dispatch_queue_t serialQueue = dispatch_queue_create("cn.gikoo.lockTest", NULL);
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(serialQueue, ^{
            [self method2];
            sleep(5);
        });
    });
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        sleep(1);
        dispatch_async(serialQueue, ^{
            [self method2];
        });
    });
}

#pragma mark - Private
- (void)method1
{
    NSLog(@"%@ - %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
}

- (void)method2
{
    NSLog(@"%@ - %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
}

@end
