//
//  GBPerson.m
//  GBKit
//
//  Created by yixiaoluo on 15/12/7.
//  Copyright © 2015年 yixiaoluo. All rights reserved.
//

#import "GBPerson.h"

@implementation GBPerson

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@ class", NSStringFromClass([self class])];
}

@end
