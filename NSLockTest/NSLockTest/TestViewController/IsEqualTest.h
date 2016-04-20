//
//  IsEqualTestViewController.h
//  NSLockTest
//
//  Created by yixiaoluo on 15/2/26.
//  Copyright (c) 2015年 cn.gikoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IsEqualTest : UIViewController

@end

@interface IsEqualTestObject : NSObject

@property (nonatomic) NSNumber *objID;
@property (copy, nonatomic) NSString *name;

+ (instancetype)buildAnObjectWithSameID;

@end