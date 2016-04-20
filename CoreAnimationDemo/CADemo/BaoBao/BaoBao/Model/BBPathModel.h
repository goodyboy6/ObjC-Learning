//
//  BBPathModel.h
//  BaoBao
//
//  Created by yixiaoluo on 15/12/3.
//  Copyright © 2015年 yixiaoluo. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;

//表示一条路径
NS_ASSUME_NONNULL_BEGIN
@interface BBPathModel : NSObject

+ (instancetype)withStartNode:(CGPoint)node;

- (void)addNode:(CGPoint)node;
- (CGPoint)nodeAtIndex:(NSInteger)index;
- (NSInteger)nodeCount;

- (UIBezierPath * _Nonnull)bezierPath;

- (BOOL)containsNode:(CGPoint)node;

@end

NS_ASSUME_NONNULL_END
