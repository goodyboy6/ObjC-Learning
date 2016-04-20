//
//  DPChainOfResponsibilityViewController.m
//  Design_Patterns
//
//  Created by yixiaoluo on 15/9/9.
//  Copyright (c) 2015年 yixiaoluo. All rights reserved.
//

#import "DPChainOfResponsibilityViewController.h"
#import "DPAttack.h"
#import "DPAttackHandler.h"

@interface DPChainOfResponsibilityViewController ()

@property (weak, nonatomic) IBOutlet UITextView *textContrainer;

@property (nonatomic) DPMetalArmor *metalArmor;

@end

@implementation DPChainOfResponsibilityViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //客户端代码
    //创建人物及防御道具
    DPAvatar *avatar = [[DPAvatar alloc] init];
    
    DPCrystalShield *crystalShield = [[DPCrystalShield alloc] init];
    crystalShield.nextAttackHandler = avatar;
    
    DPMetalArmor *metalArmor = [[DPMetalArmor alloc] init];
    metalArmor.nextAttackHandler = crystalShield;
    
    self.metalArmor = metalArmor;
}

//创建攻击道具并进行攻击
- (IBAction)sword:(id)sender
{
    DPSwordAttack *swordAttack = [[DPSwordAttack alloc] init];
    [self.metalArmor handleAttack:swordAttack];
}

- (IBAction)magic:(id)sender
{
    DPMagicFireAttack *magicFireAttack = [[DPMagicFireAttack alloc] init];
    [self.metalArmor handleAttack:magicFireAttack];
}

- (IBAction)trap:(id)sender
{
    DPHoneyTrapAttack *trapAttack = [[DPHoneyTrapAttack alloc] init];
    [self.metalArmor handleAttack:trapAttack];
}

@end