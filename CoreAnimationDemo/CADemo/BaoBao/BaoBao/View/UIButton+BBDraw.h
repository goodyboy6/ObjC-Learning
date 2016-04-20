//
//  UIButton+BBDraw.h
//  BaoBao
//
//  Created by yixiaoluo on 15/12/3.
//  Copyright © 2015年 yixiaoluo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BBPathModel;
@interface UIButton (BBDraw)

@property (nonatomic) BBPathModel *pathThatHandled;

+ (instancetype)deletePathButtonWithTarget:(id)t selector:(SEL)s;

@end
