//
//  ViewTestViewController.h
//  NSLockTest
//
//  Created by yixiaoluo on 15/3/9.
//  Copyright (c) 2015年 cn.gikoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewTest : UIViewController

@end

@interface TextViewTest : UIView

@property (nonatomic) UITextView *textView;

- (CGFloat)textViewVerticalPadding;

@end