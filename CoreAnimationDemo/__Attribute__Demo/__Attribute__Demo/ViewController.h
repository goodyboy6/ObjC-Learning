//
//  ViewController.h
//  __Attribute__Demo
//
//  Created by yixiaoluo on 15/11/5.
//  Copyright © 2015年 yixiaoluo. All rights reserved.
//

#import <UIKit/UIKit.h>

//http://nshipster.com/__attribute__/

#pragma mark - GCC
//http://afreez.blog.51cto.com/59057/7351
extern int my_printf (void *my_object, const char *my_format, ...) __attribute__((format(printf, 2, 3)));
extern int my_printf (void *my_object, const char *my_format, ...) __attribute__((format(scanf, 2, 3)));

//参数不为null
extern NSString * NSStringFromStrings(NSString *str1, NSString *str2, NSInteger i) __attribute__((nonnull (1,2)));

extern void exit1(int)   __dead2;//__attribute__((noreturn));

extern int square1(int n) __pure2;//__attribute__((const));

//混写
extern void die(const char *format, ...) __attribute__((noreturn)) __attribute__((format(printf, 1, 2)));
extern void die(const char *format, ...) __attribute__((noreturn, format(printf, 1, 2)));

#pragma mark - LLVM
extern void f(void) __attribute__((availability(macosx,introduced=10.4,deprecated=10.6,obsoleted=10.7)));
extern void fios(void) __attribute__((availability(ios,introduced=8.0,deprecated=8.2,obsoleted=9.3)));

//c函数重载
extern void __attribute__((overloadable))  foo(int a);
extern void __attribute__((overloadable))  foo(float a);

@interface ViewController : UIViewController

- (NSString * )test __unused;

@end

