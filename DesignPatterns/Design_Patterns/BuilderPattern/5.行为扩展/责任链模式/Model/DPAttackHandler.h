//
//  DPDefense.h
//  Design_Patterns
//
//  Created by yixiaoluo on 15/9/9.
//  Copyright (c) 2015年 yixiaoluo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DPAttack.h"

@interface DPAttackHandler : NSObject

@property (nonatomic, strong) DPAttackHandler *nextAttackHandler;

- (void)handleAttack:(DPAttack *)attack;

@end


@interface DPAvatar : DPAttackHandler

@end

@interface DPMetalArmor : DPAttackHandler

@end

@interface DPCrystalShield : DPAttackHandler

@end
