//
//  LoginViewModel+RACCommand.h
//  ReactiveCocoaDemo
//
//  Created by yixiaoluo on 16/4/21.
//  Copyright © 2016年 yixiaoluo. All rights reserved.
//

#import "LoginViewModel.h"

@class RACCommand;
@interface LoginViewModel (RACCommand)

- (RACCommand *)loginCommand;

@end
