//
//  CALayer+CADHelper.h
//  CADemo
//
//  Created by yixiaoluo on 15/11/4.
//  Copyright © 2015年 yixiaoluo. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface CALayer (CADHelper)

//添加阴影
- (void)setShadow;

//添加寄宿图，并设置
- (void)setContentsWithImageName:(NSString *)imgName contentsGravity:(NSString *)contentsGravity;

//修改anchor
- (void)changeAnchorTo:(CGPoint)p;

//将图层拿到layer上面
- (void)setInFrontOfLayer:(CALayer *)layer;

//组透明
- (void)rasterize;

- (void)addCornerRadius:(CGFloat)cornerRadius;

@end
