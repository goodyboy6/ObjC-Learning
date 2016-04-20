//
//  CustomAnnotationView.h
//  AMap
//
//  Created by yixiaoluo on 16/4/13.
//  Copyright © 2016年 yixiaoluo. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>
#import "CustomView.h"

@class CustomAnnotationView;
@protocol CustomAnnotationViewDeletete <NSObject>

@optional
- (void)customAnnotationViewCallOutDidSelected:(CustomAnnotationView *)view;

@end

@interface CustomAnnotationView : MAAnnotationView

@property (nonatomic, readonly) CustomView *customView;
@property (weak, nonatomic) id<CustomAnnotationViewDeletete> delegate;

@end
