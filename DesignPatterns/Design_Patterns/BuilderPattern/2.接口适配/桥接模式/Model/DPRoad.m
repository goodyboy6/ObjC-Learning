//
//  DPRoad.m
//  Design_Patterns
//
//  Created by yixiaoluo on 15/9/24.
//  Copyright © 2015年 yixiaoluo. All rights reserved.
//

#import "DPRoad.h"

@implementation DPRoad

@end

@implementation DPNormalRoad

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@", @"normal road"];
}

@end

@implementation DPHighWay

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@", @"highway"];
}

@end
