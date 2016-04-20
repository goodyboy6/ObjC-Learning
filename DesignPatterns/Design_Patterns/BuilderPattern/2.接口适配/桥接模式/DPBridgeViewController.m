//
//  DPBridgeViewController.m
//  Design_Patterns
//
//  Created by yixiaoluo on 15/9/24.
//  Copyright © 2015年 yixiaoluo. All rights reserved.
//

#import "DPBridgeViewController.h"
#import "DPAbstractPeople.h"
#import "DPAbstractPen.h"

@implementation DPBridgeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //男人在高速路上开smart去北京
    DPAbstractPeople *male = [[DPMale alloc] init];
    male.car = [[DPSmart alloc] init];
    male.road = [[DPHighWay alloc] init];
    [male driveToBeiJing];
    
    //女人在省省高速路上开大巴去北京
    DPAbstractPeople *female = [[DPFemale alloc] init];
    female.car = [[DPBus alloc] init];
    female.road = [[DPNormalRoad alloc] init];
    [female driveToBeiJing];
    
    NSLog(@"-------------------------------");
    
    //拿钢笔画线
    DPAbstractPen *pen = [[DPPen alloc] init];
    [pen draw:[[DPLine alloc] init]];
    
    //拿铅笔画圈
    DPAbstractPen *pencil = [[DPPencil alloc] init];
    [pencil draw:[[DPPoint alloc] init]];    
}

@end
