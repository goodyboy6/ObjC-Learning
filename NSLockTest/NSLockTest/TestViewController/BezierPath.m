//
//  BezierPath.m
//  NSLockTest
//
//  Created by yixiaoluo on 15/3/16.
//  Copyright (c) 2015年 cn.gikoo. All rights reserved.
//

#import "BezierPath.h"
#import "Masonry.h"

@implementation BezierPath

- (void)viewDidLoad
{
    [super viewDidLoad];
 
//    BezierPathView *view = [[BezierPathView alloc] init];
//    [self.view addSubview:view];
//    [view mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.view);
//    }];
//    
//    //单色
//    CyclePath *path = [[CyclePath alloc] initWithFrame:CGRectMake(400, 100, 80, 80)];
//    path.backgroundColor = [UIColor whiteColor];
//    [self.view addSubview:path];
//    
//    //渐变色
//    GradientPath *gPath = [[GradientPath alloc] initWithFrame:CGRectMake(0, 0, 300, 600)];
//    gPath.backgroundColor = [UIColor whiteColor];
//    [self.view addSubview:gPath];
    
    //分节线条
    ClassPath *classPath = [[ClassPath alloc] initWithFrame:CGRectMake(0, 0, 300, 300)];
    [self.view addSubview:classPath];
    
}

@end

@implementation ClassPath

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat lineWidth = 20;
        CGFloat radius = MIN(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))- lineWidth/2;
        CGPoint arcCenter = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
        UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:arcCenter
                                                            radius:radius
                                                        startAngle:M_PI
                                                          endAngle:-M_PI
                                                         clockwise:NO];
        
        CAShapeLayer *cycleBackgroundLayer = [CAShapeLayer layer];
        cycleBackgroundLayer.strokeColor = [UIColor grayColor].CGColor;
        cycleBackgroundLayer.fillColor = [UIColor clearColor].CGColor;
        cycleBackgroundLayer.lineWidth = lineWidth;
        cycleBackgroundLayer.path = path.CGPath;
        [self.layer addSublayer:cycleBackgroundLayer];
    }
    return self;
}

@end


@implementation BezierPathView

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    // <-----5边形
    UIColor *color = [[UIColor redColor] colorWithAlphaComponent:.5];
    [color set]; //设置线条颜色
    
    UIBezierPath* aPath = [UIBezierPath bezierPath];
    aPath.lineWidth = 5.0;
    
    aPath.lineCapStyle = kCGLineCapRound; //线条拐角
    aPath.lineJoinStyle = kCGLineCapRound; //终点处理

    // Set the starting point of the shape.
    [aPath moveToPoint:CGPointMake(100.0, 0.0)];
    
    // Draw the lines
    [aPath addLineToPoint:CGPointMake(200.0, 40.0)];
    [aPath addLineToPoint:CGPointMake(160, 140)];
    [aPath addLineToPoint:CGPointMake(40.0, 140)];
    [aPath addLineToPoint:CGPointMake(0.0, 40.0)];
    
    [aPath closePath];//第五条线通过调用closePath方法得到的
    
    [aPath stroke];//Draws line 根据坐标点连线
    
    //<-------椭圆形
    aPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(400, 0, 200, 200)];
    aPath.lineWidth = 5.0;
    
    aPath.lineCapStyle = kCGLineCapRound; //线条拐角
    aPath.lineJoinStyle = kCGLineCapRound; //终点处理
    
    [aPath strokeWithBlendMode:kCGBlendModeScreen alpha:0.2];
    
    //<------－正方形
    aPath = [UIBezierPath bezierPathWithRect:CGRectMake(20, 240, 400, 200)];
    aPath.lineWidth = 20;
    aPath.lineCapStyle = kCGLineCapRound;
    aPath.lineJoinStyle = kCGLineJoinRound;
    [aPath fill];
    
    //<-------
    CGMutablePathRef cgPath = CGPathCreateMutable();
    CGPathAddEllipseInRect(cgPath, NULL, CGRectMake(0, 0, 300, 300));
    CGPathAddEllipseInRect(cgPath, NULL, CGRectMake(50, 50, 200, 200));
    
    // Now create the UIBezierPath object
    aPath = [UIBezierPath bezierPath];
    
    aPath.CGPath = cgPath;
    aPath.usesEvenOddFillRule = YES;
    [aPath fill];

    // After assigning it to the UIBezierPath object, you can release
    // your CGPathRef data type safely.
    CGPathRelease(cgPath);
    
    //<-------带圆角的正方形
    aPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(20, 500, 100, 100) byRoundingCorners:UIRectCornerBottomLeft|UIRectCornerBottomRight cornerRadii:CGSizeMake(20, 20)];
//    aPath.lineJoinStyle = kCGLineJoinRound;
    aPath.lineCapStyle = kCGLineCapRound;
    aPath.lineWidth = 5.0;
    [aPath fill];
    
    //<---------
    // Create an oval shape to draw.
    aPath = [UIBezierPath bezierPathWithOvalInRect:
                           CGRectMake(400, 600, 200, 100)];
    
    // Set the render colors
    [[UIColor blackColor] setStroke];
    [[UIColor redColor] setFill];
    
    //CGContextRef aRef = UIGraphicsGetCurrentContext();
    
    // If you have content to draw after the shape,
    // save the current state before changing the transform
    //CGContextSaveGState(aRef);
    
    // Adjust the view's origin temporarily. The oval is
    // now drawn relative to the new origin point.
    //CGContextTranslateCTM(aRef, 250, -50);
    
    // Adjust the drawing options as needed.
    aPath.lineWidth = 5;
    
    // Fill the path before stroking it so that the fill
    // color does not obscure the stroked line.
    [aPath fill];
    [aPath stroke];
    
    // Restore the graphics state before drawing any other content.
    //CGContextRestoreGState(aRef);
    
//    aRef = UIGraphicsGetCurrentContext();
//    CGContextClearRect(aRef, self.bounds);
    
}

@end

@implementation CyclePath

- (void)drawRect:(CGRect)rect
{
    // radius 是的起始点是arcCenter， 终点是lineWidth的一半，看看效果就一目了然了。
    // fill的区域 就是这个半径内的区域，所以lineWidth外面的一半是stroke color，lineWidth靠里的一半被fill color遮住了。
    CGFloat lineWidth = 20;
    UIBezierPath *aPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(CGRectGetWidth(self.bounds)/2, CGRectGetWidth(self.bounds)/2) radius:CGRectGetWidth(self.frame)/2 - lineWidth/2 startAngle:135*M_PI/180 endAngle:45*M_PI/180 clockwise:YES];
    aPath.lineWidth = lineWidth;
    aPath.lineCapStyle = kCGLineCapRound;
    
    [[UIColor blueColor] setStroke];
    [[[UIColor redColor] colorWithAlphaComponent:.5] setFill];
    
    [aPath stroke];
    [aPath fill];
}

@end

static CGFloat defaultLineWidth = 15;
@implementation GradientPath

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setProgress:.3];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self setProgress:.1];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self setProgress:.8];
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self setProgress:.4];
                });

            });

        });
        
      
    }
    return self;
}

- (void)setProgress:(CGFloat )progress
{    
    _progress = progress;
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = [self bezierPathWithProgress:progress arcCenter:CGPointZero].CGPath;
    shapeLayer.position = CGPointMake(CGRectGetMidX(self.frame),CGRectGetMidY(self.frame));
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.strokeColor = [UIColor purpleColor].CGColor;
    shapeLayer.lineWidth = 15;
    shapeLayer.lineCap = @"round";
    
    CABasicAnimation *drawAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    drawAnimation.duration            = 5.0; // "animate over 10 seconds or so.."
    drawAnimation.repeatCount         = 1.0;  // Animate only once..
    drawAnimation.removedOnCompletion = NO;   // Remain stroked after the animation..
    drawAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
    drawAnimation.toValue   = [NSNumber numberWithFloat:10.0f];
    drawAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    [shapeLayer addAnimation:drawAnimation forKey:@"drawCircleAnimation"];
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = self.frame;
    gradientLayer.colors = @[(__bridge id)[UIColor redColor].CGColor,(__bridge id)[UIColor greenColor].CGColor,(__bridge id)[UIColor blueColor].CGColor ];
    gradientLayer.startPoint = CGPointMake(0,0.5);
    gradientLayer.endPoint = CGPointMake(1,0.5);
    gradientLayer.mask = shapeLayer;
    
    [self.layer addSublayer:gradientLayer];
}

- (void)drawRect:(CGRect)rect
{
    UIBezierPath *path = [self bezierPathWithProgress:1 arcCenter:self.drawCenter];
    [[[UIColor grayColor] colorWithAlphaComponent:.3] setStroke];
    [path stroke];
}

#pragma mark - getter
- (CGPoint)drawCenter
{
    return CGPointMake(CGRectGetWidth(self.bounds)/2, CGRectGetWidth(self.bounds)/2);
}

- (UIBezierPath *)bezierPathWithProgress:(CGFloat)percent arcCenter:(CGPoint)ceter
{
    int radius = CGRectGetWidth(self.frame)/2 - defaultLineWidth/2 ;
    
    CGFloat angle = 270*percent+135;
    CGFloat endAngle = (angle > 360 ? angle - 360 : angle)*2*M_PI/360;
    
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:ceter radius:radius startAngle:135*M_PI/180 endAngle:endAngle clockwise:YES];
    path.lineCapStyle = kCGLineCapRound;
    path.lineWidth = defaultLineWidth;
    
    return path;
}

@end
