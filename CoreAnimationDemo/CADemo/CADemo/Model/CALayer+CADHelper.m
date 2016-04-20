//
//  CALayer+CADHelper.m
//  CADemo
//
//  Created by yixiaoluo on 15/11/4.
//  Copyright © 2015年 yixiaoluo. All rights reserved.
//

#import "CALayer+CADHelper.h"
@import UIKit;

@implementation CALayer (CADHelper)

- (void)setShadow
{
    self.shadowOpacity = 1.0;
    self.shadowColor = [UIColor blueColor].CGColor;
    self.shadowOffset = CGSizeMake(0, 5);
    self.shadowPath = [UIBezierPath bezierPathWithRect:self.bounds].CGPath;
    self.shadowRadius = 5;
}

- (void)setContentsWithImageName:(NSString *)imgName contentsGravity:(NSString *)contentsGravity
{
    UIImage *img = [UIImage imageNamed:@"copy"];
    
    self.contents = (__bridge id)img.CGImage;
    self.contentsScale = img.scale;
    self.contentsGravity = contentsGravity;
}

- (void)changeAnchorTo:(CGPoint)p
{
    //http://wonderffee.github.io/blog/2013/10/13/understand-anchorpoint-and-position/
    //    frame.origin.x = position.x - anchorPoint.x * bounds.size.width；
    //    frame.origin.y = position.y - anchorPoint.y * bounds.size.height；
    CGRect oldFrame = self.frame;
    self.anchorPoint = p;
    self.frame = oldFrame;
}

- (void)setInFrontOfLayer:(CALayer *)layer
{
    self.zPosition = layer.zPosition - 1;
}

- (void)rasterize
{
    self.shouldRasterize = YES;
    self.rasterizationScale = [UIScreen mainScreen].scale;
}

- (void)addCornerRadius:(CGFloat)cornerRadius
{
    self.cornerRadius = cornerRadius;
    //self.masksToBounds = YES;
}

@end
