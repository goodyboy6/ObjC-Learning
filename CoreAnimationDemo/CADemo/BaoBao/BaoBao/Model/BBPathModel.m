//
//  BBPathModel.m
//  BaoBao
//
//  Created by yixiaoluo on 15/12/3.
//  Copyright © 2015年 yixiaoluo. All rights reserved.
//

#import "BBPathModel.h"
#import "UIBezierPath+BBDraw.h"

@implementation BBPathModel{
    NSMutableArray<NSValue *> *_mNodes;
}

+ (instancetype)withStartNode:(CGPoint)node
{
    BBPathModel *pathModel = [[BBPathModel alloc] init];
    [pathModel addNode:node];
    return pathModel;
}

- (BOOL)containsNode:(CGPoint)node
{
    BOOL contains = NO;
    CGFloat marginDistance = 16+20;//添加为线宽的矩形+容错区域20
    for (NSValue *record in _mNodes) {
        CGPoint targetPoint = record.CGPointValue;
        CGRect targetRect = CGRectMake(targetPoint.x - marginDistance/2, targetPoint.y-marginDistance/2, marginDistance, marginDistance);
        if (CGRectContainsPoint(targetRect, node)) {
            contains = YES;
            break;
        }
    }
    
    return contains;
}

- (NSInteger)nodeCount;
{
    return _mNodes.count;
}

- (void)addNode:(CGPoint)node
{
    if (_mNodes == nil) {
        _mNodes = [NSMutableArray array];
    }
    
    [_mNodes addObject:[NSValue valueWithCGPoint:node]];
}

- (CGPoint)nodeAtIndex:(NSInteger)index
{
    if (index >= _mNodes.count) {
        return _mNodes.lastObject.CGPointValue;
    }
    
    return _mNodes[index].CGPointValue;
}

- (UIBezierPath * _Nonnull)bezierPath;
{
    UIBezierPath *path = [UIBezierPath defaultDrawBezierPath];
    
    //addLineToPoint会出现折线
    //优化：采用三次bezier path绘制曲线。保证每个点之间的连接是平滑过渡，前一条曲线的终点切线和后一条曲线的开始切线是重合的，并且前一条曲线的终点为后一条曲线的始点
    //如取5个点， {0,1,2,3,4}, 起始点为0，12为控制点，3为终点，要保证23切线和34切线重合并，将3重新定义为2和4的中心点，以此类推
    //满足5个点才进行绘制, 换句话说前4个点不会进行绘制会体验上会有延迟
    NSInteger nodesCount = [self nodeCount];
    if (nodesCount <= 4) {
        //解决体验延迟问题
        if (nodesCount == 4) {
            CGPoint p0 = [self nodeAtIndex:0];
            CGPoint p1 = [self nodeAtIndex:1];
            CGPoint p2 = [self nodeAtIndex:2];
            CGPoint p3 = [self nodeAtIndex:3];
            [path moveToPoint:p0];
            [path addCurveToPoint:p3 controlPoint1:p1 controlPoint2:p2];
        }else if (nodesCount == 3){
            //二次bezier path绘制曲线
            CGPoint p0 = [self nodeAtIndex:0];
            CGPoint p1 = [self nodeAtIndex:1];
            CGPoint p2 = [self nodeAtIndex:2];
            [path moveToPoint:p0];
            [path addQuadCurveToPoint:p2 controlPoint:p1];
        }else if (nodesCount == 2){
            CGPoint p0 = [self nodeAtIndex:0];
            CGPoint p1 = [self nodeAtIndex:1];
            [path moveToPoint:p0];
            [path addLineToPoint:p1];
        }else{
            return nil;
        }
        
        return path;
    }
    
    CGPoint p0 = [self nodeAtIndex:0];
    CGPoint p1 = [self nodeAtIndex:1];
    CGPoint p2,p3,p4;
    
    NSInteger i;
    for (i=2; i<nodesCount; i+=3) {
        NSInteger leftCount = nodesCount - i +1;
        if (leftCount < 3) {
            break;
        }
        
        [path moveToPoint:p0];
        
        //p3为p2 p4的中点
        p2 = [self nodeAtIndex:i];
        p4 = [self nodeAtIndex:i+2];
        p3 = CGPointMake((p2.x+p4.x)/2, (p2.y+p4.y)/2);
        
        [path addCurveToPoint:p3 controlPoint1:p1 controlPoint2:p2];
        
        p0 = p3;
        p1 = p4;
    }
    
    NSInteger leftCount = nodesCount - i +1;
    //解决最后点数不足，线条丢失问题
    if (leftCount < 3) {
        if (leftCount == 2) {
            CGPoint p2 = [self nodeAtIndex:i];
            CGPoint p3 = [self nodeAtIndex:i+1];
            [path moveToPoint:p0];
            [path addCurveToPoint:p3 controlPoint1:p1 controlPoint2:p2];
        }else if (leftCount == 1){
            CGPoint p2 = [self nodeAtIndex:i];
            [path moveToPoint:p0];
            [path addQuadCurveToPoint:p2 controlPoint:p1];
        }
    }
    
    return path;
}

#pragma mark - private

@end
