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


- (RACSubject *)loginRequestSignal
{
    RACSubject *signal = [RACSubject subject];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
        NSDictionary *userInfo = @{
                                   @"userName":@"Jack",
                                   @"sex":@"1",
                                   @"address":@"HangZhou"
                                   };
        
        dispatch_async(dispatch_get_main_queue(), ^(void) {
//            [signal sendNext:userInfo];
            [signal sendError:nil];
        });
    });
    
    return signal;
}

@end
