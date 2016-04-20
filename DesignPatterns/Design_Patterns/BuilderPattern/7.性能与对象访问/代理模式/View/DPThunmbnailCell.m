//
//  DPThunmbnailCell.m
//  Design_Patterns
//
//  Created by yixiaoluo on 15/9/8.
//  Copyright (c) 2015年 yixiaoluo. All rights reserved.
//

#import "DPThunmbnailCell.h"

@implementation DPThunmbnailCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    self.thunmbnailProxy = [[DPThumbnailProxy alloc] initWithFrame:self.bounds];
    [self addSubview:self.thunmbnailProxy];
    
    return self;
}

- (void)setDelegate:(id<DPThumbnailProxyProtocol>)delegate
{
    self.thunmbnailProxy.delegate = delegate;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.thunmbnailProxy.frame = self.bounds;
    [self.thunmbnailProxy setNeedsDisplay];
}

@end
