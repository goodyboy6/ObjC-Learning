//
//  BBDrawView2.m
//  BaoBao
//
//  Created by yixiaoluo on 15/11/17.
//  Copyright © 2015年 yixiaoluo. All rights reserved.
//

#import "BBDrawView2.h"

static CGFloat const kSize = 32.;

@interface BBDrawView2 ()

@property (nonatomic) NSMutableArray *pathPoints;

@end

@implementation BBDrawView2

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (self.pathPoints == nil) {
        self.pathPoints = [NSMutableArray array];
    }

    CGPoint p = [[touches anyObject] locationInView:self];
    [self.pathPoints addObject:[NSValue valueWithCGPoint:p]];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    CGPoint p = [[touches anyObject] locationInView:self];
    
    [self.pathPoints addObject:[NSValue valueWithCGPoint:p]];
    
    //只绘制“赃矩形”
    [self setNeedsDisplayInRect:[self rectThatNeddDrawAtPoint:p]];
}

- (CGRect)rectThatNeddDrawAtPoint:(CGPoint)p
{
    return CGRectMake(p.x - kSize/2, p.y - kSize/2, kSize, kSize);
}

- (void)drawRect:(CGRect)rect
{
    for (NSValue *value in self.pathPoints) {
        CGPoint p = value.CGPointValue;
        
        CGRect subRect = [self rectThatNeddDrawAtPoint:p];
        
        //只绘制有交集的区域
        if (CGRectIntersectsRect(rect, subRect)) {
            [[UIImage imageNamed:@"iconfont-fenleixiangao"] drawInRect:subRect];;
        }
    }
}

@end
