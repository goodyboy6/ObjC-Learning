//
//  DPFullScreenLayout.m
//  Design_Patterns
//
//  Created by yixiaoluo on 15/9/21.
//  Copyright © 2015年 yixiaoluo. All rights reserved.
//

#import "DPFullScreenLayout.h"

@implementation DPFullScreenLayout

- (instancetype)init
{
    self = [super init];
    
    self.itemSize = [UIScreen mainScreen].bounds.size;
    
    return self;
}

@end
