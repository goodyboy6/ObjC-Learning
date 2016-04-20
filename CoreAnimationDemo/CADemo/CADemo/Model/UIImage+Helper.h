//
//  UIImage+Helper.h
//  CADemo
//
//  Created by yixiaoluo on 15/11/10.
//  Copyright © 2015年 yixiaoluo. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^DividedHandler)(NSArray<NSString *> *smallFilePaths);

extern NSString* CAD_DocumentOfSmallImage();

@interface UIImage (Helper)

+ (void)divideToSmallImageFromBigImageAtPath:(NSString *)filePath
                                  completion:(DividedHandler)handler;

@end
