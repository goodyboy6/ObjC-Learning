//
//  UIButton+BBDraw.m
//  BaoBao
//
//  Created by yixiaoluo on 15/12/3.
//  Copyright © 2015年 yixiaoluo. All rights reserved.
//

#import "UIButton+BBDraw.h"
#import <objc/runtime.h>

static char kPathThatHandled;

@implementation UIButton (BBDraw)
@dynamic pathThatHandled;

+ (instancetype)deletePathButtonWithTarget:(id)t selector:(SEL)s
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    UIImage *image = [UIImage imageNamed:@"iconfont-delete"];
    [button setImage:image forState:UIControlStateNormal];
    [button setAdjustsImageWhenHighlighted:YES];
    
    [button addTarget:t action:s forControlEvents:UIControlEventTouchUpInside];
    button.frame = (CGRect){.size = image.size};
    
    return button;
}

- (void)setPathThatHandled:(BBPathModel *)pathThatHandled
{
    objc_setAssociatedObject(self, &kPathThatHandled, pathThatHandled, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BBPathModel *)pathThatHandled
{
    return objc_getAssociatedObject(self, &kPathThatHandled);
}

@end
