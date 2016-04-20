//
//  CustomView.m
//  AMap
//
//  Created by yixiaoluo on 16/4/13.
//  Copyright © 2016年 yixiaoluo. All rights reserved.
//

#import "CustomView.h"
#import "masonry.h"

@implementation CustomView{
    UILabel *_titleLabel;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    self.backgroundColor = [UIColor blueColor];
    
    UILabel *label = [[UILabel alloc] init];
    label.text = @"点我";
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    [self addSubview:label];
    
    _titleLabel = label;
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).insets(UIEdgeInsetsMake(10, 10, 10, 10));
    }];
    
    return self;
}

- (void)setText:(NSString *)text
{
    _titleLabel.text = text;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (self.tappedHandler) {
        self.tappedHandler();
    }
}

@end
