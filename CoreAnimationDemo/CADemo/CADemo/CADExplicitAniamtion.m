//
//  CADExplicitAniamtion.m
//  CADemo
//
//  Created by yixiaoluo on 15/11/12.
//  Copyright © 2015年 yixiaoluo. All rights reserved.
//

#import "CADExplicitAniamtion.h"

@interface CADExplicitAniamtion ()

@property (weak, nonatomic) IBOutlet UIView *colorView;
@property (nonatomic) CALayer *colorLayer;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *button;

@end

@implementation CADExplicitAniamtion

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.colorLayer = [CALayer layer];
    self.colorLayer.frame = CGRectMake(50, 50, 100, 100);
    self.colorLayer.backgroundColor = [UIColor redColor].CGColor;
    
    [self.colorView.layer addSublayer:self.colorLayer];
}

- (IBAction)changeColor:(id)sender
{
    [self demo2];
}

#pragma mark - demo7 remove anitmation
- (void)demo7
{
    [self demo4];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.colorLayer removeAnimationForKey:@"groupAnimation"];
    });
}

#pragma mark - demo6 自定义过渡效果 renderInContext:
- (void)demo6
{
    //创建截图
    UIGraphicsBeginImageContextWithOptions(self.imageView.bounds.size, 1, 1);
    [self.imageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    //添加为mask
    UIImageView *coverView = [[UIImageView alloc] initWithImage:image];
    coverView.frame = self.imageView.bounds;
    [self.imageView addSubview:coverView];
    
    self.imageView.image = [UIImage imageNamed:@"Super_Star_NSMB2"];

    [UIView animateWithDuration:3 animations:^{
        coverView.alpha = 0;
        CGAffineTransform f = CGAffineTransformMakeRotation(M_PI_4);
        f = CGAffineTransformScale(f, .1, .1);
        coverView.transform = f;
    } completion:^(BOOL finished) {
        [coverView removeFromSuperview];
    }];
}

#pragma mark - demo5 过渡
- (void)demo5
{
    //改变不能动画的属性，于是有了过渡的概念。
    //过渡是整个图层的变化，不论改变了什么属性。
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        CATransition *transition = [CATransition animation];
        transition.type = kCATransitionFade;
        transition.subtype = kCATransitionFromBottom;
        transition.duration = 3;
        [self.imageView.layer addAnimation:transition forKey:nil];
    });
    
    self.imageView.image = [UIImage imageNamed:@"Super_Star_NSMB2"];
    self.imageView.backgroundColor = [UIColor blueColor];
    self.imageView.center = CGPointMake(100, 100);//只有center的时候可以动画，加上上面两个postion就不动了。
}

- (void)demo51
{
    //过渡将会作用于宿主图层的所有子图层， 好牛逼。。。
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        CATransition *transition = [CATransition animation];
        transition.type = kCATransitionPush;
        transition.subtype = kCATransitionFromLeft;
        transition.duration = 3;
        [self.view.layer addAnimation:transition forKey:nil];
    });
    
    [self.button removeFromSuperview];
//    self.view.backgroundColor = [UIColor yellowColor];
}

#pragma mark - demo4 动画组
- (void)demo4
{
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.duration = 5;
    
    //旋转动画
    CABasicAnimation *rorateAnimation = [CABasicAnimation animation];
    rorateAnimation.keyPath = @"transform.rotation";
    rorateAnimation.byValue = @(M_PI_2*3/2);//相对值
//    rorateAnimation.duration = 2;

    //背景色变化动画
    CABasicAnimation *colorAnimation = [CABasicAnimation animation];
    colorAnimation.keyPath = @"backgroundColor";
    colorAnimation.toValue = (__bridge id)[UIColor blueColor].CGColor;
//    colorAnimation.duration = 2;

    //CAAniamtion子类，就多了一个animations属性
    //子元素的during属性将会被CAAnimationGroup的during属性覆盖
    animationGroup.animations = @[rorateAnimation, colorAnimation];
    
    [self.colorLayer addAnimation:animationGroup forKey:@"groupAnimation"];
}


#pragma mark - demo3 虚拟属性
- (void)demo31
{
    CABasicAnimation *baseAnimation = [CABasicAnimation animation];
    
    //还有transform.scale
    //transform.rotation默认为z轴，还有transform.rotation.x, transform.rotation.y
    baseAnimation.keyPath = @"transform.rotation";//虚拟属性，CAValueFunction将其转换成对应的CATransfrom3D矩阵，CoreAnimaiton根据计算出来的值更新transform的属性。
    baseAnimation.byValue = @(M_PI_2*3/2);//相对值；toValue为绝对值
    baseAnimation.duration = 2;
    
    [self.colorLayer addAnimation:baseAnimation forKey:nil];
}

- (void)demo3
{
    CABasicAnimation *baseAnimation = [CABasicAnimation animation];
    
    baseAnimation.keyPath = @"transform";
    baseAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI_4, 0, 0, 1)];//绝对值
    baseAnimation.duration = 2;
    
    [self.colorLayer addAnimation:baseAnimation forKey:nil];
}

#pragma mark - demo2 CAKeyFrameAnimation
- (void)demo21
{
    //飞机layer
    CALayer *plane = [CALayer layer];
    plane.contents = (__bridge id)[UIImage imageNamed:@"iconfont-feiji"].CGImage;
    plane.position = CGPointMake(0, 150);
    plane.contentsGravity = kCAGravityCenter;
    [self.view.layer addSublayer:plane];

    //轨迹
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0, 150)];
    [path addCurveToPoint:CGPointMake(300, 150) controlPoint1:CGPointMake(75, 0) controlPoint2:CGPointMake(225, 300)];
    
    //描画这个CGPatch的轨迹，飞机会在这条线上飞，这样又一个很好的视觉效果
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = path.CGPath;
    shapeLayer.strokeColor = [UIColor redColor].CGColor;
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.lineWidth = 3;
    [self.view.layer addSublayer:shapeLayer];

    //关键帧动画
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
    animation.path = path.CGPath;
    animation.keyPath = @"position";
    animation.duration = 3.0;
    animation.delegate = self;
    animation.rotationMode = kCAAnimationRotateAuto;//沿切线飞行
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    //飞机添加动画
    [plane addAnimation:animation forKey:nil];
    
    //动画结束后移除
    [animation setValue:plane forKey:@"plane"];
    [animation setValue:shapeLayer forKey:@"shapeLayer"];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
#warning 为啥取出来的两个对象为nil...
    CALayer *plane = [anim valueForKey:@"plane"];
    CAShapeLayer *shape = [anim valueForKey:@"shapeLayer"];
    [plane removeFromSuperlayer];
    [shape removeFromSuperlayer];
}

- (void)demo2
{
    //关键帧动画：关键帧，顾名思义，提供关键的帧，Core Animation来帮助在关键帧和关键帧之间插入呈现图层
    CAKeyframeAnimation *kf = [CAKeyframeAnimation animation];
    kf.keyPath = @"backgroundColor";
    kf.duration = 4.0;
    kf.values = @[
                  (__bridge id)[UIColor redColor].CGColor,//保证颜色的平滑从初始颜色过渡到第一帧
                  (__bridge id)[UIColor yellowColor].CGColor,
                  (__bridge id)[UIColor blackColor].CGColor,
                  (__bridge id)[UIColor purpleColor].CGColor,
                  (__bridge id)[UIColor redColor].CGColor//保证颜色的从最后一帧平滑过渡到初始颜色
                  ];
    
    CAMediaTimingFunction *func = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    kf.timingFunctions = @[func, func, func, func];//＝＝values.count－1
    kf.keyTimes = @[@0., @.0, @.0,@0, @4];
    [self.colorLayer addAnimation:kf forKey:nil];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    __unused CGPoint p = [[touches anyObject] locationInView:self.view];
}

#pragma mark - demo1 属性动画
- (void)demo1
{
    //只执行动画，动画结束之后回复初始状态。
    CABasicAnimation *basicAniamtion = [CABasicAnimation animation];
    basicAniamtion.keyPath = @"backgroundColor";
    basicAniamtion.toValue = (__bridge id)[UIColor yellowColor].CGColor;
    basicAniamtion.delegate = self;
    
    [self.colorLayer addAnimation:basicAniamtion forKey:nil];
}

//- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
//{
//    [CATransaction begin];
//    [CATransaction setDisableActions:YES];//关闭隐式动画。但在真机上还是会闪一下
//    self.colorLayer.backgroundColor = (__bridge CGColorRef _Nullable)((id)[(CABasicAnimation *)anim toValue]);
//    [CATransaction commit];
//}

@end
