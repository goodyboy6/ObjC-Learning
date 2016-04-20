//
//  BlockTest.m
//  NSLockTest
//
//  Created by yixiaoluo on 15/2/26.
//  Copyright (c) 2015年 cn.gikoo. All rights reserved.
//

#import "TestModel.h"

@implementation CopiedObject

- (id)copyWithZone:(NSZone *)zone{
    return [self deepCopy:zone];
}

- (id)shallowCopy:(NSZone *)zone{
    return self;
}

- (id)deepCopy:(NSZone *)zone{
    CopiedObject *copy = [[[self class] allocWithZone:zone] init];
    copy.name = [self.name copyWithZone:zone];
    return copy;
}

@end