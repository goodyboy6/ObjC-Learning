//
//  BuilderViewController.m
//  Design_Patterns
//
//  Created by yixiaoluo on 15/4/28.
//  Copyright (c) 2015年 yixiaoluo. All rights reserved.
//

#import "BuilderViewController.h"

@implementation BuilderViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor purpleColor];
    
    Lawer *layer = [Lawer new];
    OldSon *oldSon = [OldSon new];
    YongSon *yongSon = [YongSon new];
    
    [layer devideCaiChan:oldSon];
    [layer devideCaiChan:yongSon];
    
    [oldSon show];
    [yongSon show];
}

@end

@implementation Lawer

- (void)devideCaiChan:(Son *)son
{
    if (son) {
        [son giveMoney];
        [son giveProducts];
    }
}

@end

@implementation Son

- (CaiChan *)caiChan
{
    if (_caiChan == nil) {
        _caiChan = [[CaiChan alloc] init];
    }
    return _caiChan;
}

- (void)giveMoney
{
    //subclass implemtent
}

- (void)giveProducts
{
    //subclass implemtent
}

- (void)show
{
    //subclass implemtent
}

@end

@implementation OldSon

- (void)giveMoney
{
    self.caiChan.money = 12313221000;
}

- (void)giveProducts
{
    self.caiChan.products = @[@"house at hongkong", @"house in chinese", @"ju"];
}

- (void)show
{
    //subclass implemtent
    NSLog(@"give my old son : money: %ld, products: %@", (long)self.caiChan.money, self.caiChan.products);
}

@end

@implementation YongSon

- (void)giveMoney
{
    self.caiChan.money = 90313221000;
}

- (void)giveProducts
{
    self.caiChan.products = @[@"house at japan", @"house in uep", @"sd"];
}

- (void)show
{
    //subclass implemtent
    NSLog(@"give my yong son : money: %ld, products: %@", (long)self.caiChan.money, self.caiChan.products);
}

@end

@implementation CaiChan
@end