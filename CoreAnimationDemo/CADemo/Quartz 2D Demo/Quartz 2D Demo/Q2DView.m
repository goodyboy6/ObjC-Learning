//
//  Q2DView.m
//  Quartz 2D Demo
//
//  Created by yixiaoluo on 15/11/23.
//  Copyright © 2015年 yixiaoluo. All rights reserved.
//

#import "Q2DView.h"

//描边:stroke
//填充:fill
@implementation Q2DView{
    CGMutablePathRef _pathRef;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    [self demo70AtRect:rect];
}

#pragma mark - CGLayer层绘制
- (void)demo18AtRect:(CGRect)rect
{
    CGContextRef context =  UIGraphicsGetCurrentContext();

    UIImage *image = [UIImage imageNamed:@"iconfont-feiji"];
    
    //创建layer
    CGLayerRef layerRef = CGLayerCreateWithContext(context, rect.size, NULL);
    //获取layer所在的context，并在这个context上绘制，所有在layer context上的绘制都将会作为layer的内容被缓存
    CGContextRef layerContextRef = CGLayerGetContext(layerRef);
    CGContextDrawImage(layerContextRef, (CGRect){.size = image.size}, image.CGImage);
    
    CGContextSaveGState(context);
    //将layer描绘到当前context上
    //由于layer被缓存，所以多次重绘layer不会有性能问题
    for (int i=0; i<100; i++) {
        CGContextTranslateCTM(context, i*2, i*3);
        CGContextDrawLayerAtPoint(context, rect.origin, layerRef);
    }
    CGContextRestoreGState(context);
    
    //释放内存
    CGLayerRelease(layerRef);
}

#pragma mark - 数据管理
#pragma mark - 位图与图像遮罩
//http://baike.baidu.com/item/Bitmap
//http://www.infoq.com/cn/articles/the-secret-of-bitmap
//http://zengzhaozheng.blog.51cto.com/8219051/1404108 bitmap应用

//http://blog.csdn.net/dick_china/article/details/7921302

//使用图像遮罩／颜色遮罩作为遮罩，遮罩将覆盖在图像上面
- (void)demo17AtRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();

    //demo image
    UIImage *image = [UIImage imageNamed:@"005vbOHfgw1extuefy849j30zk0pljvr"];
    
    //颜色遮罩
//    const CGFloat components[] = {124, 255,  68, 222, 0, 165};
//    CGImageRef imageRef = CGImageCreateWithMaskingColors(image.CGImage, components);
    
    //位图遮罩
    CGImageRef maskImageRef = [UIImage imageNamed:@"iconfont-feiji"].CGImage;
    CGImageRef mask = CGImageMaskCreate(CGImageGetWidth(maskImageRef),
                                        CGImageGetHeight(maskImageRef),
                                        CGImageGetBitsPerComponent(maskImageRef),
                                        CGImageGetBitsPerPixel(maskImageRef),
                                        CGImageGetBytesPerRow(maskImageRef),
                                        CGImageGetDataProvider(maskImageRef),
                                        CGImageGetDecode(maskImageRef),
                                        false);
    CGImageRef imageRef = CGImageCreateWithMask(image.CGImage, mask);//mask必须通过CGImageMaskCreate来创建

    //画图
    CGContextTranslateCTM(context, 0, rect.size.height);
    CGContextScaleCTM(context, 1, -1);
    CGContextDrawImage(context, rect, imageRef);//mask必须通过CGImageMaskCreate来创建
    
    //释放内存
    CGImageRelease(mask);
    CGImageRelease(imageRef);
}

//使用图像作为遮罩 等价于 [CALayer layer].mask， 只保留mask形状
- (void)demo172AtRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    UIImage *maskImage = [UIImage imageNamed:@"iconfont-feiji"];
    CGContextClipToMask(context, (CGRect){.size = maskImage.size}, maskImage.CGImage);
    
    UIImage *originImage = [UIImage imageNamed:@"005vbOHfgw1extuefy849j30zk0pljvr"];
    CGContextDrawImage(context, rect, originImage.CGImage);//mask必须通过CGImageMaskCreate来创建
}

//创建图像数据源
- (void)demo171AtRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();

    //位图的创建一.
    CFURLRef urlRef = CFBundleCopyResourceURL(CFBundleGetMainBundle(), CFStringCreateWithCString(NULL, "005vbOHfgw1extuefy849j30zk0pljvr", kCFStringEncodingUTF8), (CFStringRef)@"png", NULL);
    CGDataProviderRef dataProviderRef = CGDataProviderCreateWithURL(urlRef);//本地文件路径，不是网络地址
    
    //位图的创建二.
//    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"005vbOHfgw1extuefy849j30zk0pljvr" ofType:@"png"];
//    CGDataProviderRef dataProviderRef = CGDataProviderCreateWithFilename([filePath UTF8String]);//本地文件路径，不是文件名
    
    CGImageRef imageRef = CGImageCreateWithPNGDataProvider(dataProviderRef, NULL, false, kCGRenderingIntentDefault);
    
    CGContextTranslateCTM(context, 0, rect.size.height);
    CGContextScaleCTM(context, 1, -1);
    CGContextDrawImage(context, rect, imageRef);
    
    //释放内存
    CFRelease(urlRef);
    CGDataProviderRelease(dataProviderRef);
    CGImageRelease(imageRef);
}

//创建图像方式
- (void)demo170AtRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();

    //从一个存在的图像中创建一个子图像
//    UIImage *originImage = [UIImage imageNamed:@"005vbOHfgw1extuefy849j30zk0pljvr"];
//    CGImageRef subImageRef = CGImageCreateWithImageInRect(originImage.CGImage, CGRectMake(200, 200, 200, 200));
    
    //从一个图形上下文中创建一个图像
    CGContextBeginPath(context);
    CGContextAddEllipseInRect(context, CGRectMake(0, 0, 100, 100));
    CGContextSetRGBFillColor(context, 1, 0, 0, 1);
    CGContextSetStrokeColorWithColor(context, [UIColor blueColor].CGColor);
    CGContextSetLineWidth(context, 5);
    CGContextDrawPath(context, kCGPathEOFillStroke);
    
    CGImageRef subImageRef = CGBitmapContextCreateImage(context);
    
    CGContextTranslateCTM(context, 0, rect.size.height);
    CGContextScaleCTM(context, 1, -1);
    CGContextDrawImage(context, rect, subImageRef);
}

#pragma mark - 透明层
- (void)demo16AtRect:(CGRect)rect
{
    CGContextRef context =  UIGraphicsGetCurrentContext();
    
    CGContextSetShadow(context, CGSizeMake(10, 20), .5);

    CGContextBeginTransparencyLayer(context, NULL);
    
    CGContextSetRGBFillColor(context, 0, 1, 0, 1);
    CGContextFillEllipseInRect(context, CGRectMake(50, 0, 100, 100));

    CGContextSetRGBFillColor(context, 0, 0, 1, 1);
    CGContextFillEllipseInRect(context, CGRectMake(0, 50, 100, 100));
    
    CGContextSetRGBFillColor(context, 1, 0, 0, 1);
    CGContextFillEllipseInRect(context, CGRectMake(0, 0, 100, 100));

    CGContextEndTransparencyLayer(context);
}

#pragma mark - 渐变
- (void)demo15AtRect:(CGRect)rect
{
    CGContextRef context =  UIGraphicsGetCurrentContext();
    
    //创建一个渐变: CGShadingRef
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    CGFunctionCallbacks functionCallback = {0, &MyFunctionEvaluateCallback, &MyFunctionReleaseInfoCallback};//与CGPatternCallbacks类似
    CGFloat domain[] = {0.3, 0.9};//起终点
    CGFloat range[] = {0,1,0,1,//起点对应的颜色
                       1,0,0,1};//终点对应的颜色
    
    CGFunctionRef functionRef = CGFunctionCreate((void *)3,
                                                 1/*为domain中的一项，将作为参数传入回调函数*/, domain,
                                                 3/*r,g,b四个值，或者通过CGColorSpaceGetNumberOfComponents(colorSpaceRef)计算*/, range,
                                                 &functionCallback);
    //    径向渐变
//    CGShadingRef shadingRef = CGShadingCreateAxial(colorSpaceRef,
//                                                   CGPointMake(20, 20),
//                                                   CGPointMake(rect.size.width-20, rect.size.height-20),
//                                                   functionRef,
//                                                   false, false);
    //    轴向渐变
    CGShadingRef shadingRef = CGShadingCreateRadial(colorSpaceRef, CGPointMake(20, 20), 10, CGPointMake(rect.size.width-40, rect.size.height-40), 30, functionRef, false, false);
    
    //如果需要裁剪必须在描画前裁剪....
//    CGContextClipToRect(context, CGRectMake(100, 100, 50, 50));
    
    //描画渐变
    CGContextDrawShading(context, shadingRef);

    //释放内存
    CGColorSpaceRelease(colorSpaceRef);
    CGFunctionRelease(functionRef);
    CGShadingRelease(shadingRef);
    
    //CGGradientRef为CGShadingRef的子集，更为简单
    //创建一个渐变: CGGradientRef
    //    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    //    CGFloat locations[] = {0.3, 0.6};
    //    CGFloat components[] = {1,0,0,1,//红色对应0.3这个点
    //                            0,1,0,1//绿色对应1.0这个点
    //                            };
    //
    //    CGGradientRef gradientRef = CGGradientCreateWithColorComponents(colorSpaceRef, components, locations, sizeof(locations)/sizeof(locations[0]));
    ////    径向渐变
    //    CGContextDrawLinearGradient(context,
    //                                gradientRef,
    //                                CGPointZero,
    //                                CGPointMake(rect.size.width, rect.size.height),
    //                                kCGGradientDrawsBeforeStartLocation);
    ////    轴向渐变
    //    CGContextDrawRadialGradient(context,
    //                                gradientRef,
    //                                CGPointMake(20, 20),
    //                                10,
    //                                CGPointMake(rect.size.width - 40, rect.size.height-40),
    //                                30,
    //                                kCGGradientDrawsAfterEndLocation);
    //    //释放内存
    //    CGColorSpaceRelease(colorSpaceRef);
    //    CGGradientRelease(gradientRef);
}

void MyFunctionEvaluateCallback(void * __nullable info, const CGFloat *  in, CGFloat *  out)
{
    //in为位置信息，介于{0.3, 0.9}
    //out为需要提供的颜色信息，?颜色信息介于起终点颜色{1,0,0,1,0,1,0,1}？
    //提供rgb，alpha默认为1
    
    double frequency[4] = { 55, 220, 110, 0 };
    size_t components = (size_t)info;
    
    for (size_t k = 0; k < components - 1; k++)
        *out++ = (1 + sin(*in * frequency[k]))/2;
    *out++ = 0.5;//alpha值
}

void MyFunctionReleaseInfoCallback(void * __nullable info)
{
    
}

#pragma mark - 阴影
- (void)demo14AtRect:(CGRect)rect
{
    CGContextRef context =  UIGraphicsGetCurrentContext();
    
    CGContextSaveGState(context);
    
    //将对所有即将描画的图形生效
    CGContextSetShadowWithColor(context, CGSizeMake(5, 10), 0.1, [UIColor redColor].CGColor);
    //    CGContextSetShadow(context, CGSizeMake(5, 10), .1);
    CGContextSetRGBFillColor(context, 0, 1, 0, 1);
    CGContextFillRect(context, CGRectMake(0, 0, 100, 100));
    
    CGContextRestoreGState(context);
}

#pragma mark - 模式pattern
//类似[UIColor colorWithPatternImage:[UIColor redColor]]
static CGFloat kCellSize = 30;
static CGFloat kRealPadding = 5;
- (void)demo13AtRect:(CGRect)rect
{
    CGContextRef context =  UIGraphicsGetCurrentContext();
    
    //创建模式单元格
    CGPatternCallbacks callback = {0, &MyPatternDrawPatternCallback, &MyPatternReleaseInfoCallback};;
    CGPatternRef patternRef = CGPatternCreate(NULL,//回调函数中的info参数
                                              CGRectMake(0, 0, kCellSize, kCellSize),//cell大小
                                              CGAffineTransformScale(CGAffineTransformTranslate(CGAffineTransformIdentity, 0, -kCellSize), 1, -1),//CGAffineTransformIdentity表示回调的context和当前的context的坐标系相同
                                              kCellSize+kRealPadding, kCellSize+kRealPadding,//cell之间水平和垂直间距，这个距离包括了cell的大小，所以这个值一般都是大于等于cell的大小
                                              kCGPatternTilingConstantSpacing,//平铺，速度最快
                                              true,//与颜色无关可以理解为模版模式（如回调中的图片）；相关可以理解为着色模式（如回调中的三角形）
                                              &callback);
    
    //填充模式颜色空间，否则回调不走，其实就是设置回调中的颜色空间，不管回调中是fill或者是stroke，这样在回调中就不需要设置context颜色了
    CGColorSpaceRef baseColorSpaceRef = CGColorSpaceCreateWithName(kCGColorSpaceGenericRGB);//CGColorSpaceCreateDeviceRGB();
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreatePattern(baseColorSpaceRef);
    CGContextSetFillColorSpace(context, colorSpaceRef);
    
    CGFloat color[] = {1,1,0,0.8};//RGBa
    CGContextSetFillPattern(context, patternRef, color);//使用这个方法之前，需要填充模式颜色空间，第三个参数就是对应颜色空间的参数
    CGContextFillRect(context, rect);
    
    //释放内存
    CGColorSpaceRelease(baseColorSpaceRef);
    CGColorSpaceRelease(colorSpaceRef);
    CGPatternRelease(patternRef);
}

void MyPatternDrawPatternCallback(void * __nullable info,  CGContextRef __nullable context){
    
    //    CGContextBeginPath(context);
    //
    //    //在单元格里画一个向上的三角形
    //    CGPoint points[] = {CGPointMake(kCellSize/2, 0),CGPointMake(0, kCellSize), CGPointMake(kCellSize, kCellSize),CGPointMake(kCellSize/2, 0)};
    //    CGContextAddLines(context, points, sizeof(points)/sizeof(points[0]));
    //
    //    CGContextFillPath(context);
    
    //测试：画一个图片会怎么样
    //通过参数CGPatternCreate中的CGAffineTransform参数旋转CTM，上面的三角形（不是画图或者字）直接设置为CGAffineTransformIdentity就ok了
    CGContextDrawImage(context, CGRectMake(0, 0, 30, 30), [UIImage imageNamed:@"iconfont-feiji"].CGImage);
}

void MyPatternReleaseInfoCallback(void * __nullable info)
{
    //CGPatternRelease释放pattern之后调用，比如可以释放MyPatternDrawPatternCallback回调中可能持有的全局变量
}

#pragma mark - 图像上下文状态保存
//http://wsqwsq000.iteye.com/blog/1316277  http://blog.csdn.net/lihangqw/article/details/9969961
//使用Quartz时涉及到一个图形上下文，其中图形上下文中包含一个保存过的图形状态堆栈。在Quartz创建图形上下文时，该堆栈是空的。CGContextSaveGState函数的作用是将当前图形状态推入堆栈。之后，您对图形状态所做的修改会影响随后的描画操作，但不影响存储在堆栈中的拷贝。在修改完成后，您可以通过CGContextRestoreGState函数把堆栈顶部的状态弹出，返回到之前的图形状态。这种推入和弹出的方式是回到之前图形状态的快速方法，避免逐个撤消所有的状态修改；这也是将某些状态（比如裁剪路径）恢复到原有设置的唯一方式。
- (void)demo12AtRect:(CGRect)rect
{
    CGContextRef context =  UIGraphicsGetCurrentContext();
    
    //创建背景，这时背景是倒的
    CGContextDrawImage(context, rect, [UIImage imageNamed:@"005vbOHfgw1extuefy849j30zk0pljvr"].CGImage);
    
    //保存绘制状态
    CGContextSaveGState(context);//将当前状态压入context维护的状态栈中，后续对当前context的修改将不会影响到堆栈
    CGContextSetBlendMode(context, kCGBlendModeScreen);//继续使用当前的context进行设置，但只对当前有效
    for(NSInteger i=0; i<10; i++){//创建多个view
        CGContextSetRGBFillColor(context, 0, 0.1*i, 0, 1);
        CGContextFillRect(context, CGRectMake(0, i*rect.size.height/10, rect.size.width, rect.size.height/10));
    }
    CGContextRestoreGState(context);//将栈顶状态出栈，context将恢复到出栈的状态。
}


#pragma mark - 坐标系转换
- (void)demo11AtRect:(CGRect)rect
{
    //CGContextRotateCTM(CGContextRef c, CGFloat angle)方法可以相对原点旋转上下文坐标系
    //CGContextTranslateCTM(CGContextRef c, CGFloat tx, CGFloat ty)方法可以相对原点平移上下文坐标系
    //CGContextScaleCTM(CGContextRef c, CGFloat sx, CGFloat sy)方法可以缩放上下文坐标系
    //转换坐标系前，使用CGContextSaveGState(CGContextRef c)保存当前上下文状态
    //坐标系转换后，使用CGContextRestoreGState(CGContextRef c)可以恢复之前保存的上下文状态
    CGContextRef context =  UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);//将当前状态压入context维护的状态栈中，后续对当前context的修改将不会影响到堆栈
    
    //http://stackoverflow.com/questions/506622/cgcontextdrawimage-draws-image-upside-down-when-passed-uiimage-cgimage
    //坐标系转换,调用CGContextDrawImage画的图是倒的；但使用［UIImage drawRect：］方法不需要转换矩阵，系统已经帮我们转换过了
    //目前只是图片和文字需要转换坐标系
    //方法1:
    //    CGContextTranslateCTM(context, 0, rect.size.height);
    //    CGContextScaleCTM(context, 1, -1);
    //方法2:
    CGAffineTransform t = CGAffineTransformIdentity;
    t = CGAffineTransformTranslate(t, 0,  rect.size.height);
    t = CGAffineTransformScale(t, 1, -1);
    CGContextConcatCTM(context, t);
    
    //空间转换：其实是像素点（设备像素）和cocoa点（用户空间单元）之前的转换 http://comments.gmane.org/gmane.comp.lib.sdl/57042
    //使用场景如在需要裁剪图片时，在不同的分辨率下，不再需要先获取屏幕的scale，然后用rect的每个值去计算出一个新的rect，只需要转换成设备空间就好了。我们在代码中用的点的概念就是cocoa点。
    //CGContextConvertPointToDeviceSpace和CGContextConvertSizeToDeviceSpace逻辑同上。
    //当前为用户空间：{300, 300}，转换为设备空间时，若设备为retina屏幕时，为｛600,600｝.
    CGRect f = CGContextConvertRectToDeviceSpace(context, rect);
    //当前为设备空间：｛600， 600｝，转换为用户空间时，若设备为retina屏幕时，为｛300. 300｝
    __unused CGRect f2 = CGContextConvertRectToUserSpace(context, f);
    
    CGContextDrawImage(context, rect, [UIImage imageNamed:@"005vbOHfgw1extuefy849j30zk0pljvr"].CGImage);
    
    CGContextRestoreGState(context);//将栈顶状态出栈，context将恢复到出栈的状态。
}

#pragma mark - alpha
- (void)demo110AtRect:(CGRect)rect
{
    CGContextRef context =  UIGraphicsGetCurrentContext();
    CGContextSetAlpha(context, 0.5);
    CGContextDrawImage(context, rect, [UIImage imageNamed:@"005vbOHfgw1extuefy849j30zk0pljvr"].CGImage);
    
    CGContextClearRect(context, CGRectMake(100, 100, 50, 50));
}


#pragma mark - 设置混合模式:blend mode
//http://sipdar.github.io/2014/03/18/Blend_Models/
//我们在使用Quartz 2D画图的时候，经常遇到图形叠加的情况。在多个图形重叠的时候有时候我们想重叠的部分透明阿，或者重叠的部分颜色混合在一起阿。这时候就要用到 Quartz 2D 的混合模式了 Blend Modes。通过 Blend Modes 我们可以把几个图片组合起来绘制到已经有图形的 graphic context上。
- (void)demo10AtRect:(CGRect)rect
{
    CGContextRef context =  UIGraphicsGetCurrentContext();
    
    //创建背景，这时背景是倒的
    CGContextDrawImage(context, rect, [UIImage imageNamed:@"005vbOHfgw1extuefy849j30zk0pljvr"].CGImage);
    
    CGContextSetBlendMode(context, kCGBlendModeScreen);
    
    //创建多个view
    for(NSInteger i=0; i<10; i++){
        CGContextSetRGBFillColor(context, 0, 0.1*i, 0, 1);
        CGContextFillRect(context, CGRectMake(0, i*rect.size.height/10, rect.size.width, rect.size.height/10));
    }
}

#pragma mark - 颜色空间
- (void)demo9AtRect:(CGRect)rect
{
    CGContextRef context =  UIGraphicsGetCurrentContext();
    
    //颜色的创建
    //    CGFloat rgb[] = {0,1,0,1};
    //    CGColorRef colorRef =  CGColorCreate(CGColorSpaceCreateDeviceRGB(), rgb);//如果第一个参数提供的是rgb，后面的数组就是rgba组成的数组；其他的如CGColorSpaceCreateDeviceCMYK类似，第二个参数根据第一个参数的需要进行设置。一般涉及到颜色的重用时会创建colorRef；否则直接使用CGContextSetRGBStrokeColor就好了。
    //    CGContextSetStrokeColorWithColor(context, colorRef);
    //    CGColorSpaceRelease(colorSpaceRef);
    
    //CGContextSetStrokeColor的使用前提必须是之前设置了color space，同上，CGContextSetStrokeColor的第二个参数根据color space的类型进行设置
    //    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    //    CGContextSetStrokeColorSpace(ref, colorSpaceRef);
    //    CGContextSetStrokeColor(ref, rgb);
    //    CGColorSpaceRelease(colorSpaceRef);
    
    //意图http://iphonedevsdk.com/forum/iphone-sdk-development/110349-quartz2d-rendering-intent-what.html
    CGContextSetRenderingIntent(context, kCGRenderingIntentSaturation);
    [[UIImage imageNamed:@"005vbOHfgw1extuefy849j30zk0pljvr"] drawInRect:rect];
    [[UIImage imageNamed:@"iconfont-feiji"] drawInRect:rect];
    
    //描画
    //    CGContextAddEllipseInRect(context, CGRectMake(100, 100, 50, 50));
    //    CGContextStrokePath(context);
}

#pragma mark - 绘制路径：填充规则
- (void)demo8AtRect:(CGRect)rect
{
    CGContextRef context =  UIGraphicsGetCurrentContext();
    
    CGContextBeginPath(context);
    
    CGContextAddEllipseInRect(context, CGRectMake(100, 100, 50, 50));
    CGContextAddEllipseInRect(context, CGRectMake(50, 50, 200, 200));
    
    CGContextSetRGBFillColor(context, 1, 0, 0, 1);
    
    //    CGContextEOFillPath(ref);//奇偶规则：从描绘点往边界画直线，奇数交叉点描画，偶数不描画。
    //    CGContextFillPath(ref);//默认为非零缠绕规则, 同上，从描绘点往边界画直线，每个交叉点，顺时针加1，逆时针减1，因为CGContextAddEllipseInRect为（默认）顺时针，计算结果不为0，所以大小圆被填充了颜色
    CGContextDrawPath(context, kCGPathEOFillStroke);//fill并且stroke
}


#pragma mark - 创建路径: 可创建多种path然后添加到CGContextRef
/*一一对应
 1. CGPathCreateMutable   CGContextBeginPath
 2. CGPathMoveToPoint   CGContextMoveToPoint
 3. CGPathAddLineToPoint   CGContexAddLineToPoint
 4. CGPathAddCurveToPoint   CGContexAddCurveToPoint
 5. CGPathAddEllipseInRect   CGContexAddEllipseInRect
 6. CGPathAddArc   CGContexAddArc
 7. CGPathAddRect   CGContexAddRect
 8. CGPathCloseSubpath   CGContexClosePath
 */
- (void)demo7AtRect:(CGRect)rect
{
    CGContextRef context =  UIGraphicsGetCurrentContext();
    
    if (_pathRef == NULL) {
        _pathRef = CGPathCreateMutable();
    }
    
    CGContextBeginPath(context);
    
    CGPathMoveToPoint(_pathRef, nil, 0, 0);
    CGAffineTransform af[] = {CGAffineTransformMakeRotation(M_PI_4)};//对线⬅️旋转操作
    CGPathAddLineToPoint(_pathRef, af, 100, 100);
    
    CGContextAddPath(context, _pathRef);
    CGContextStrokePath(context);
}

//虚线
- (void)demo70AtRect:(CGRect)rect
{
    CGContextRef context =  UIGraphicsGetCurrentContext();
    
    UIBezierPath *beizerPath = [UIBezierPath bezierPath];
    [beizerPath moveToPoint:CGPointMake(0, self.frame.size.height/2)];
    [beizerPath addLineToPoint:CGPointMake(self.frame.size.width, self.frame.size.height/2)];
    [beizerPath setLineWidth:10];
    
    CGFloat length[] = {30, 5};//这是一个循环：30线5间隔80线30间隔5线80间隔30线5间隔..........其他个数依次类推
    //phase:画线从哪里开始画？从phase开始，0<=phase<=35(因为是循环，超过35也会回到类似这个区域)，phase为15，则相当于将画的线左移15，效果就是开始是15线5间隔30线5间隔.....
    //可以对phase做动画from 0 to 35，效果就是虚线不断往起始点缩进：见DetailViewController里面的例子
    CGPathRef pathRef = CGPathCreateCopyByDashingPath(beizerPath.CGPath, nil, 30, length, 2);
    CGContextAddPath(context, pathRef);
    
    CGContextSetRGBStrokeColor(context, 1, 0, 0, 1);
    CGContextStrokePath(context);
}


#pragma mark - 椭圆、圆形
- (void)demo6AtRect:(CGRect)rect
{
    CGContextRef context =  UIGraphicsGetCurrentContext();
    
    CGContextBeginPath(context);
    
    //矩形
    CGContextAddRect(context, rect);
    //    bool tt = CGContextIsPathEmpty(ref);
    
    //椭圆
    CGContextAddEllipseInRect(context, rect);
    
    //多个矩形
    CGRect rects[] = {CGRectMake(0, 0, 100, 100), CGRectMake(50, 50, 100, 100),CGRectMake(100, 100, 100, 100),CGRectMake(150, 150, 100, 100), CGRectMake(200, 200, 100, 100)};
    CGContextAddRects(context, rects, sizeof(rects)/sizeof(rects[0]));
    
    CGContextStrokePath(context);
}

#pragma mark - 闭合路径 CGContextClosePath
- (void)demo5AtRect:(CGRect)rect
{
    CGContextRef context =  UIGraphicsGetCurrentContext();
    
    CGContextBeginPath(context);
    
    CGContextMoveToPoint(context, 0, 100);
    CGContextAddLineToPoint(context, 50, 0);
    CGContextAddLineToPoint(context, 200, 100);
    CGContextClosePath(context);
    CGContextStrokePath(context);
    
    //CGContextClosePath之后继续添加line，会提示：<Error>: CGContextAddLineToPoint: no current point.
    //换句话就是上面画线的上下文结束了，要重新开始端点的确定
    CGContextAddLineToPoint(context, 100, 200);
    CGContextStrokePath(context);
    
    
    //    CGContextMoveToPoint(context, 15, 0);
    //    CGContextAddLineToPoint(context, 0, 30);
    //    CGContextAddLineToPoint(context, 30, 30);
    //    CGContextClosePath(context);
    //等价于：
    CGPoint points[] = {CGPointMake(15, 0),CGPointMake(0, 30), CGPointMake(30, 30),CGPointMake(15, 0)};
    CGContextAddLines(context, points, sizeof(points)/sizeof(points[0]));
    
    
}

#pragma mark - 曲线总结：起始点＋函数中提供的点，确定切线，切线为矢量，通过方向确定曲线的凸凹
//http://www.mobibrw.com/?p=12
#pragma mark - 3次bezier曲线：断点＋2个控制点 ：CGContextAddCurveToPoint
- (void)demo4AtRect:(CGRect)rect
{
    CGContextRef context =  UIGraphicsGetCurrentContext();
    
    CGContextBeginPath(context);
    
    //首先CGContextMoveToPoint（context,x,y）移动到点（x,y）,然后CGContextAddCurveToPoint(context,  x1, y1, x2, y2, x3, y3)；这个方法是画弧线的，(x,y)和(x1,y1)构成切线1,(x2,y2)和(x3,y3)构成切线2
    //一条曲线
    
    //曲线
    CGContextMoveToPoint(context, 0, 100);
    CGContextAddCurveToPoint(context, 50, 50, 100, 150, 200, 100);
    CGContextSetRGBStrokeColor(context, 1, 0, 0, .9);
    CGContextStrokePath(context);
    
    //切线
    CGContextSetRGBStrokeColor(context, 0, 1, 0, .9);
    CGContextMoveToPoint(context, 0, 100);
    CGContextAddLineToPoint(context, 50, 50);
    CGContextStrokePath(context);
    
    //    CGContextMoveToPoint(ref, 50, 50);
    //    CGContextAddLineToPoint(ref, 100, 150);
    //    CGContextStrokePath(ref);
    
    CGContextMoveToPoint(context, 100, 150);
    CGContextAddLineToPoint(context, 200, 100);
    CGContextStrokePath(context);
}

#pragma mark - 2次bezier曲线：断点＋1个控制点 CGContextAddQuadCurveToPoint
- (void)demo3AtRect:(CGRect)rect
{
    CGContextRef context =  UIGraphicsGetCurrentContext();
    
    CGContextBeginPath(context);
    
    //亮点之间的曲线，和弧线（CGContextAddArcToPoint）相似，但不是圆形的部分
    //首先CGContextMoveToPoint（context,x,y）移动到点（x,y）,然后CGContextAddQuadCurveToPoint(context,  x1, y1, x2, y2)；这个方法是画弧线的，(x,y)和(x1,y1)构成切线1,(x1,y1)和(x2,y2)构成切线2
    CGContextMoveToPoint(context, 0, 100);
    CGContextAddQuadCurveToPoint(context, 40, 50, 200, 100);
    CGContextSetRGBStrokeColor(context, 1, 0, 0, .9);
    CGContextStrokePath(context);
    
    //切线
    CGContextSetRGBStrokeColor(context, 0, 1, 0, .9);
    CGContextMoveToPoint(context, 0, 100);
    CGContextAddLineToPoint(context, 40, 50);
    CGContextStrokePath(context);
    
    CGContextMoveToPoint(context, 40, 50);
    CGContextAddLineToPoint(context, 200, 100);
    CGContextStrokePath(context);
}


#pragma mark - 一段圆弧弧线：2点之间＋半径：CGContextAddArcToPoint
- (void)demo2AtRect:(CGRect)rect
{
    //矩形200*200内四分之一圆弧
    //首先CGContextMoveToPoint（context,x,y）移动到点（x,y）,然后CGContextAddArcToPoint(context,  x1, y1, x2, y2, radius)；这个方法是画弧线的，(x,y)和(x1,y1)构成切线1,(x1,y1)和(x2,y2)构成切线2，radius为弧线半径
    //显示的效果就是： (x,y)到圆弧的切点有一条线＋圆弧
    
    CGContextRef context =  UIGraphicsGetCurrentContext();
    
    CGContextBeginPath(context);
    
    //矩形区域
    CGContextMoveToPoint(context, 0, 0);
    CGContextAddRect(context, CGRectMake(0, 0, 200, 200));
    CGContextSetLineWidth(context, 3);
    CGContextStrokePath(context);//
    
    //直线＋弧线
    CGContextSetLineWidth(context, 5);
    CGContextMoveToPoint(context, 0, 200);
    CGContextAddArcToPoint(context, 0, 0, 200, 0, 100);
    CGContextSetRGBStrokeColor(context, 0, 1, 0, 0.9);
    CGContextStrokePath(context);
    
    
}

#pragma mark - base
- (void)demoAtRect:(CGRect)rect
{
    //CGContextRef 为上下文环境
    CGContextRef context =  UIGraphicsGetCurrentContext();
    
    CGContextBeginPath(context);
    
    //填充fill对应
    CGContextSetRGBFillColor(context, 0, 1, 1, .5);
    CGContextFillRect(context, rect);
    
    CGContextSetFillColorWithColor(context, [UIColor redColor].CGColor);
    CGContextFillRect(context, CGRectMake(0, 0, 50, 50));
    
    //画线stroke对应
    CGContextSetRGBStrokeColor(context, 1, 0, 0, .7);
    CGContextAddPath(context, [UIBezierPath bezierPathWithRect:CGRectMake(55, 55, 50, 50)].CGPath);
    CGContextStrokePath(context);
    
    [@"Hello" drawInRect:rect
          withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:160]}];
    
    //反锯齿
    CGContextSetAllowsAntialiasing(context, YES);
}

@end
