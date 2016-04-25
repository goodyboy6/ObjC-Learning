//
//  LoginViewModel.h
//  ReactiveCocoaDemo
//
//  Created by yixiaoluo on 16/4/20.
//  Copyright © 2016年 yixiaoluo. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RACSubject, RACSignal;
@interface LoginViewModel : NSObject

@property (nonatomic) NSString *userName;
@property (nonatomic) NSString *password;

- (RACSubject *)loginRequestSignal;

- (void)login;


- (RACSignal *)loginRequestSignal1;
- (RACSignal *)loginRequestSignal2;

@end
