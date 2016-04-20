//
//  UIStoryboard+Shared.m
//  NSLockTest
//
//  Created by yixiaoluo on 15/3/9.
//  Copyright (c) 2015年 cn.gikoo. All rights reserved.
//

#import "UIStoryboard+Shared.h"

@implementation UIStoryboard (Shared)

+ (instancetype)shared
{
    static UIStoryboard *s = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        s = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    });
    return s;
}

@end
