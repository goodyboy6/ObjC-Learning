//
//  KVC_KVO_.h
//  NSLockTest
//
//  Created by yixiaoluo on 15/3/19.
//  Copyright (c) 2015年 cn.gikoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KVC_KVO_ : UITableViewController

@end

@class Person;
@interface KVOObject : NSObject

@property (nonatomic) NSInteger pid;
@property (readonly, nonatomic) NSMutableArray *personArray;

@end


@interface Person : NSObject

@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *sex;
@property (copy, nonatomic) NSString *birthday;

@end
