//
//  BBDrawView.m
//  BaoBao
//
//  Created by yixiaoluo on 15/11/17.
//  Copyright © 2015年 yixiaoluo. All rights reserved.
//

#import "BBDrawView.h"
#import "BBPathModel.h"
#import "UIBezierPath+BBDraw.h"
#import "UIButton+BBDraw.h"

@interface BBDrawView ()

//当前绘制路径：描绘时为当前绘制曲线；后退等其他操作时为全路径
@property (nonatomic) UIBezierPath *path;

@property (nonatomic) NSMutableArray *pathRecords;//包括当前描绘路径的所有路径，最后一个为当前绘制路径
@property (nonatomic) UIImage *lastSnapshot;//不包含当前绘制路径的截图

//删除线
@property (nonatomic) CGPoint touchPoint;//点击选中线的点
@property (nonatomic) UIButton *deletePathButton;//点击选中的线后出现的删除按钮

@end

@implementation BBDrawView

#pragma mark - open api
- (BOOL)canGoBack
{
    return self.pathRecords.count > 0;
}

- (void)goBack
{
    if (![self canGoBack]) {
        return;
    }
    
    [self disableDeleteStatus];
    [self.pathRecords removeLastObject];
    
    [self.path removeAllPoints];
    [self.path appendPath:[self fullBezierPath]];
    
    self.lastSnapshot = nil;
    [self updateSnapshotWithBezierPath:self.path];
    
    [self setNeedsDisplay];

    if ([self.delegate respondsToSelector:@selector(drawViewDidFinishChange:)]) {
        [self.delegate drawViewDidFinishChange:self];
    }
}

- (void)clear
{
    if (![self canGoBack]) {
        return;
    }

    [self disableDeleteStatus];
    [self.pathRecords removeAllObjects];
    
    [self.path removeAllPoints];
    
    self.lastSnapshot = nil;
    [self updateSnapshotWithBezierPath:self.path];
    
    [self setNeedsDisplay];

    if ([self.delegate respondsToSelector:@selector(drawViewDidFinishChange:)]) {
        [self.delegate drawViewDidFinishChange:self];
    }
}

- (void)enableDeleteStatus
{
    UIButton *button = self.deletePathButton;
    
    BBPathModel *model = button.pathThatHandled;
    [self.pathRecords removeObject:model];
    
    [self.path removeAllPoints];
    [self.path appendPath:[self fullBezierPath]];
    
    self.lastSnapshot = nil;
    [self updateSnapshotWithBezierPath:self.path];

    [self setNeedsDisplay];
    
    [button removeFromSuperview];
    
    if ([self.delegate respondsToSelector:@selector(drawViewDidFinishChange:)]) {
        [self.delegate drawViewDidFinishChange:self];
    }
}

- (void)disableDeleteStatus
{
    [self.deletePathButton removeFromSuperview];
}

#pragma mark - life cycle
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    [self setup];
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    //from nib
    self = [super initWithCoder:aDecoder];
    [self setup];
    return self;
}

- (void)setup
{
    self.path = [UIBezierPath defaultDrawBezierPath];
    self.pathRecords = [NSMutableArray array];
}

- (void)drawRect:(CGRect)rect
{
    [self.lastSnapshot drawInRect:rect];
    
    [[UIColor redColor] setStroke];
    [self.path stroke];
}

#pragma mark - touch response
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    CGPoint p = [[touches anyObject] locationInView:self];
    
    self.touchPoint = p;
    
    [self disableDeleteStatus];

    //新节点
    BBPathModel *model = [BBPathModel withStartNode:p];
    [self.pathRecords addObject:model];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    CGPoint p = [[touches anyObject] locationInView:self];
    
    //重置点击操作点
    self.touchPoint = CGPointZero;

    //新节点路径
    [self.pathRecords.lastObject addNode:p];
    
    //如果不构成一个新的bezier曲线，不进行绘制
    UIBezierPath *currentBezierPath = [self.pathRecords.lastObject bezierPath];
    if (currentBezierPath) {
        [self.path removeAllPoints];
        [self.path appendPath:currentBezierPath];
        [self setNeedsDisplay];
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
    if (!CGPointEqualToPoint(self.touchPoint , CGPointZero)) {
        //点击操作
         //当前绘制路径不是有效路径，从数组删除
        [self.pathRecords removeLastObject];

        //查找的被点击的线， 添加删除按钮
        for (BBPathModel *model in self.pathRecords) {
            if ([model containsNode:self.touchPoint]) {
                CGPoint lastPoint = [model nodeAtIndex:model.nodeCount - 1];
                self.deletePathButton = [UIButton deletePathButtonWithTarget:self selector:@selector(enableDeleteStatus)];
                self.deletePathButton.pathThatHandled = model;
                self.deletePathButton.center = lastPoint;
                [self addSubview:self.deletePathButton];
                break;
            }
        }
        
    }else{
        //画线操作
        //路径变更，修改截图
        [self updateSnapshotWithBezierPath:[self fullBezierPath]];
        
        if ([self.delegate respondsToSelector:@selector(drawViewDidFinishChange:)]) {
            [self.delegate drawViewDidFinishChange:self];
        }
    }
}

#pragma mark - getter
- (UIBezierPath *)fullBezierPath
{
    UIBezierPath *bezierPath = [UIBezierPath defaultDrawBezierPath];
    
    for (BBPathModel *pathModel in self.pathRecords) {
        [bezierPath appendPath:[pathModel bezierPath]];
    }
    return bezierPath;
}

- (void)updateSnapshotWithBezierPath:(UIBezierPath *)path
{
    if (path.isEmpty) {
        self.lastSnapshot = nil;
        return;
    }
    
    //截图
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, YES, [UIScreen mainScreen].scale);
    
    if (!self.lastSnapshot) {
        UIBezierPath *bgPath = [UIBezierPath bezierPathWithRect:self.bounds];
        [[UIColor whiteColor] setFill];
        [bgPath fill];
    }else{
        [self.lastSnapshot drawInRect:self.bounds];
    }
    
    [[UIColor redColor] setStroke];
    [path stroke];
    
    self.lastSnapshot = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
}

@end

