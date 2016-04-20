//
//  EmitterView.m
//  CADemo
//
//  Created by yixiaoluo on 15/11/11.
//  Copyright © 2015年 yixiaoluo. All rights reserved.
//

#import "EmitterView.h"

@implementation EmitterView

+ (Class)layerClass
{
    return [CAEmitterLayer class];
}

- (CAEmitterLayer *)emitterLayer
{
    return (CAEmitterLayer *)self.layer;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setup];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    [self setup];
    return self;
}

- (void)setup
{    
    //config emitter
    [self emitterLayer].renderMode = kCAEmitterLayerOldestLast;
    [self emitterLayer].emitterPosition = CGPointMake(self.frame.size.width/2, self.frame.size.height-40);
    [self emitterLayer].emitterSize = CGSizeMake(200, 40);
    
    //config cell
    CAEmitterCell *cell = [CAEmitterCell emitterCell];
    cell.contents = (__bridge id)[UIImage imageNamed:@"Super_Star_NSMB2"].CGImage;
    cell.birthRate = 50;//每秒产生的粒子数
    cell.lifetime = 5.0;
    cell.alphaSpeed = -0.4;
    cell.velocity = 50;
    cell.emissionRange = M_PI_4;
    cell.emissionLongitude = -M_PI_2;//控制发射方向
    
    //add cell
    [self emitterLayer].emitterCells = @[cell];
}

@end
