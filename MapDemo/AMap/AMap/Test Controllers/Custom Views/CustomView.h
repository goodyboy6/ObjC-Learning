//
//  CustomView.h
//  AMap
//
//  Created by yixiaoluo on 16/4/13.
//  Copyright © 2016年 yixiaoluo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomView : UIView

@property (copy, nonatomic) dispatch_block_t tappedHandler;

- (void)setText:(NSString *)text;

@end
