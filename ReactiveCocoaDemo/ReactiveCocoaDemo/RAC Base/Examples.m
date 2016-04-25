//
//  Examples.m
//  ReactiveCocoaDemo
//
//  Created by yixiaoluo on 16/4/25.
//  Copyright © 2016年 yixiaoluo. All rights reserved.
//

#import "Examples.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "LoginViewModel.h"

@implementation Examples{
    LoginViewModel *_prototypeModel;
}

- (void)excuteExamples
{
    [self excuteBuffer];
}

#pragma mark - sub example
- (void)excuteBuffer
{
    if (!_prototypeModel) {
        _prototypeModel = [LoginViewModel new];
    }
    
    RACSignal *signal1 = [_prototypeModel loginRequestSignal1];
    RACSignal *signal2 = [_prototypeModel loginRequestSignal2];

    //http://yulingtianxia.com/blog/2015/05/21/ReactiveCocoa-and-MVVM-an-Introduction/
    RACSignal *mergeSignal = [RACSignal merge:@[signal1, signal2]];
    RACSignal *bufferSignal = [mergeSignal bufferWithTime:1//收到1个信号后，缓冲1s后再发送给订阅者。这1s内收到的所有信号会被放到一个元组中发送给订阅者；超过1s的信号，将会另行单独发送
                                              onScheduler:[RACScheduler mainThreadScheduler]];

    NSLog(@"begin excuteHotSignal");
    
    //会放到下一个runloop循环中输出
    [bufferSignal subscribeNext:^(id x) {
        //tuple
        NSLog(@"signal result: %@", x);
    }];
    
    NSLog(@"end excuteHotSignal");
}


- (void)excuteInitially
{
    if (!_prototypeModel) {
        _prototypeModel = [LoginViewModel new];
    }
    
    RACSignal *signal = [[[[_prototypeModel loginRequestSignal]
                          initially:^{//每次subscribe执行前同步调用
                              NSLog(@"Second");
                          }] initially:^{
                              NSLog(@"First");
                          }] finally:^{//每次completion 或 error结束后调用
                              NSLog(@"finally");
                          }];
    
    NSLog(@"begin excuteHotSignal");
    
    [signal subscribeNext:^(id x) {
        //会放到下一个runloop循环中输出
        NSLog(@"output 1: %@", x);
    }];
    [signal subscribeNext:^(id x) {
        NSLog(@"output 2: %@", x);
    }];
    
    NSLog(@"end excuteHotSignal");
}

- (void)excuteRepeat
{
    if (!_prototypeModel) {
        _prototypeModel = [LoginViewModel new];
    }

    RACSignal *signal = [[[[_prototypeModel loginRequestSignal] delay:2] repeat] take:10];//每隔2s, 运行10次
    
    NSLog(@"begin excuteHotSignal");
    
    [signal subscribeNext:^(id x) {
        NSLog(@"output: %@", x);
    } error:^(NSError *error) {
        NSLog(@"error: %@", error);
    }];
    
    NSLog(@"end excuteHotSignal");
}


- (void)excuteReplayLast
{
    RACSubject *letters = [RACSubject subject];
    
    RACSignal *replaySignal = [letters
                               //replay];//调用replay后，block会立即执行，以后的subscribe都是返回当前的执行结果。只执行一次。
                               replayLast];//返回上一次block执行的结果
    //replayLazily];//不立即执行，延后到在第一次subscribe之前调用
    
    NSLog(@"begin excuteHotSignal");
    
    [letters sendNext:@"A"];
    [letters sendNext:@"B"];

    //同步执行
    //B
    [replaySignal subscribeNext:^(id x) {
        NSLog(@"output1 : %@", x);
    }];
    
    [letters sendNext:@"C"];

    //C
    [replaySignal subscribeNext:^(id x) {
        NSLog(@"output2 : %@", x);
    }];
    
    NSLog(@"end excuteHotSignal");
}

- (void)excuteReplay
{
    __block NSInteger count = 0;
    RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSLog(@"++count: %@", @(++count));
        [subscriber sendNext:@(count)];
        return nil;
    }];
    
    RACSignal *replaySignal = [signal
                               //replay];//调用replay后，block会立即执行，以后的subscribe都是返回当前的执行结果。只执行一次。
                               replayLast];//返回上一次信号执行的结果
                               //replayLazily];//不立即执行，延后到在第一次subscribe之前调用
    
    NSLog(@"begin excuteHotSignal");
    
    //同步执行
    [replaySignal subscribeNext:^(id x) {
        NSLog(@"output1 : %@", x);
    }];
    
    [replaySignal subscribeNext:^(id x) {
        NSLog(@"output2 : %@", x);
    }];
    
    NSLog(@"end excuteHotSignal");
}

- (void)excuteCombineLatest
{
    RACSubject *subject1 = [RACSubject subject];
    RACSubject *subject2 = [RACSubject subject];

    //combineLatest：合并信号，两个信号都返回后（随后任意一个值发生变化），输出对应的两个信号的最新值，输出： tt2-yy1, tt2-yy2
    //zip：合并信号，两个信号都返回后，对应输出返回值，subject1的第n个返回值对应subject2的第n个返回值，输出： tt1-yy1, tt2-yy2
    RACSignal *combineSignal = [RACSignal zip:@[subject1, subject2]
                                                 reduce:^id(NSString *str1, NSString *str2){//删除多余信息
                                                     return [NSString stringWithFormat:@"%@-%@", str1, str2];
                                                 }];
    
    //同步执行
    [combineSignal subscribeNext:^(id x) {
        NSLog(@"output: %@", x);
    }];
    
    [subject1 sendNext:@"tt1"];
    [subject1 sendNext:@"tt2"];

    NSLog(@"intter excuteHotSignal");
    
    [subject2 sendNext:@"yy1"];
    [subject2 sendNext:@"yy2"];

    NSLog(@"end excuteHotSignal");
}

- (void)excuteRACSubject
{
    RACSubject *subject = [RACSubject subject];
    
    NSLog(@"begin excuteHotSignal");
    
    //同步执行
    [subject subscribeNext:^(id x) {
        NSLog(@"output: %@", x);
    }];
    
    [subject sendNext:@"tt1"];
    
    NSLog(@"intter excuteHotSignal");

    [subject sendNext:@"tt2"];
    
    NSLog(@"end excuteHotSignal");
}

- (void)excuteThen
{
    RACSignal *signal1 = [@"1 2 3" componentsSeparatedByString:@" "].rac_sequence.signal;
    RACSignal *signal2 = [@"4 5 6" componentsSeparatedByString:@" "].rac_sequence.signal;
    
    NSLog(@"begin excuteHotSignal");
    
    //第一个signal执行完执行第二个signal
    RACSignal *thenSignal = [[signal1 doNext:^(NSNumber *x) {
        NSLog(@"signal1 result: %@", x);
    }] then:^RACSignal *{
        return signal2;
    }];
    
    //会放到下一个runloop循环中输出
    [thenSignal subscribeNext:^(id x) {
        NSLog(@"signal2 result: %@", x);
    }];
    
    NSLog(@"end excuteHotSignal");
}

- (void)excuteConcat
{
    RACSignal *signal1 = [@"1 2 3" componentsSeparatedByString:@" "].rac_sequence.signal;
    RACSignal *signal2 = [@"4 5 6" componentsSeparatedByString:@" "].rac_sequence.signal;
    
    NSLog(@"begin excuteHotSignal");
    
    RACSignal *mergedSignal2 = [signal1 concat:signal2];//执行完signal1，再执行signal2，输出: 412536
    
    //会放到下一个runloop循环中输出
    [mergedSignal2 subscribeNext:^(id x) {
        NSLog(@"output: %@", x);
    }];
    
    NSLog(@"end excuteHotSignal");
}

- (void)excuteMerge
{
    RACSignal *signal1 = [@"1 2 3" componentsSeparatedByString:@" "].rac_sequence.signal;
    RACSignal *signal2 = [@"4 5 6" componentsSeparatedByString:@" "].rac_sequence.signal;

    NSLog(@"begin excuteHotSignal");
    
    //两者等价
//    RACSignal *mergedSignal1 = [RACSignal merge:@[signal1, signal2]];//合并信号，输出: 415263
    RACSignal *mergedSignal2 = [signal1 merge:signal2];//合并信号，输出: 412536

    //会放到下一个runloop循环中输出
    [mergedSignal2 subscribeNext:^(id x) {
        NSLog(@"output: %@", x);
    }];
    
    NSLog(@"end excuteHotSignal");
}

- (void)excuteDistinct
{
    RACSignal *signal = [@"1 2 2 3 3" componentsSeparatedByString:@" "].rac_sequence.signal;
    
    NSLog(@"begin excuteHotSignal");
    
    RACSignal *tokenSignal = [signal distinctUntilChanged];//前后输出值不同
    
    //会放到下一个runloop循环中输出
    [tokenSignal subscribeNext:^(id x) {
        NSLog(@"output: %@", x);
    }];
    
    NSLog(@"end excuteHotSignal");
}

- (void)excuteThrottles
{
    RACSignal *signal = [@"1 2 2 3 3" componentsSeparatedByString:@" "].rac_sequence.signal;
    
    NSLog(@"begin excuteHotSignal");
    
    RACSignal *tokenSignal = [signal throttle:0.5
                            valuesPassingTest:^BOOL(NSNumber *next) {
                                return next.integerValue != 2;//返回NO，则表明在时间阀值内不考虑过滤此next值，输出223
//                                return next.integerValue >= 2;//输出1和最后一个值3
//                                return next.integerValue <=2;//输出33
//                                return YES;
                            }];//0.5s内如果有值输出，至少输出最后一个值。所以3是必输出项。
    
    [tokenSignal subscribeNext:^(id x) {
        //会放到下一个runloop循环中输出
        NSLog(@"output: %@", x);
    }];
    
    NSLog(@"end excuteHotSignal");
}

- (void)excuteSkip
{
    if (!_prototypeModel) {
        _prototypeModel = [LoginViewModel new];
    }
    
    //跳过初始值
    RACSignal *skippedSignal = [RACObserve(self->_prototypeModel, userName) skip:1];//跳过第1次开始执行
    
    NSLog(@"begin excuteHotSignal");
    
    //会放到下一个runloop循环中输出
    [skippedSignal subscribeNext:^(id x) {
        NSLog(@"output: %@", x);
    }];
    
    NSLog(@"end excuteHotSignal");
}

- (void)excuteTake
{
    RACSignal *signal = [@"1 2 3" componentsSeparatedByString:@" "].rac_sequence.signal;
    
    NSLog(@"begin excuteHotSignal");
    
    
    RACSignal *tokenSignal = [signal take:2];//只接收前2次
    
    [tokenSignal subscribeNext:^(id x) {
        //会放到下一个runloop循环中输出
        NSLog(@"output: %@", x);
    }];
    
    NSLog(@"end excuteHotSignal");
}


- (void)excuteFilter
{
    RACSignal *signal = [@"1 2 3" componentsSeparatedByString:@" "].rac_sequence.signal;
    
    NSLog(@"begin excuteHotSignal");
    
    RACSignal *filteredSignal = [signal filter:^BOOL(NSString *value) {//加入过滤条件
        return value.integerValue > 1;
    }];
    
    [filteredSignal subscribeNext:^(id x) {
        //会放到下一个runloop循环中输出
        NSLog(@"output: %@", x);
    }];
    
    NSLog(@"end excuteHotSignal");
}

- (void)excuteMap
{
    RACSignal *signal = [@"1 2 3" componentsSeparatedByString:@" "].rac_sequence.signal;
    
    NSLog(@"begin excuteHotSignal");
    
    //map将一个值转化为另一个值输出
    RACSignal *mappedsSignal = [signal map:^id(NSString *value) {
        return [NSString stringWithFormat:@"%@_%@", value, value];
    }];
    
    [mappedsSignal subscribeNext:^(id x) {
        //会放到下一个runloop循环中输出
        NSLog(@"output: %@", x);
    }];
    
    NSLog(@"end excuteHotSignal");
}

- (void)excuteHotSignal
{
    RACSignal *signal = [@"1 2 3" componentsSeparatedByString:@" "].rac_sequence.signal;
    
    NSLog(@"begin excuteHotSignal");
    
    [signal subscribeNext:^(id x) {
        //会放到下一个runloop循环中输出
        NSLog(@"idnex 1: %@", x);
    }];
    
    [signal subscribeNext:^(id x) {
        NSLog(@"idnex 2: %@", x);
    }];

    [signal subscribeNext:^(id x) {
        NSLog(@"idnex 3: %@", x);
    }];
    
    NSLog(@"end excuteHotSignal");
}



@end
