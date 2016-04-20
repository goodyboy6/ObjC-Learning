//
//  DPDefense.m
//  Design_Patterns
//
//  Created by yixiaoluo on 15/9/9.
//  Copyright (c) 2015年 yixiaoluo. All rights reserved.
//

#import "DPAttackHandler.h"

@implementation DPAttackHandler

- (void)handleAttack:(DPAttack *)attack
{
    [self.nextAttackHandler handleAttack:attack];
}

@end

@implementation DPAvatar

- (void)handleAttack:(DPAttack *)attack
{
    NSLog(@"i hurt by %@: DPAvatar", NSStringFromClass([attack class]));
}

@end

@implementation DPMetalArmor

- (void)handleAttack:(DPAttack *)attack
{
    if ([attack isKindOfClass:[DPSwordAttack class]]) {
        NSLog(@"i handled DPSwordAttack: DPMetalArmor");
    }else{
        [super handleAttack:attack];
    }
}

@end

@implementation DPCrystalShield

- (void)handleAttack:(DPAttack *)attack
{
    if ([attack isKindOfClass:[DPMagicFireAttack class]]) {
        NSLog(@"i handled DPMagicFireAttack: DPCrystalShield");
    }else{
        [super handleAttack:attack];
    }
}

@end
