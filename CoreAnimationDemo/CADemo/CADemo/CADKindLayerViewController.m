//
//  CADShapeViewController.m
//  CADemo
//
//  Created by yixiaoluo on 15/11/5.
//  Copyright © 2015年 yixiaoluo. All rights reserved.
//

#import "CADKindLayerViewController.h"
#import "LayerLabel.h"
#import "CubesView.h"
#import "ScrollView.h"
#import "EmitterView.h"

#import "UIImage+Helper.h"

@interface CADKindLayerViewController ()

@property (weak, nonatomic) IBOutlet UIView *shaperView;

@property (weak, nonatomic) IBOutlet UIView *textView;
@property (weak, nonatomic) IBOutlet LayerLabel *layerLabel;

@property (weak, nonatomic) IBOutlet CubesView *transformLayerView;

@property (weak, nonatomic) IBOutlet UIView *gradientLayerView;

@property (weak, nonatomic) IBOutlet UIView *replicatorLayerView;
@property (weak, nonatomic) IBOutlet UILabel *layer1;
@property (weak, nonatomic) IBOutlet UILabel *layer2;

@property (weak, nonatomic) IBOutlet ScrollView *scrollLayerView;

@property (weak, nonatomic) IBOutlet UIScrollView *tiledScrollView;

@property (weak, nonatomic) IBOutlet EmitterView *emitterView;
@property (nonatomic) CATiledLayer *tiledLayer;

@end

@implementation CADKindLayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self addAShape];
    [self addARect];
    [self setupTextLayer];
    [self showCubes];
    [self showGradientLayer];
    [self testTransform];
    [self showReplicatiorLayer];
    
    [self showScrollLayer];
    
    //tiled layer
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"WP7M68ZV" ofType:@"jpg"];
    [UIImage divideToSmallImageFromBigImageAtPath:imagePath completion:^(NSArray<NSString *> *smallFilePaths) {
        [self showTiledLayer];
    }];
    
    [self showEmitterLayer];
}

- (void)dealloc
{
    self.tiledLayer.delegate = nil;
}

#pragma mark - CAEmitterLayer
- (void)showEmitterLayer
{
    
}

#pragma mark - CATiledLayer
- (void)showTiledLayer
{
    //代码都不执行的情况内存占用为25M
//    return;

    //内存为59M
//    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"WP7M68ZV" ofType:@"jpg"];
//    UIImage *mg = [UIImage imageWithContentsOfFile:imagePath];
//    UIImageView *imageView = [[UIImageView alloc] initWithImage:mg];
//
//    [self.tiledScrollView addSubview:imageView];
//    self.tiledScrollView.contentSize = imageView.bounds.size;
//    
    //内存为26M，我擦！神器啊。
    CATiledLayer *layer = [CATiledLayer layer];
    layer.contentsScale = [UIScreen mainScreen].scale;//高清图
    layer.frame = (CGRect){CGPointZero, CGSizeMake(4096./layer.contentsScale, 2160./layer.contentsScale)};
    layer.delegate = self;
//    layer.drawsAsynchronously = YES;
    
    [self.tiledScrollView.layer addSublayer:layer];
    
#warning 添加支持缩放
    self.tiledScrollView.contentSize = layer.frame.size;
    
    self.tiledLayer = layer;
    
    [layer setNeedsDisplay];
}

- (void)drawLayer:(CATiledLayer *)layer inContext:(CGContextRef)ctx;
{
    //determin tile coordinate
    CGRect bounds = CGContextGetClipBoundingBox(ctx);
    CGFloat scale = [[UIScreen mainScreen] scale];
    NSInteger x = floor(bounds.origin.x/layer.tileSize.width*scale);
    NSInteger y = floor(bounds.origin.y/layer.tileSize.height*scale);
    
    //load image
    NSString *imageName = [NSString stringWithFormat:@"_%02li_%02li.jpg", (long)x, (long)y];
    NSString *imagePath = [CAD_DocumentOfSmallImage() stringByAppendingString:imageName];
    UIImage *image = [[UIImage alloc] initWithData:[NSData dataWithContentsOfFile:imagePath]];
    
    //draw tile
    UIGraphicsPushContext(ctx);
    [image drawInRect:bounds];
    UIGraphicsPopContext();
}


#pragma mark - CAScrollLayer
- (void)showScrollLayer
{
    CALayer *imageLayer = [CALayer layer];
    UIImage *img = [UIImage imageNamed:@"9d2cbeb8gw1exuu672uqgj20dw0kujte"];
    imageLayer.frame = (CGRect){CGPointZero, img.size};
    [self.scrollLayerView.layer addSublayer:imageLayer];
    
    imageLayer.contents = (__bridge id)img.CGImage;
    imageLayer.contentsScale = [UIScreen mainScreen].scale;
    imageLayer.contentsGravity = kCAGravityResizeAspectFill;
}

#pragma mark - CAReplicatorLayer
- (void)testTransform
{
    //layer的相对坐标系是不变的！！！坐标系会跟着layer旋转而发生旋转！！！
    self.layer1.layer.backgroundColor = [UIColor purpleColor].CGColor;
    self.layer1.layer.transform = ({
        CATransform3D rer = CATransform3DIdentity;
        rer = CATransform3DRotate(rer, -M_PI/2, 0, 0, 1);
        rer = CATransform3DTranslate(rer, 0, -20, 0);
        rer;
    });
    
    self.layer2.layer.backgroundColor = [UIColor blueColor].CGColor;
    self.layer2.layer.transform = ({
        CATransform3D rer = CATransform3DIdentity;
        rer = CATransform3DTranslate(rer, 0, -20, 0);
        rer = CATransform3DRotate(rer, -M_PI/2, 0, 0, 1);
        rer;
    });
}

- (void)showReplicatiorLayer
{
    //旋转的视图
    CAReplicatorLayer *replicator = [CAReplicatorLayer layer];
    replicator.frame = self.replicatorLayerView.bounds;

    CALayer *copyImagelayer = [CALayer layer];
    copyImagelayer.frame = CGRectMake(0, self.replicatorLayerView.frame.size.height-30, 30, 30);
    copyImagelayer.contents = (__bridge id)[UIImage imageNamed:@"copy"].CGImage;
    copyImagelayer.contentsScale = [UIScreen mainScreen].scale;
    copyImagelayer.contentsGravity = kCAGravityResizeAspect;
    
    replicator.instanceCount = 6;
    replicator.instanceGreenOffset = 0.1;
    replicator.instanceTransform = ({
        CATransform3D rer = CATransform3DIdentity;
        rer = CATransform3DTranslate(rer, 0, 0, 0);
        rer= CATransform3DTranslate(rer, 14, 0, 0);
        rer = CATransform3DRotate(rer, M_PI*21/180, 0, 0, 1);
        rer;
    });
    
    [replicator addSublayer:copyImagelayer];
    
    [self.replicatorLayerView.layer addSublayer:replicator];
    
    //倒影
    replicator = [CAReplicatorLayer layer];
    replicator.frame = self.replicatorLayerView.bounds;
    copyImagelayer = [CALayer layer];
    copyImagelayer.frame = CGRectMake(0, 0, 50, 50);
    copyImagelayer.position = CGPointMake(self.replicatorLayerView.frame.size.width/2, self.replicatorLayerView.frame.size.height/2);
    copyImagelayer.contents = (__bridge id)[UIImage imageNamed:@"copy"].CGImage;
    copyImagelayer.contentsScale = [UIScreen mainScreen].scale;
    copyImagelayer.contentsGravity = kCAGravityResizeAspect;
    
    replicator.instanceCount = 2;
    replicator.instanceAlphaOffset = -0.8;
    replicator.instanceTransform = ({
        CATransform3D rer = CATransform3DIdentity;
        rer = CATransform3DRotate(rer, M_PI, 0, 0, 1);
        rer = CATransform3DRotate(rer, M_PI, 0, 1, 0);
        rer = CATransform3DTranslate(rer, 0, -copyImagelayer.frame.size.height, 0);
        rer;
    });
    
    [replicator addSublayer:copyImagelayer];
    
    [self.replicatorLayerView.layer addSublayer:replicator];
}

#pragma mark - CAGradientLayer
- (void)showGradientLayer
{
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = self.gradientLayerView.bounds;
    
    gradient.startPoint = CGPointMake(0, 0);
    gradient.endPoint = CGPointMake(1, 1);
    
    gradient.colors = @[(__bridge id)[UIColor redColor].CGColor, (__bridge id)[UIColor yellowColor].CGColor, (__bridge id)[UIColor blackColor].CGColor];
    gradient.locations = @[@0.1, @0.3, @0.2, @0.3];//少于colors个数，将会认为后面的color在界面外；多于colors个数，是个很神奇的效果。
    
    [self.gradientLayerView.layer addSublayer:gradient];
}


#pragma mark - CATransformLayer
- (void)showCubes
{
    self.transformLayerView.layer.sublayerTransform = ({
        CATransform3D t = CATransform3DIdentity;
        t.m34 = -1/500.0;
        t;
    });    
}

#pragma mark - CATextLayer
- (void)setupTextLayer
{
    self.layerLabel.font = [UIFont italicSystemFontOfSize:88];
    self.layerLabel.backgroundColor = [UIColor blackColor];
    self.layerLabel.textColor = [UIColor whiteColor];
    self.layerLabel.text = @"[path addArcWithCenter:CGPointMake(50, 25) radius:20 startAngle:0 endAngle:M_PI*2 clockwise:YES];";
}


#pragma mark - CAShapeLayer
- (void)addAShape
{
    //header
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path addArcWithCenter:CGPointMake(50, 25) radius:20 startAngle:0 endAngle:M_PI*2 clockwise:YES];
    
    //gebo
    [path moveToPoint:CGPointMake(5, 70)];
    [path addLineToPoint:CGPointMake(100, 70)];

    //neck & duzi
    [path moveToPoint:CGPointMake(50, 45)];
    [path addLineToPoint:CGPointMake(50, 95)];
    
    //leg
    [path addLineToPoint:CGPointMake(15, 130)];
    [path moveToPoint:CGPointMake(50, 95)];
    [path addLineToPoint:CGPointMake(85, 130)];
    
    CAShapeLayer *shape = [CAShapeLayer layer];
    shape.path = path.CGPath;
    shape.lineWidth = 10;
    shape.strokeColor = [UIColor whiteColor].CGColor;
    shape.lineCap = kCALineCapRound;
    shape.lineJoin = kCALineJoinRound;
    [self.shaperView.layer addSublayer:shape];
}


- (void)addARect
{
    //http://stackoverflow.com/questions/18880919/why-is-cornerradii-parameter-of-cgsize-type-in-uibezierpath-bezierpathwithroun
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, 110, 140) byRoundingCorners:UIRectCornerBottomLeft|UIRectCornerBottomRight cornerRadii:CGSizeMake(20, 2)];
    CAShapeLayer *shape = [CAShapeLayer layer];
    shape.path = path.CGPath;
    shape.strokeColor = [UIColor redColor].CGColor;
    shape.fillColor = [UIColor clearColor].CGColor;
    [self.shaperView.layer addSublayer:shape];
}

@end
