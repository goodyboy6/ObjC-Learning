//
//  Contant.h
//  NSLockTest
//
//  Created by yixiaoluo on 15/2/27.
//  Copyright (c) 2015年 cn.gikoo. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, TestType) {
    kTestNSLock = 1,
    kTestDispatchTimer,
    kTestIsEqualAndHash,
    kTestMultithread,
    kTestSwizzling,
    kTestNSOperation,
    kTestNSProxy,
    kTestUIView,
    kTestSegue,
    kTestBezierPath,
    kTestModel,
    kTestRunLoop,
    kTestCopying,
    kTestViewProperty
};

@interface Contant : NSObject

+ (NSArray *)allTestTypeStrings;

@end
