//
//  CADAnimationViewController.m
//  CADemo
//
//  Created by yixiaoluo on 15/11/11.
//  Copyright © 2015年 yixiaoluo. All rights reserved.
//

#import "CADImplicitAnimation.h"

@interface CADImplicitAnimation ()

@property (weak, nonatomic) IBOutlet UIView *colorView;
@property (nonatomic) CALayer *colorLayer;

@end

@implementation CADImplicitAnimation

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
    [self demo3];
}

#pragma mark - demo4
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    CGPoint p = [[touches anyObject] locationInView:self.view];
    
    //self.colorLayer.presentationLayer动画过程中的呈现图层做响应；self.colorLayer则是动画结束后图层；
    //后者无法在动画过程中正确检测图层位置。presentationLayer回归到modelLayer。
    //对presentationLayer的modelLayer返回其所依赖的modelLayer， 测试发现就是当前CALayer的modelLayer（即目标model）。
    
    //modellayer树是CALayer（测试之后好想就是CALayer本身）的一个属性变化的历史记录，在动画过程中取的是动画结束后的CALayer；
    //presentation树由多个呈现图层组成，model树可以理解为由多个节点组成，presentation树则是这些对应节点发生变化过程中的呈现图层组成。每个modeltree节点到下一个节点的动画过程中，屏幕以60帧／s的速度绘制，即每秒产生60个呈现图层，这些图层组成了呈献树。
    //换句话说，在显示呈现图层（presentation tree）时，必须知道对应的两个节点（modellayer tree），从哪里来，要到哪里去，怎么去。
    
    CALayer *currentLayer = self.colorLayer.presentationLayer;
    if ([currentLayer hitTest:p]) {
        NSLog(@"animating: %@", NSStringFromCGPoint([[[self.colorLayer presentationLayer] modelLayer] position]));
        self.colorLayer.backgroundColor = [[UIColor colorWithRed:arc4random()%255/255 green:arc4random()%255/255. blue:arc4random()%255/255. alpha:1] CGColor];
    }else{
        NSLog(@"begin: %@", NSStringFromCGPoint([self.colorLayer.modelLayer position]));
        [CATransaction begin];
        [CATransaction setAnimationDuration:5];
        [CATransaction setCompletionBlock:^{
            NSLog(@"end: %@", NSStringFromCGPoint([self.colorLayer.modelLayer position]));
            NSLog(@"end presentationLayer: %@", NSStringFromCGPoint([[self.colorLayer presentationLayer] position]));
        }];
        self.colorLayer.position = p;
        [CATransaction commit];
    }
}

#pragma mark - demo3
- (void)demo3
{
    //add cunstom action
    CATransition *t = [CATransition animation];
    t.type = kCATransitionMoveIn;
    t.subtype = kCATransitionFromLeft;
    
    self.colorLayer.actions = @{@"backgroundColor":t};

    [self demo1];
}

#pragma mark - demo2
- (void)demo2
{
    //以下代码表明： UIView的图层禁掉了隐士动画。。。
//    NSLog(@"outside: %@", [self.colorView actionForLayer:self.colorView.layer forKey:@"backgroundColor"]);
//    [CATransaction begin];//入栈
//    [CATransaction setAnimationDuration:2.0];
//    
//    self.colorView.layer.backgroundColor = [UIColor blackColor].CGColor;
//    
//    NSLog(@"inside 1: %@", [self.colorView actionForLayer:self.colorView.layer forKey:@"backgroundColor"]);
//
//    [CATransaction commit];//出栈
    
    //对UIView的图层做动画必须使用UIView的动画函数，而不是依赖CATransaction
    [UIView beginAnimations:nil context:nil];//入栈
    [UIView setAnimationDuration:2.0];
    
    NSLog(@"inside 2: %@", [self.colorView actionForLayer:self.colorView.layer forKey:@"backgroundColor"]);

    self.colorView.layer.backgroundColor = [UIColor blackColor].CGColor;
    
    [UIView commitAnimations];//出栈
}

#pragma mark - demo1
- (void)demo1
{
    [CATransaction begin];//入栈
    [CATransaction setAnimationDuration:1.0];
    [CATransaction setCompletionBlock:^{
        [CATransaction setAnimationDuration:2.0];//已经出当前栈，设置的是当前runloop中隐式生成的CATransaction的时间
        self.colorLayer.transform = CATransform3DMakeRotation(M_PI_4, 0, 0, 1);
    }];
    
    self.colorLayer.backgroundColor = [UIColor blackColor].CGColor;
    
    [CATransaction commit];//出栈
}
@end
