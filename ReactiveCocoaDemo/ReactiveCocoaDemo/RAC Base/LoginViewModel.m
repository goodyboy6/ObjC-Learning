//
//  LoginViewModel.m
//  ReactiveCocoaDemo
//
//  Created by yixiaoluo on 16/4/20.
//  Copyright © 2016年 yixiaoluo. All rights reserved.
//

#import "LoginViewModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@implementation LoginViewModel

- (void)login
{
    RACSubject *loginFinshedSignal = [self loginRequestSignal];
    
    [loginFinshedSignal subscribeNext:^(id x) {
        NSLog(@"loginFinshed: %@", x);
    } error:^(NSError *error) {
        NSLog(@"loginfailed: %@", error);
    } completed:^{
        
    }];
}

- (RACSignal *)loginRequestSignal
{
    RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
            NSDictionary *userInfo = @{
                                       @"userName":@"Jack",
                                       @"sex":@"1",
                                       @"address":@"HangZhou"
                                       };
            
            dispatch_async(dispatch_get_main_queue(), ^(void) {
                [subscriber sendNext:userInfo];
                [subscriber sendCompleted];
            });
        });
        
        return nil;
    }];
    
    return signal;

}

- (RACSignal *)loginRequestSignal1
{
    RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
            NSDictionary *userInfo = @{
                                       @"userName":@"Jack111",
                                       @"sex":@"111",
                                       @"address":@"HangZhou111"
                                       };
            
            dispatch_async(dispatch_get_main_queue(), ^(void) {
                [subscriber sendNext:userInfo];
                [subscriber sendCompleted];
            });
        });
        
        return nil;
    }];
    
    return signal;
    
}

- (RACSignal *)loginRequestSignal2
{
    RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
            NSDictionary *userInfo = @{
                                       @"userName":@"Jack222",
                                       @"sex":@"222",
                                       @"address":@"HangZhou222"
                                       };
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [subscriber sendNext:userInfo];
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [subscriber sendNext:userInfo];
                    [subscriber sendCompleted];
                });
            });
        });
        
        return nil;
    }];
    
    return signal;
    
}

//
//- (RACSubject *)loginRequestSignal
//{
//    RACSubject *signal = [RACSubject subject];
//    
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
//        NSDictionary *userInfo = @{
//                                   @"userName":@"Jack",
//                                   @"sex":@"1",
//                                   @"address":@"HangZhou"
//                                   };
//        
//        dispatch_async(dispatch_get_main_queue(), ^(void) {
//            [signal sendNext:userInfo];
////            [signal sendError:nil];
//        });
//    });
//    
//    return signal;
//}

@end
