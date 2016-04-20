//
//  BBDrawView1.m
//  BaoBao
//
//  Created by yixiaoluo on 15/11/17.
//  Copyright © 2015年 yixiaoluo. All rights reserved.
//

#import "BBDrawView1.h"

static CGFloat const kSize = 32.;

@interface BBDrawView1 ()

@property (nonatomic) NSMutableArray *pathPoints;

@end

@implementation BBDrawView1

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
    
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    for (NSValue *value in self.pathPoints) {
        CGPoint p = value.CGPointValue;
        
        CGRect rect = CGRectMake(p.x - kSize/2, p.y - kSize/2, kSize, kSize);
        
        [[UIImage imageNamed:@"iconfont-fenleixiangao"] drawInRect:rect];;
    }
}
@end
