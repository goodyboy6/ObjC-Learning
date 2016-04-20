//
//  ViewController.m
//  JSCoreDemo
//
//  Created by yixiaoluo on 15/9/15.
//  Copyright (c) 2015年 yixiaoluo. All rights reserved.
//

#import "ViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    JSContext *context = [[JSContext alloc] init];
    [context evaluateScript:@"var num = 5 + 5"];
    [context evaluateScript:@"var names = ['Grace', 'Ada', 'Margaret']"];
    [context evaluateScript:@"var triple = function(value) { return value * 3 }"];
    JSValue *tripleNum = [context evaluateScript:@"triple(num)"];
    
    NSLog(@"%i", [tripleNum toInt32]);
    JSValue *function = context[@"triple"];
    NSLog(@"%i", [[function callWithArguments:@[@100]] toInt32]);
    
    
    context[@"getJSString"] = ^NSString *(NSString *string){
        NSMutableString *mutableString = [string mutableCopy];
        CFStringTransform((__bridge CFMutableStringRef)mutableString, NULL, kCFStringTransformToLatin, NO);
        CFStringTransform((__bridge CFMutableStringRef)mutableString, NULL, kCFStringTransformStripCombiningMarks, NO);
        return mutableString;
    };
    
    NSLog(@"%@", [context evaluateScript:@"getJSString('你好JSCore')"]);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
