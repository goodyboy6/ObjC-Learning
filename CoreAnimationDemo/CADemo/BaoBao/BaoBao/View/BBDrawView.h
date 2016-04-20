//
//  BBDrawView.h
//  BaoBao
//
//  Created by yixiaoluo on 15/11/17.
//  Copyright © 2015年 yixiaoluo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BBDrawView;
@protocol BBDrawViewDelegate <NSObject>

@optional
- (void)drawViewDidFinishChange:(BBDrawView *)view;

@end

@interface BBDrawView : UIView

@property (weak, nonatomic) IBOutlet id<BBDrawViewDelegate> delegate;

- (BOOL)canGoBack;
- (void)goBack;

- (void)clear;

@end


