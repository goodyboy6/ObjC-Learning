//
//  ViewController.m
//  CADemo
//
//  Created by yixiaoluo on 15/11/3.
//  Copyright © 2015年 yixiaoluo. All rights reserved.
//

#import "ViewController.h"
#import "CALayer+CADHelper.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIView *layerView;

@property (nonatomic) CALayer *firstLayer;

//......................
@property (weak, nonatomic) IBOutlet UIView *topLeftView;
@property (weak, nonatomic) IBOutlet UIView *left;
@property (weak, nonatomic) IBOutlet UIView *right;




@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
//    self.left.alpha = 0.5;
//    self.right.alpha = 0.5;
//    [self.right.layer rasterize];
    
//    self.view.layer.sublayerTransform = ({
//        CATransform3D ori = CATransform3DIdentity;
//        ori.m34 = -1.0/500.0;//添加透视效果
//        ori;
//    });
    
    [self.topLeftView.layer addCornerRadius:10];
    [self.layerView.layer setShadow];

    CALayer *layer = [[CALayer alloc] init];
    layer.frame = self.layerView.bounds;
    [self.layerView.layer addSublayer:layer];
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        
//        [UIView animateWithDuration:2 animations:^{
//            self.topLeftView.layer.transform = ({
//                CATransform3D ori = CATransform3DMakeRotation(M_PI_4, 0, 1, 0);
//                ori;
//            });
////            self.topRightView.layer.transform = ({
////                CATransform3D ori = CATransform3DMakeRotation(-M_PI_4, 0, 1, 0);
////                ori;
////            });
//            
//            self.layerView.layer.doubleSided = NO;//图层背面是否要绘制
//            self.layerView.layer.transform = ({
////                CATransform3D ori = CATransform3DIdentity;
////                ori.m34 = -1.0/500.0;//添加透视效果
//                CATransform3D ori = CATransform3DMakeRotation(M_PI_2 +M_PI_4, 0, 2, 0);
//                ori;
//            });
//        }];
//    });

    
    self.firstLayer = layer;
    [layer setContentsWithImageName:@"copy" contentsGravity:kCAGravityResizeAspect];
    
    CALayer *layer2 = [[CALayer alloc] init];
    layer2.frame = CGRectMake(0, 0, 80, 80);
    layer2.position = CGPointMake(self.layerView.layer.frame.size.width/2, self.layerView.layer.frame.size.height/2);
    layer2.backgroundColor = [UIColor blueColor].CGColor;
    [self.layerView.layer addSublayer:layer2];
    [layer2 changeAnchorTo:CGPointMake(0, 0)];//以左上角为⚓️点
    layer2.affineTransform = ({
        CGAffineTransform transform = CGAffineTransformMakeScale(0.5, 0.5);
        transform = CGAffineTransformTranslate(transform, 200, 0);
        transform = CGAffineTransformRotate(transform, M_PI_2/180*30);
        transform;
    });

    [layer2 setInFrontOfLayer:layer];
//    {
//        //遮罩
//        [layer2 removeFromSuperlayer];
//        layer.mask = layer2;
//    }
    
    {
        layer.magnificationFilter = kCAFilterTrilinear;
    }
}

#pragma mark - UIViewController
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    CGPoint p = [touches.anyObject locationInView:self.view];
    
    CALayer *lay = [self.view.layer hitTest:p];
    if (lay == self.firstLayer) {
        NSLog(@"lay == self.firstLayer");
    }
    
    CGPoint p2 = [self.layerView.layer convertPoint:p fromLayer:self.view.layer];
    if ([self.layerView.layer containsPoint:p2]) {
        NSLog(@"self.layerView.layer contains the click");
    }
}


#pragma mark - CALayerDelegate
//手动布局layer
//- (void)displayLayer:(CALayer *)layer
//{
//}

//- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx
//{
    //config contents

//    CGContextSetLineWidth(ctx, 3);
//    CGContextSetStrokeColorWithColor(ctx, [UIColor blackColor].CGColor);
//    CGContextStrokeEllipseInRect(ctx, layer.bounds);
    
//}


@end
