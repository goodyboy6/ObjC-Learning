//
//  Q2DCycleView.m
//  Quartz 2D Demo
//
//  Created by yixiaoluo on 15/12/2.
//  Copyright © 2015年 yixiaoluo. All rights reserved.
//

#import "Q2DCycleView.h"

@implementation Q2DCycleView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    CAGradientLayer *layer = [CAGradientLayer layer];
    
    
    
    [self.layer addSublayer:layer];
    
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    
//    CGContextDrawLinearGradient(<#CGContextRef  _Nullable c#>, <#CGGradientRef  _Nullable gradient#>, <#CGPoint startPoint#>, <#CGPoint endPoint#>, <#CGGradientDrawingOptions options#>)
    
}


@end
