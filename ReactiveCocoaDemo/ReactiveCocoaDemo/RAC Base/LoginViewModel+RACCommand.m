//
//  LoginViewModel+RACCommand.m
//  ReactiveCocoaDemo
//
//  Created by yixiaoluo on 16/4/21.
//  Copyright © 2016年 yixiaoluo. All rights reserved.
//

#import "LoginViewModel+RACCommand.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@implementation LoginViewModel (RACCommand)

- (RACCommand *)loginCommand;
{
    @weakify(self);
    return [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        
        RACSignal *s = [self loginRequestSignal];
        [s subscribeNext:^(id x) {
            NSLog(@"%@", x);
        }];
        
        [s subscribeCompleted:^{
            NSLog(@"subscribe Completed");
        }];

        return s;
    }];
}

@end
