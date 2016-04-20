//
//  DPPerson.h
//  Design_Patterns
//
//  Created by yixiaoluo on 15/9/24.
//  Copyright © 2015年 yixiaoluo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DPCar.h"
#import "DPRoad.h"

@interface DPAbstractPeople : NSObject

@property (nonatomic) DPCar *car;
@property (nonatomic) DPRoad *road;

- (void)driveToBeiJing;

@end

@interface DPMale : DPAbstractPeople

@end

@interface DPFemale : DPAbstractPeople

@end

