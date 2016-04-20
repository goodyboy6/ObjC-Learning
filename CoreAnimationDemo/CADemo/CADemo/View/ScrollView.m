//
//  ScrollView.m
//  CADemo
//
//  Created by yixiaoluo on 15/11/9.
//  Copyright © 2015年 yixiaoluo. All rights reserved.
//

#import "ScrollView.h"

@implementation ScrollView

+ (Class)layerClass
{
    return [CAScrollLayer class];
}

- (CAScrollLayer *)scrollLayer
{
    return (CAScrollLayer *)self.layer;
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
    self.layer.masksToBounds = YES;
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [self addGestureRecognizer:pan];
}

- (void)pan:(UIPanGestureRecognizer *)g
{
    CGPoint offset = self.bounds.origin;
    offset.x -= [g translationInView:self].x;//＝＝》 CATransform3DMakeTranslation(100, 20, 20);
    offset.y -= [g translationInView:self].y;
    
    [self.scrollLayer scrollPoint:offset];
    
    [g setTranslation:CGPointZero inView:self];
}

@end
