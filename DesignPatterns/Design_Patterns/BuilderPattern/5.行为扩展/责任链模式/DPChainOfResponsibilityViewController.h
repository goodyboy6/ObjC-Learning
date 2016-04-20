//
//  DPChainOfResponsibilityViewController.h
//  Design_Patterns
//
//  Created by yixiaoluo on 15/9/9.
//  Copyright (c) 2015年 yixiaoluo. All rights reserved.
//

#import <UIKit/UIKit.h>

//场景：
//RGP游戏当中，每个人物（avatar）可以通过攻击他人获取点数增加防御
//防御道具有金属盔甲（metalArmor）和水晶盾牌(crystalShield)，每种道具只能对付一种攻击，
//金属盔甲可以防御剑（swordAttack）的攻击，水晶盾牌可以防御魔法（magicFire）的攻击，但美人计（honeyTrapAttack）的防御道具还没有

//责任链模式：
//当受到攻击时，如果防御道具无效，则人物受到伤害，金属盔甲－>水晶盾牌->人物 组成了一条责任链
@interface DPChainOfResponsibilityViewController : UIViewController

@end
