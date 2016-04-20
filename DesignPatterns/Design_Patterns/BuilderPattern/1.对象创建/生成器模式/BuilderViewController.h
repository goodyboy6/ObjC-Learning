//
//  BuilderViewController.h
//  Design_Patterns
//
//  Created by yixiaoluo on 15/4/28.
//  Copyright (c) 2015年 yixiaoluo. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  生成者模式
 *  生成器模式是为了构造一个复杂的产品，而且购造这个产品遵循一定的规则（相同的过程），规则由执行者来执行
 */
@interface BuilderViewController : UIViewController

@end


/**
 *  李嘉诚分财产
 *  财产（产品角色）：李嘉诚拥有众多复杂的财产框架，这里以现金与物品入例。
 *  遗嘱（建造者）：相当于建造者，分配现金与物品。
 *  具体遗嘱（具体建造者）：1.给大儿子的财产分配，2，给小儿子的财产分配。
 *  律师（指导者角色）：按照具体的遗嘱指令分配财产。
 */
@class CaiChan;
@interface Son : NSObject

@property (nonatomic) CaiChan *caiChan;

//abstract methods
- (void)giveMoney;
- (void)giveProducts;

//公示被分配的财产
- (void)show;

@end

@interface OldSon : Son
@end

@interface YongSon : Son
@end

//director 律师
@interface Lawer : NSObject

- (void)devideCaiChan:(Son *)son;

@end


//需要被财产
@interface CaiChan : NSObject

@property (nonatomic) NSInteger money;
@property (nonatomic) NSArray *products;

@end

