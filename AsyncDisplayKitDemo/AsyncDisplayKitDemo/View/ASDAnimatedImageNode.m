//
//  ASDAnimatedImageNode.m
//  AsyncDisplayKitDemo
//
//  Created by yixiaoluo on 16/2/3.
//  Copyright © 2016年 yixiaoluo. All rights reserved.
//

#import "ASDAnimatedImageNode.h"
#import "AsyncDisplayKit.h"

@implementation ASDAnimatedImageNode

//- (id<CAAction>)actionForLayer:(CALayer *)layer forKey:(NSString *)event
//{
//    if ([event isEqualToString:@"contents"] && self.contents == nil) {
//        CATransition *t = [CATransition new];
//        t.duration = 0.6;
//        t.type = kCATransitionFade;
//        return t;
//    }
//    
//    id<CAAction> action = [super actionForLayer:layer forKey:event];
//    if (action) {
//        return action;
//    }
//
//    return nil;
//}

- (void)displayWillStart
{
    [super displayWillStart];
    
    //楼上的动画似乎是在监控runloop要休息的时候来做的
    //这段动画就正常很多
    CATransition *t = [CATransition new];
    t.duration = 0.6;
    t.type = kCATransitionFade;
    
    [self.layer addAnimation:t forKey:@""];
//    self.alpha = 0;
//    [UIView animateWithDuration:.6 animations:^{
//        self.alpha = 1;
//    }];
}

@end
