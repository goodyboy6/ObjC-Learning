//
//  CustomAnnotationView.m
//  AMap
//
//  Created by yixiaoluo on 16/4/13.
//  Copyright © 2016年 yixiaoluo. All rights reserved.
//

#import "CustomAnnotationView.h"
#import "masonry.h"

@implementation CustomAnnotationView{
    CustomView *_customView;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    if (selected == self.selected) {
        return;
    }
    
    if (selected) {
        if (_customView == nil) {
            _customView = [[CustomView alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
            
            __weak typeof(self) weakSelf = self;
            _customView.tappedHandler = ^{
                __weak typeof(self) strong = weakSelf;
                if ([strong.delegate respondsToSelector:@selector(customAnnotationViewCallOutDidSelected:)]) {
                    [strong.delegate customAnnotationViewCallOutDidSelected:strong];
                }
            };
        }
        
        [_customView setText:self.annotation.title];
        [self addSubview:_customView];
        
        [_customView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.mas_centerX);
            make.bottom.equalTo(self.mas_top).offset(-2);
        }];
    }else{
        [_customView removeFromSuperview];
    }
    
    [super setSelected:selected animated:animated];
}


- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    NSLog(@"%@: %@", NSStringFromCGRect(_customView.frame), NSStringFromCGPoint(point));
    
    if (self.selected) {
        BOOL contains = CGRectContainsPoint(_customView.frame, point);
        return contains;
    }
    
    return [super pointInside:point withEvent:event];
}
@end
