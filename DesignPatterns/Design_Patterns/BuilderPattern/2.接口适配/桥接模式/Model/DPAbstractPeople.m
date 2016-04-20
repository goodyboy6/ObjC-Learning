//
//  DPPerson.m
//  Design_Patterns
//
//  Created by yixiaoluo on 15/9/24.
//  Copyright © 2015年 yixiaoluo. All rights reserved.
//

#import "DPAbstractPeople.h"

@implementation DPAbstractPeople

- (void)driveToBeiJing
{
    NSLog(@"%@ drive %@ to HeiJing on %@", self.description, self.car.description, self.road.description);
}

@end

@implementation DPMale

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@", @"male"];
}

- (void)driveToBeiJing
{
    [super driveToBeiJing];
}

@end

@implementation DPFemale

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@", @"female"];
}

- (void)driveToBeiJing
{
    [super driveToBeiJing];
}

@end


