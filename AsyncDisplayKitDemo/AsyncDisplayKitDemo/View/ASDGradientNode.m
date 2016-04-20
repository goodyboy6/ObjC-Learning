//
//  ASDGradientNode.m
//  AsyncDisplayKitDemo
//
//  Created by yixiaoluo on 16/2/2.
//  Copyright © 2016年 yixiaoluo. All rights reserved.
//

#import "ASDGradientNode.h"
#import "AsyncDisplayKit.h"

@implementation ASDGradientNode

//参考ASDisplayNode+Subclasses.h： _ASDisplayLayerDelegate
+ (void)drawRect:(CGRect)bounds withParameters:(id<NSObject>)parameters isCancelled:(asdisplaynode_iscancelled_block_t)isCancelledBlock isRasterizing:(BOOL)isRasterizing;
{
    
    CGContextRef myContext = UIGraphicsGetCurrentContext();
    CGContextSaveGState(myContext);
    
    //对线半部分进行描绘
    CGContextClipToRect(myContext, CGRectMake(0, bounds.size.height/2, bounds.size.width, bounds.size.height/2));
    
    uint componentCount = 2;
    CGFloat locations[] = {0.0, 1.0};
    CGFloat components[] = {1,0,0,1,0,0,1,1};
    
    CGGradientRef gref = CGGradientCreateWithColorComponents(CGColorSpaceCreateDeviceRGB(), components, locations, componentCount);
    CGContextDrawLinearGradient(myContext, gref, CGPointMake(0, 0), CGPointMake(1, 1), kCGGradientDrawsAfterEndLocation);
    
    CGContextRestoreGState(myContext);
}

@end
