//
//  CubesView.m
//  CADemo
//
//  Created by yixiaoluo on 15/11/5.
//  Copyright © 2015年 yixiaoluo. All rights reserved.
//

#import "CubesView.h"

@implementation CubesView

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
    CATransform3D tt = CATransform3DIdentity;
    tt = CATransform3DRotate(tt, -M_PI_4, 1, 0, 0);
    tt = CATransform3DRotate(tt, -M_PI_4, 0, 1, 0);
    CATransformLayer *cube1 = [self cubeWithTransform:tt];
    cube1.frame = CGRectMake(0, 0, self.frame.size.width/2, self.frame.size.height);
    [self.layer addSublayer:cube1];

    tt = CATransform3DIdentity;
    tt = CATransform3DRotate(tt, M_PI_4, 1, 0, 0);
    tt = CATransform3DRotate(tt, M_PI_4, 0, 0, 1);
    CATransformLayer *cube2 = [self cubeWithTransform:tt];
    cube1.frame = CGRectMake(self.frame.size.width/2, 0, self.frame.size.width/2, self.frame.size.height);
    [self.layer addSublayer:cube2];
}

- (CATransformLayer *)cubeWithTransform:(CATransform3D)t
{
    CATransformLayer *transformLayer = [CATransformLayer layer];
    
    //以4为底部,立方体中心点在平面上
    //右侧1
    CATransform3D transform = CATransform3DMakeTranslation(50, 0, 0);
    transform = CATransform3DRotate(transform, M_PI_2, 0, 1, 0);
    [transformLayer addSublayer:[self cubeFaceAtIndex:0 withTransform:transform]];
    
    //上面2
    transform = CATransform3DMakeTranslation(0, 0, 50);
    [transformLayer addSublayer:[self cubeFaceAtIndex:0 withTransform:transform]];
    
    //左侧3
    transform = CATransform3DMakeTranslation(-50, 0, 0);
    transform = CATransform3DRotate(transform, -M_PI_2, 0, 1, 0);
    [transformLayer addSublayer:[self cubeFaceAtIndex:0 withTransform:transform]];

    //下侧4
    transform = CATransform3DMakeTranslation(0, 0, -50);
    transform = CATransform3DRotate(transform, M_PI, 0, 1, 0);
    [transformLayer addSublayer:[self cubeFaceAtIndex:0 withTransform:transform]];
    
    //前5
    transform = CATransform3DMakeTranslation(0, -50, 0);
    transform = CATransform3DRotate(transform, -M_PI_2, 1, 0, 0);
    [transformLayer addSublayer:[self cubeFaceAtIndex:0 withTransform:transform]];
    
    //后6
    transform = CATransform3DMakeTranslation(0, 50, 0);
    transform = CATransform3DRotate(transform, -M_PI_2, 1, 0, 0);
    [transformLayer addSublayer:[self cubeFaceAtIndex:0 withTransform:transform]];
    
    return transformLayer;
}

- (CALayer * )cubeFaceAtIndex:(NSInteger)idnex withTransform:(CATransform3D)trans 
{
    CALayer *layer = [CALayer layer];
    layer.frame = CGRectMake(50, 0, 100, 100);
    layer.backgroundColor = [UIColor colorWithRed:(rand()/(double)INT32_MAX)
                                            green:(rand()/(double)INT32_MAX)
                                             blue:(rand()/(double)INT32_MAX)
                                            alpha:1].CGColor;
    
    layer.transform = trans;
    
    return layer;
}

@end
