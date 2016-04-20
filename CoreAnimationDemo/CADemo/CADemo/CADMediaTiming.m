//
//  CADMediaTiming.m
//  CADemo
//
//  Created by yixiaoluo on 15/11/13.
//  Copyright © 2015年 yixiaoluo. All rights reserved.
//

#import "CADMediaTiming.h"

@interface CADMediaTiming ()

@property (weak, nonatomic) IBOutlet UIView *centerView;

@property (nonatomic) CALayer *demoLayer;

@end

@implementation CADMediaTiming

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.demoLayer = [CALayer layer];
    self.demoLayer.frame = CGRectMake(100, 100, 60, 60);
    self.demoLayer.contents = (__bridge id)[UIImage imageNamed:@"Super_Star_NSMB2"].CGImage;
    self.demoLayer.contentsGravity = kCAGravityResizeAspect;
    [self.centerView.layer addSublayer:self.demoLayer];
}

- (IBAction)buttonClicked:(id)sender {
    [self demo2];
}


#pragma mark - demo2 测试三次贝塞尔曲线
- (void)demo2
{
    CAMediaTimingFunction *func = [CAMediaTimingFunction functionWithControlPoints:1 :0 :0.75 :1];//functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    CGPoint p1, p2;
    [func getControlPointAtIndex:1 values:(float *)&p1];
    [func getControlPointAtIndex:2 values:(float *)&p2];

    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0, 300)];
    [path addLineToPoint:CGPointMake(300, 300)];

    CAKeyframeAnimation *key = [CAKeyframeAnimation animation];
    key.timingFunction = func;
    key.keyPath = @"position";
    key.path = path.CGPath;
    key.duration = 5;
    [self.demoLayer addAnimation:key forKey:nil];
    
//    CGPoint p1, p2;
//    [func getControlPointAtIndex:1 values:(float *)&p1];
//    [func getControlPointAtIndex:2 values:(float *)&p2];
//
//    UIBezierPath *path = [UIBezierPath bezierPath];
//    [path moveToPoint:CGPointMake(0, 0)];
//    [path addCurveToPoint:CGPointMake(300, 300) controlPoint1:p1 controlPoint2:p2];
//    
//    CAShapeLayer *shape = [CAShapeLayer layer];
//    shape.path = path.CGPath;
//    shape.strokeColor = [UIColor redColor].CGColor;
//    shape.fillColor = [UIColor clearColor].CGColor;
//    
//    [self.centerView.layer addSublayer:shape];
//    self.centerView.layer.geometryFlipped = YES;
}

#pragma mark - demo1 手动动画
- (void)pan:(UIPanGestureRecognizer *)g
{
    CGPoint p = [g translationInView:self.view];
    
    self.demoLayer.timeOffset += p.x/100;
    
    [g setTranslation:CGPointZero inView:self.view];
}

- (void)demo1
{
    CABasicAnimation *scale = [CABasicAnimation animation];
    scale.keyPath = @"transform.scale";
    scale.toValue = @(3);
    
    CABasicAnimation *opacity = [CABasicAnimation animation];
    opacity.keyPath = @"opacity";
    opacity.toValue = @(0);
    
    CABasicAnimation *rorate = [CABasicAnimation animation];
    rorate.keyPath = @"transform.rotation.x";
    rorate.byValue = @(M_PI_2);

    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.animations = @[scale, opacity, rorate];
    group.repeatCount = 2;
//    group.repeatDuration = INFINITY;
//    group.autoreverses = YES;//动画恢复默认状态，再来一次动画：自动回放
    group.duration = 5;
    group.fillMode = kCAFillModeBackwards;
    
    [self.demoLayer addAnimation:group forKey:nil];
    self.demoLayer.speed = 0;//禁用自动播放

    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [self.view addGestureRecognizer:pan];
}
@end
