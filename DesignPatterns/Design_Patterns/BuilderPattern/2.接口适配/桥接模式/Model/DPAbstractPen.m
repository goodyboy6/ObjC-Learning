//
//  DPAbstractPen.m
//  Design_Patterns
//
//  Created by yixiaoluo on 15/9/24.
//  Copyright © 2015年 yixiaoluo. All rights reserved.
//

#import "DPAbstractPen.h"

@implementation DPAbstractPen

- (void)draw:(DPShape *)shape
{
    [shape draw];
}

@end

@implementation DPPen

- (void)draw:(DPShape *)shape
{
    NSLog(@"pen ");
    [super draw:shape];
}

@end


@implementation DPPencil

- (void)draw:(DPShape *)shape
{
    NSLog(@"pencil ");
    [super draw:shape];
}

@end

