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
    [self excuteCatchErrorSignal];
}

#pragma mark - sub example
- (void)excuteCatchErrorSignal
{
    if (!_prototypeModel) {
        _prototypeModel = [LoginViewModel new];
    }
    
    RACSignal *loginSignal = [_prototypeModel loginRequestErrorSignal];
    
    //如果errorSignal出错，订阅返回的signal
    RACSignal *catchErrorSignal = [loginSignal catch:^RACSignal *(NSError *error) {
        return @[ @1, @2, @3, @4 ].rac_sequence.signal;
    }];
    
    NSLog(@"begin excute");
    
    [catchErrorSignal subscribeNext:^(id x) {
        NSLog(@"output: %@", x);
    } error:^(NSError *error) {
        NSLog(@"不再走error block");
    }];
    
    NSLog(@"end excute");
}

- (void)excuteTakeUntilSignal
{
    if (!_prototypeModel) {
        _prototypeModel = [LoginViewModel new];
    }
    
    RACSignal *repeatSignal = [[[_prototypeModel loginRequestSignal] delay:1] repeat];//每隔1s, 运行10次
    RACSignal *closeSignal = [_prototypeModel loginRequestSignal2];
    
    //直到closeSignal执行sendNext 或者 complete，repeatSignal结束调用。
//    RACSignal *takeUtilSignal = [repeatSignal takeUntil:closeSignal];
    
    //同上，但同时会用closeSignal替换当前的尚未输出的信号进行输出
    RACSignal *takeUtilSignal = [repeatSignal takeUntilReplacement:closeSignal];

    NSLog(@"begin excute");
    
    [takeUtilSignal subscribeNext:^(id x) {
        NSLog(@"output: %@", x);
    } error:^(NSError *error) {
        NSLog(@"error: %@", error);
    }];
    
    NSLog(@"end excute");
}


- (void)excuteTakeUntilBlock
{
    RACSequence *numbers = @[ @1, @2, @3, @4 ].rac_sequence;
    
    //如需输出，则返回NO
    RACSignal *takeUntilBlock = [numbers.signal takeUntilBlock:^BOOL(NSNumber *x) {
        if (x.integerValue < 3) {
            return NO;
        }
        return YES;
    }];
    
    [takeUntilBlock subscribeNext:^(id x) {
        NSLog(@"takeUntilBlock: %@", x);
    }];
    
    //和takeUntil相反。如需输出，则返回YES
    RACSignal *takeWhileUntil = [numbers.signal takeWhileBlock:^BOOL(NSNumber *x) {
        //执行到>=3截止
        if (x.integerValue >= 3) {
            return NO;
        }
        return YES;
    }];
    
    [takeWhileUntil subscribeNext:^(id x) {
        NSLog(@"takeWhileBlock: %@", x);
    }];
}

- (void)excuteInterval
{
//    RACSequence *numbers = @[ @1, @2, @3, @4 ].rac_sequence;
    
    //类似一个NSTimer计时器
    RACSignal *intervalSignal = [RACSignal interval:1 onScheduler:[RACScheduler mainThreadScheduler]];
    [intervalSignal subscribeNext:^(id x) {
        NSLog(@"%@", x);
    }];
    
    //0.1s误差
    RACSignal *intervalSignal2 = [RACSignal interval:1 onScheduler:[RACScheduler mainThreadScheduler] withLeeway:.5];
    [intervalSignal2 subscribeNext:^(id x) {
        NSLog(@"Leeway: %@", x);
    }];
}

- (void)excuteAggregate
{
    RACSequence *numbers = @[ @1, @2, @3, @4 ].rac_sequence;
    
    //输出 1, 3, 6, 10
    RACSequence *sums = [numbers scanWithStart:@0 reduce:^(NSNumber *sum, NSNumber *next) {
        return @(sum.integerValue + next.integerValue);
    }];
    
    [sums.signal subscribeNext:^(id x) {
        NSLog(@"scanWithStart output: %@", x);
    }];
    
    //11188492697607
    //只输出最后一次 10
    //Aggregates the `next` values of the receiver into a single combined value.
    RACSignal *aggSignal = [numbers.signal aggregateWithStart:@0
                                                       reduce:^id(NSNumber *sum, NSNumber *next) {
                                                           return @(sum.integerValue + next.integerValue);
                                                       }];
    [aggSignal subscribeNext:^(id x) {
        NSLog(@"aggregateWithStart output: %@", x);
    }];
    
    //等价于===>
    RACSignal *aggSignal2 = [numbers.signal aggregateWithStart:@0
                                               reduceWithIndex:^id(NSNumber *sum, NSNumber *next, NSUInteger index) {
                                                   return @(sum.integerValue + next.integerValue);
                                               }];
    [aggSignal2 subscribeNext:^(id x) {
        NSLog(@"aggregateWithStart index output: %@", x);
    }];
    
    //等价于===>
    RACSignal *aggSignal3 = [numbers.signal aggregateWithStartFactory:^id{
        return @0;
    } reduce:^id(NSNumber *sum, NSNumber *next) {
        return @(sum.integerValue + next.integerValue);
    }];
    [aggSignal3 subscribeNext:^(id x) {
        NSLog(@"aggregateWithStart index output: %@", x);
    }];
}

- (void)excuteFlatten
{
    RACSubject *subject1 = [RACSubject subject];
    RACSubject *subject2 = [RACSubject subject];
    RACSubject *subject3 = [RACSubject subject];
    RACSubject *subject4 = [RACSubject subject];
    RACSubject *subject5 = [RACSubject subject];

    RACSignal *sig = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:subject1];
        [subscriber sendNext:subject2];
        [subscriber sendNext:subject3];
        [subscriber sendNext:subject4];
        [subscriber sendNext:subject5];
        [subscriber sendCompleted];
        return nil;
    }];
    
    //merge3个信号到一个flatten队列信号中, 最多同时操作3个信号，超过3个的信号将会在有信号完成时，逐个加入到队列。
    //可以用于一个限制并发数的下载队列；也可以设置maxConcurrent为1，让多个信号顺序执行。
    RACSignal *flattenSignal = [sig flatten:3];
    
    [flattenSignal subscribeNext:^(id x) {
        NSLog(@"output: %@", x);
    }];
    
    [subject1 sendNext:@"tt1"];
    [subject2 sendNext:@"tt2"];
    [subject3 sendNext:@"tt3"];
    
    //subject3完成后，会自动将subject4加入到队列中
    [subject3 sendCompleted];
    
    [subject4 sendNext:@"tt4"];
    
    //subject4完成后，会自动将subject5加入到队列中
    [subject4 sendCompleted];
    
    [subject5 sendNext:@"tt5"];
}

- (void)excuteCollect
{
    RACSignal *signal = [@"1 2 3 4 5 6 7 8 9 10" componentsSeparatedByString:@" "].rac_sequence.signal;
    
    NSLog(@"begin excute");
    //打印10次，每次打印一个
    [signal subscribeNext:^(id x) {
        NSLog(@"%@", x);
    }];
    
    //收集好这10输出为一个数组，一起打印
    RACSignal *collectSignal = [[signal
                                 takeLast:5]//输出后5次
                                 //take:5]//输出前5次
                                collect];
    [collectSignal subscribeNext:^(NSArray *x) {
        NSLog(@"collectSignal: %@", x);
    }];
    
    //收集好这10输出为一个数组，分别打印10个输出的数组中的每一个
    RACSignal *flattenMapSignal = [collectSignal flattenMap:^RACStream *(NSArray *value) {
        return value.rac_sequence.signal;
    }];
    [flattenMapSignal subscribeNext:^(id x) {
        NSLog(@"flattenMapSignal : %@", x);
    }];
    
    NSLog(@"end excute");
}

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

    NSLog(@"begin excute");
    
    //会放到下一个runloop循环中输出
    [bufferSignal subscribeNext:^(id x) {
        //tuple
        NSLog(@"signal result: %@", x);
    }];
    
    NSLog(@"end excute");
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
    
    NSLog(@"begin excute");
    
    [signal subscribeNext:^(id x) {
        //会放到下一个runloop循环中输出
        NSLog(@"output 1: %@", x);
    }];
    [signal subscribeNext:^(id x) {
        NSLog(@"output 2: %@", x);
    }];
    
    NSLog(@"end excute");
}

- (void)excuteRepeat
{
    if (!_prototypeModel) {
        _prototypeModel = [LoginViewModel new];
    }

    RACSignal *signal = [[[[_prototypeModel loginRequestSignal] delay:2] repeat] take:10];//每隔2s, 运行10次
    
    NSLog(@"begin excute");
    
    [signal subscribeNext:^(id x) {
        NSLog(@"output: %@", x);
    } error:^(NSError *error) {
        NSLog(@"error: %@", error);
    }];
    
    NSLog(@"end excute");
}


- (void)excuteReplayLast
{
    RACSubject *letters = [RACSubject subject];
    
    RACSignal *replaySignal = [letters
                               //replay];//调用replay后，block会立即执行，以后的subscribe都是返回当前的执行结果。只执行一次。
                               replayLast];//返回上一次block执行的结果
    //replayLazily];//不立即执行，延后到在第一次subscribe之前调用
    
    NSLog(@"begin excute");
    
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
    
    NSLog(@"end excute");
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
    
    NSLog(@"begin excute");
    
    //同步执行
    [replaySignal subscribeNext:^(id x) {
        NSLog(@"output1 : %@", x);
    }];
    
    [replaySignal subscribeNext:^(id x) {
        NSLog(@"output2 : %@", x);
    }];
    
    NSLog(@"end excute");
}

- (void)excuteCombineLatest
{
    RACSubject *subject1 = [RACSubject subject];
    RACSubject *subject2 = [RACSubject subject];

    //combineLatest：合并信号，两个信号都返回后（随后任意一个值发生变化），输出对应的两个信号的最新值，输出： tt2-yy1, tt2-yy2
    //zip：合并信号，两个信号都返回后，对应输出返回值，subject1的第n个返回值对应subject2的第n个返回值，输出： tt1-yy1, tt2-yy2
//    RACSignal *combineSignal = [RACSignal combineLatest:@[subject1, subject2]
//                                                 reduce:^id(NSString *str1, NSString *str2){//删除多余信息
//                                                     return [NSString stringWithFormat:@"%@-%@", str1, str2];
//                                                 }];
    //等价于=====>
//    RACSignal *combineSignal = [[subject1 combineLatestWith:subject2]
//                                reduceEach:^id(NSString *str1, NSString *str2){
//                                    return [NSString stringWithFormat:@"%@-%@", str1, str2];
//                                }];
    
    //等价于=====>
    RACSignal *combineSignal = [[RACSignal combineLatest:@[subject1, subject2]] reduceEach:^id(NSString *str1, NSString *str2){
        return [NSString stringWithFormat:@"%@-%@", str1, str2];
    }] ;
    
    
    //同步执行
    [combineSignal subscribeNext:^(id x) {
        NSLog(@"output: %@", x);
    }];
    
    [subject1 sendNext:@"tt1"];
    [subject1 sendNext:@"tt2"];

    NSLog(@"intter excuteHotSignal");
    
    [subject2 sendNext:@"yy1"];
    [subject2 sendNext:@"yy2"];

    NSLog(@"end excute");
}

- (void)excuteRACSubject
{
    RACSubject *subject = [RACSubject subject];
    
    NSLog(@"begin excute");
    
    //同步执行
    [subject subscribeNext:^(id x) {
        NSLog(@"output: %@", x);
    }];
    
    [subject sendNext:@"tt1"];
    
    NSLog(@"intter excuteHotSignal");

    [subject sendNext:@"tt2"];
    
    NSLog(@"end excute");
}

- (void)excuteThen
{
    RACSignal *signal1 = [@"1 2 3" componentsSeparatedByString:@" "].rac_sequence.signal;
    RACSignal *signal2 = [@"4 5 6" componentsSeparatedByString:@" "].rac_sequence.signal;
    
    NSLog(@"begin excute");
    
    //第一个signal执行完执行第二个signal
    RACSignal *thenSignal = [[signal1
                              doNext:^(NSNumber *x) {//inject method。比如then：会将上一个消息的返回结果忽略，就需要这样一个插入方法来接收被忽略的消息
                                  NSLog(@"signal1 result: %@", x);
                              }] then:^RACSignal *{
                                  return signal2;
                              }];
    
    //会放到下一个runloop循环中输出
    [thenSignal subscribeNext:^(id x) {
        NSLog(@"signal2 result: %@", x);
    }];
    
    NSLog(@"end excute");
}

- (void)excuteConcat
{
    RACSignal *signal1 = [@"1 2 3" componentsSeparatedByString:@" "].rac_sequence.signal;
    RACSignal *signal2 = [@"4 5 6" componentsSeparatedByString:@" "].rac_sequence.signal;
    
    NSLog(@"begin excute");
    
//    RACSignal *concatSignal = [signal1 concat:signal2];//执行完signal1，再执行signal2，输出: 123456
    //等价于====>
    RACSignal *concatSignal = [@[signal1, signal2].rac_sequence.signal concat];//concat信号中的所有信号

    [concatSignal subscribeNext:^(id x) {
        NSLog(@"output: %@", x);
    }];
    
    NSLog(@"end excute");
}

- (void)excuteMerge
{
    RACSignal *signal1 = [@"1 2 3" componentsSeparatedByString:@" "].rac_sequence.signal;
    RACSignal *signal2 = [@"4 5 6" componentsSeparatedByString:@" "].rac_sequence.signal;

    NSLog(@"begin excute");
    
//    RACSignal *mergedSignal1 = [RACSignal merge:@[signal1, signal2]];//合并信号，输出: 415263
    //等价于=====>
    RACSignal *mergedSignal2 = [signal1 merge:signal2];//合并信号，输出: 412536
    
    //会放到下一个runloop循环中输出
    [mergedSignal2 subscribeNext:^(id x) {
        NSLog(@"output: %@", x);
    }];
    
    NSLog(@"end excute");
}

- (void)excuteDistinct
{
    RACSignal *signal = [@"1 2 2 3 3" componentsSeparatedByString:@" "].rac_sequence.signal;
    
    NSLog(@"begin excute");
    
    RACSignal *tokenSignal = [signal distinctUntilChanged];//前后输出值不同
    
    //会放到下一个runloop循环中输出
    [tokenSignal subscribeNext:^(id x) {
        NSLog(@"output: %@", x);
    }];
    
    NSLog(@"end excute");
}

- (void)excuteThrottles
{
    RACSignal *signal = [@"1 2 2 3 3" componentsSeparatedByString:@" "].rac_sequence.signal;
    
    NSLog(@"begin excute");
    
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
    
    NSLog(@"end excute");
}

- (void)excuteSkip
{
    if (!_prototypeModel) {
        _prototypeModel = [LoginViewModel new];
    }
    
    //跳过初始值
    RACSignal *skippedSignal = [RACObserve(self->_prototypeModel, userName) skip:1];//跳过第1次开始执行
    
    NSLog(@"begin excute");
    
    //会放到下一个runloop循环中输出
    [skippedSignal subscribeNext:^(id x) {
        NSLog(@"output: %@", x);
    }];
    
    NSLog(@"end excute");
}

- (void)excuteTake
{
    RACSignal *signal = [@"1 2 3" componentsSeparatedByString:@" "].rac_sequence.signal;
    
    NSLog(@"begin excute");
    
    
    RACSignal *tokenSignal = [signal take:2];//只接收前2次
    
    [tokenSignal subscribeNext:^(id x) {
        //会放到下一个runloop循环中输出
        NSLog(@"output: %@", x);
    }];
    
    NSLog(@"end excute");
}


- (void)excuteFilter
{
    RACSignal *signal = [@"1 2 3" componentsSeparatedByString:@" "].rac_sequence.signal;
    
    NSLog(@"begin excute");
    
    RACSignal *filteredSignal = [signal filter:^BOOL(NSString *value) {//加入过滤条件
        return value.integerValue > 1;
    }];
    
    [filteredSignal subscribeNext:^(id x) {
        //会放到下一个runloop循环中输出
        NSLog(@"output: %@", x);
    }];
    
    NSLog(@"end excute");
}

- (void)excuteMap
{
    RACSignal *signal = [@"1 2 3" componentsSeparatedByString:@" "].rac_sequence.signal;
    
    NSLog(@"begin excute");
    
    //map将一个值转化为另一个值输出
    RACSignal *mappedsSignal = [signal map:^id(NSString *value) {
        return [NSString stringWithFormat:@"%@_%@", value, value];
    }];
    
    [mappedsSignal subscribeNext:^(id x) {
        //会放到下一个runloop循环中输出
        NSLog(@"output: %@", x);
    }];
    
    NSLog(@"end excute");
}

- (void)excuteHotSignal
{
    RACSignal *signal = [@"1 2 3" componentsSeparatedByString:@" "].rac_sequence.signal;
    
    NSLog(@"begin excute");
    
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
    
    NSLog(@"end excute");
}



@end
