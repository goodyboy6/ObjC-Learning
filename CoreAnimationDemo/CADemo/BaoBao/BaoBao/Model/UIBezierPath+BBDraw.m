//
//  UIBezierPath+BBDraw.m
//  BaoBao
//
//  Created by yixiaoluo on 15/12/3.
//  Copyright © 2015年 yixiaoluo. All rights reserved.
//

#import "UIBezierPath+BBDraw.h"

@implementation UIBezierPath (BBDraw)

+ (instancetype)defaultDrawBezierPath
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    path.lineCapStyle = kCGLineCapRound;
    path.lineJoinStyle = kCGLineJoinRound;
    path.lineWidth = 16;
    
    return path;
}

@end
