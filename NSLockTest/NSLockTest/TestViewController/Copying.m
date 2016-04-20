//
//  Copying.m
//  NSLockTest
//
//  Created by yixiaoluo on 15/4/19.
//  Copyright (c) 2015年 cn.gikoo. All rights reserved.
//

#import "Copying.h"
#import "TestModel.h"

@implementation Copying

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //http://blog.sina.com.cn/s/blog_7c8dc2d50101kwpr.html
    //深拷贝
    CopiedObject *obj = [[CopiedObject alloc] init];
    obj.name = @"name 1";
    CopiedObject *obj2 = [obj copy];
    NSLog(@"origin:%@, copied: %@", obj, obj2);
    
    /**
     if copyItems is YES, whether is deep copy depends on the items in the array support deep copy
     if NO, it is shallow copy
     :returns: a deep copy or a shadow copy
     */
    //数组深拷贝
    NSArray *array = @[obj];
    NSArray *copiedOne = [array copy];
    NSMutableArray *mutableCopiedOne = [array mutableCopy];
    NSLog(@"%@, %@, %@", array, copiedOne, mutableCopiedOne);

    NSArray *array2 = [[NSArray alloc] initWithArray:array copyItems:YES];
    NSLog(@"init array:  origin:%@, copied:%@", array, array2);
    
    //字典深拷贝
    NSDictionary *dic = @{@"key": obj};
    NSDictionary *dic2 = [[NSDictionary alloc] initWithDictionary:dic copyItems:YES];
    NSLog(@"dictionay:  origin:%@, copied:%@", dic, dic2);
    
    
    NSString *aString = [[NSString alloc] init];
    NSString *copiedString = [aString copy];
    NSString *mutableCopiedStirng = [aString mutableCopy];
    NSLog(@"%@, %@, %@", aString, copiedString, copiedString);

    //test NSObject copy， crash here
//    NSObject *originObject = [[NSObject alloc] init];
//    NSObject *copiedObject = [originObject copy];
//    NSObject *mutableCopiedObject = [originObject mutableCopy];
//    NSLog(@"%@, %@, %@", originObject, copiedObject, mutableCopiedObject);
}

@end
