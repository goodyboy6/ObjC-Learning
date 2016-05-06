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
    [self excutePublish];
}

#pragma mark - sub example
- (void)needExcute
{
    /*
    - (id)first;
    
    /// Returns the first `next` or `defaultValue` if the signal completes or errors
    /// without sending a `next`. Note that this is a blocking call.
    - (id)firstOrDefault:(id)defaultValue;
    
    /// Returns the first `next` or `defaultValue` if the signal completes or errors
    /// without sending a `next`. If an error occurs success will be NO and error
    /// will be populated. Note that this is a blocking call.
    ///
    /// Both success and error may be NULL.
    - (id)firstOrDefault:(id)defaultValue success:(BOOL *)success error:(NSError **)error;
    
    /// Blocks the caller and waits for the signal to complete.
    ///
    /// error - If not NULL, set to any error that occurs.
    ///
    /// Returns whether the signal completed successfully. If NO, `error` will be set
    /// to the error that occurred.
    - (BOOL)waitUntilCompleted:(NSError **)error;

     /// Adds every `next` to an array. Nils are represented by NSNulls. Note that
     /// this is a blocking call.
     ///
     /// **This is not the same as the `ToArray` method in Rx.** See -collect for
     /// that behavior instead.
     ///
     /// Returns the array of `next` values, or nil if an error occurs.
     - (NSArray *)toArray;

     /// Adds every `next` to a sequence. Nils are represented by NSNulls.
     ///
     /// This corresponds to the `ToEnumerable` method in Rx.
     ///
     /// Returns a sequence which provides values from the signal as they're sent.
     /// Trying to retrieve a value from the sequence which has not yet been sent will
     /// block.
     @property (nonatomic, strong, readonly) RACSequence *sequence;
     */
}

#pragma mark - publish multicast:
- (void)excutePublish
{
    //http://www.jianshu.com/p/a0a821a2480f
    //当一个connection建立之后，这个signal就是hot的，在订阅之前已经处于活动状态。
    
    RACSignal *signal = [[RACSignal return:@"hello" ] doNext:^ (id nextValue) {
        NSLog(@"nextValue:%@", nextValue);
    }];
    
    
//    [signal subscribeNext:^(id x) {
//        NSLog(@"x %@", x);
//    }];
//    [signal subscribeNext:^(id x) {
//        NSLog(@"xx %@", x);
//    }];
    //output
//    2016-04-28 17:00:33.832 ReactiveCocoaDemo[21710:1551589] nextValue:hello
//    2016-04-28 17:00:33.833 ReactiveCocoaDemo[21710:1551589] x hello
//    2016-04-28 17:00:33.833 ReactiveCocoaDemo[21710:1551589] nextValue:hello
//    2016-04-28 17:00:33.833 ReactiveCocoaDemo[21710:1551589] xx hello
    
//    RACMulticastConnection *connection = [signal publish];
//    [connection.signal subscribeNext:^(id nextValue) {
//        NSLog(@"First %@", nextValue);
//    }];
//    [connection.signal subscribeNext:^(id nextValue) {
//        NSLog(@"Second %@", nextValue);
//    }];
//    [connection connect];
    //output
//    2016-04-28 17:00:33.833 ReactiveCocoaDemo[21710:1551589] nextValue:hello
//    2016-04-28 17:00:33.833 ReactiveCocoaDemo[21710:1551589] First hello
//    2016-04-28 17:00:33.834 ReactiveCocoaDemo[21710:1551589] Second hello

//    RACMulticastConnection *connection = [signal multicast:[RACReplaySubject subject]];//多播    //等价于==>replay
//    [connection connect];
//    [connection.signal subscribeNext:^(id nextValue) {
//        NSLog(@"First %@", nextValue);
//    }];
//    [connection.signal subscribeNext:^(id nextValue) {
//        NSLog(@"Second %@", nextValue);
//    }];
    
    RACMulticastConnection *connection = [signal multicast:[RACReplaySubject subject]];//多播    //等价于==>replay
    RACSignal *connectionSignal = [connection autoconnect];
    [connectionSignal subscribeNext:^(id nextValue) {
        NSLog(@"First %@", nextValue);
    }];
    [connectionSignal subscribeNext:^(id nextValue) {
        NSLog(@"Second %@", nextValue);
    }];

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

#pragma mark -
- (void)excuteFlattenMap
{
    RACSignal *signal1 = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:@"signal 1"];
        return nil;
    }];
    
    [[signal1 flattenMap:^RACStream *(id value) {
        return [RACSignal return:value];
    }] subscribeNext:^(id x) {
        NSLog(@"%@", x);
    }];
    
    //等价于===>
    [[signal1 flatten] subscribeNext:^(id x) {
        NSLog(@"%@", x);
    }];
}

- (void)excuteStartEagerly
{
    RACSignal *lazilySignal = [RACSignal startLazilyWithScheduler:[RACScheduler mainThreadScheduler] block:^(id<RACSubscriber> subscriber) {
        [subscriber sendNext:@"lazilySignal"];
    }];

    RACSignal *eagerlySignal = [RACSignal startEagerlyWithScheduler:[RACScheduler mainThreadScheduler] block:^(id<RACSubscriber> subscriber) {
        [subscriber sendNext:@"eagerlySignal"];
    }];
    
    [lazilySignal subscribeNext:^(id x) {
        NSLog(@"%@", x);
    }];
    
    [eagerlySignal subscribeNext:^(id x) {
        NSLog(@"%@", x);
    }];
}

- (void)excuteAnd
{
    RACSignal *repeatSignal = [[[[[[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:@(YES)];
        [subscriber sendNext:@(6)];
        [subscriber sendCompleted];
        return nil;
    }] delay:1]
                                  repeat]
                                 take:2]
                                bufferWithTime:5 onScheduler:[RACScheduler mainThreadScheduler]]
                                or];//对所有bool作or／and操作

    [repeatSignal subscribeNext:^(id x) {
        NSLog(@"%@", x);
    }];
}

- (void)excuteSample
{
    if (!_prototypeModel) {
        _prototypeModel = [LoginViewModel new];
    }

    RACSignal *repeatSignal = [[[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:[NSDate date]];
        [subscriber sendCompleted];
        return nil;
    }] delay:1] repeat];//每隔1s发送一次数据
    
    RACSignal *loginSignal = [_prototypeModel loginRequestSignal2];//两次数据发送的间隔为1s
    
    //loginSignal接收到第1个值时，输出repeatSignal的当前最新值，当loginSignal收到第2个值时，输出repeatSignal的当前最新值
    RACSignal *sampleSignal = [repeatSignal sample:loginSignal];
    [sampleSignal subscribeNext:^(id x) {
        NSLog(@"%@", x);
    }];
    
    RACSignal *igonoreSignal = [[[_prototypeModel loginRequestSignal]
                                ignoreValues]//忽略返回值，订阅方接受不到数据
                                materialize];//将signal的返回值转换为RACEvent类型，此时由于不考虑具体的返回值，因此可以ignoreValues
    [[igonoreSignal filter:^BOOL(RACEvent *value) {
        return value.eventType == RACEventTypeCompleted;
    }] subscribeNext:^(id x) {
        NSLog(@"igonoreSignal: %@", x);
    }];
}

- (void)excuteRetry
{
    if (!_prototypeModel) {
        _prototypeModel = [LoginViewModel new];
    }
    
    RACSignal *signal2 = [_prototypeModel loginRequestErrorSignal];
    
    //共请求 2+1 次
    [[signal2 retry:2] subscribeNext:^(id x) {
        NSLog(@"subscribeNext: %@", x);
    } error:^(NSError *error) {
        NSLog(@"error: %@", error);
    }];
}

- (void)excuteAny
{
    if (!_prototypeModel) {
        _prototypeModel = [LoginViewModel new];
    }
    
    RACSignal *signal2 = [_prototypeModel loginRequestSignal];
    RACSignal *signal1 = [_prototypeModel loginRequestSignal2];
    
    RACSignal *signal3 = @[signal2, signal1].rac_sequence.signal;

    
    //如果获取数据成功，则返回yes，否则返回no
    [[[signal3 flattenMap:^RACStream *(id value) {
        return value;
    }]
//       doNext:^(id x) {
//           NSLog(@"doNext: %@", x);
//       }]
      //any]//any后输出YES
//      any:^BOOL(id object) {//有任意一个返回值为YES，则输出YES，anyBlock不再继续接收输出值
//          NSLog(@"all: %@", object);
//          if ([object[@"sex"] integerValue] == 1) {
//              return NO;
//          }
//          return YES;//对应subscribeNext的输出值
//      }]
     all:^BOOL(id object) {////有任意一个返回值为NO，则输出NO，allBlock不再继续接收输出值
         NSLog(@"all: %@", object);
         if ([object[@"sex"] integerValue] == 1) {
             return NO;
         }
         return YES;//对应subscribeNext的输出值
     }]
     subscribeNext:^(id x) {
         NSLog(@"subscribeNext: %@", x);
     } error:^(NSError *error) {
         NSLog(@"error : %@", error);
     }];

}


- (void)excuteGroup
{
    if (!_prototypeModel) {
        _prototypeModel = [LoginViewModel new];
    }
    
    RACSignal *signal2 = [_prototypeModel loginRequestSignal2];

    [[signal2 groupBy:^id<NSCopying>(id object) {
        return @"ttt";//object[@"userName"];//进行分组的key值，不同的key值返回不同的RACGroupedSignal，相同的key值返回相同的RACGroupedSignal
    } transform:^id(id object) {
        return object;//返回包含返回值的RACGroupedSignal
    }]  subscribeNext:^(RACGroupedSignal *x) {
        //object[@"userName"] 不同值。当前block连续走两次
        NSLog(@"%@", x);
        //return @"ttt"; 相同值。以下subscribeNext block将会连续走2次
        [x subscribeNext:^(id x2) {
            NSLog(@"%@", x2);
        }];
    }];
}


- (void)excuteDeliver
{
    if (!_prototypeModel) {
        _prototypeModel = [LoginViewModel new];
    }
    
    RACSignal *signal = [_prototypeModel loginRequestSignal];

//    RACSignal *subscribeOnSignal = [[signal subscribeOn:[RACScheduler scheduler]] map:^id(id value) {
//        NSLog(@"map : %@", [RACScheduler currentScheduler]);
//        return value;
//    }];
//    
//    [subscribeOnSignal subscribeNext:^(id x) {
//        NSLog(@"subscribeNext : %@", [RACScheduler currentScheduler]);
//    }];
    RACSignal *scheduledSignal = [[[[[signal
                                     deliverOn:[RACScheduler scheduler]]//将后续操作放在background线程上
                                    doNext:^(id x) {
                                        NSLog(@"doNext scheduler : %@", [RACScheduler currentScheduler]);
                                    }]
                                    map:^id(id value) {
                                        NSLog(@"scheduler : %@", [RACScheduler currentScheduler]);
                                        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:value options:NSJSONWritingPrettyPrinted error:nil];
                                        return jsonData;
                                    }]
                                   deliverOn:[RACScheduler mainThreadScheduler]]//将filter操作放在main线程上
                                  filter:^BOOL(id value) {
                                      NSLog(@"scheduler : %@", [RACScheduler currentScheduler]);
                                      return value ? YES : NO;
                                  }];//将输出放在background线程上
    
    [scheduledSignal subscribeNext:^(id x) {
        NSLog(@"scheduler putout: %@", [RACScheduler currentScheduler]);
        NSLog(@"result : %@", x);
    }];
}

- (void)excuteTimeOut
{
    if (!_prototypeModel) {
        _prototypeModel = [LoginViewModel new];
    }
    
    RACSignal *signal = [_prototypeModel loginRequestSignal2];
    
    //设置0.1s超时
    RACSignal *timeoutSignal = [signal timeout:.1 onScheduler:[RACScheduler mainThreadScheduler]];
    
    [timeoutSignal subscribeNext:^(id x) {
        NSLog(@"intime : %@", x);
    } error:^(NSError *error) {
        NSLog(@"timeout: %@", error);
    }];
}

#pragma mark -
- (void)excuteIfElse
{
    if (!_prototypeModel) {
        _prototypeModel = [LoginViewModel new];
    }
    
    RACSignal *boolSignal = [_prototypeModel loginRequestBoolSignal];
    
    RACSignal *thenSignal = [_prototypeModel loginRequestSignal];
    RACSignal *elseSignal = [_prototypeModel loginRequestErrorSignal];
    
    RACSignal *ifElseSignal = [RACSignal if:boolSignal then:thenSignal else:elseSignal];
    
    [ifElseSignal subscribeNext:^(id x) {
        NSLog(@"thenSignal : %@", x);
    } error:^(NSError *error) {
        NSLog(@"elseSignal %@", error);
    }];
}

- (void)excuteSwitchCaseDefault
{
    if (!_prototypeModel) {
        _prototypeModel = [LoginViewModel new];
    }
    
    RACSignal *keySignal = [_prototypeModel loginRequestStringSignal];
    
    RACSignal *valueSignal = [_prototypeModel loginRequestSignal];
    NSDictionary *dic = @{@"ttt": valueSignal};
    
    RACSignal *defaultSignal = [_prototypeModel loginRequestErrorSignal];
    
    //如果dic中的key值中包含keySignal的输出值，则订阅dic中对应的valueSignal；否则，订阅defaultSignal
    RACSignal *switchCaseSignal = [RACSignal switch:keySignal cases:dic default:defaultSignal];
    
    [switchCaseSignal subscribeNext:^(id x) {
        NSLog(@"valueSignal : %@", x);
    } error:^(NSError *error) {
        NSLog(@"defaultSignal %@", error);
    }];
}

- (void)excuteSwitchToLatest
{
    if (!_prototypeModel) {
        _prototypeModel = [LoginViewModel new];
    }
    
    RACSignal *loginSignal = [_prototypeModel loginRequestSignal];
    RACSignal *loginSignal1 = [_prototypeModel loginRequestSignal1];
    RACSignal *loginSignal2 = [_prototypeModel loginRequestSignal2];

    //忽略之前的信号输出，只输出最晚输出的那个
    RACSignal *switchSignal = [@[loginSignal, loginSignal1, loginSignal2].rac_sequence.signal switchToLatest];
    
    //只会输出loginSignal2的输出值
    [switchSignal subscribeNext:^(id x) {
        NSLog(@"switchSignal : %@", x);
    }];
}

#pragma mark -
- (void)excuteDefer
{
    if (!_prototypeModel) {
        _prototypeModel = [LoginViewModel new];
    }
    
    /// 将信号的创建延迟到信号被真正订阅的时候
    /// This can be used to effectively turn a hot signal into a cold signal.
    RACSignal *deferSignal = [RACSignal defer:^RACSignal *{
        return [_prototypeModel loginRequestErrorSignal];
    }];
    
    NSLog(@"begin excute");
    
    [deferSignal subscribeNext:^(id x) {
        NSLog(@"deferSignal: %@", x);
    } error:^(NSError *error) {
        NSLog(@"deferSignal error:%@", error);
    }];
    
    NSLog(@"end excute");
}

- (void)excuteTryBlock
{
    if (!_prototypeModel) {
        _prototypeModel = [LoginViewModel new];
    }
    
    RACSignal *loginSignal = [_prototypeModel loginRequestSignal];
    
    //是否输出返回的数据
    //如果登录成功，并且返回的数据存储成功，输出数据YES；否则提示报错NO。
    RACSignal *tryBlockSignal = [loginSignal try:^BOOL(id value, NSError *__autoreleasing *errorPtr) {
        if ([value isKindOfClass:[NSDictionary class]]) {
            NSString *homePath = NSHomeDirectory();
            return [[NSData data] writeToFile:homePath options:NSDataWritingAtomic error:errorPtr];
        }
        return NO;
    }];
    
    
    //返回的数据将会被解析成什么样的数据输出
    //如果登录成功，并且数据解析正确，输出解析后的数据；否则报错NO
    RACSignal *tryMapBlockSignal = [loginSignal tryMap:^id(id value, NSError *__autoreleasing *errorPtr) {
        if([value isKindOfClass:[NSDictionary class]]){
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:value options:NSJSONWritingPrettyPrinted error:errorPtr];
            NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            return jsonString;
        }
        return nil;
    }];

    NSLog(@"begin excute");
    
    [tryBlockSignal subscribeNext:^(id x) {
        NSLog(@"tryBlock: %@", x);
    } error:^(NSError *error) {
        NSLog(@"tryBlockSignal error:%@", error);
    }];
    
    [tryMapBlockSignal subscribeNext:^(id x) {
        NSLog(@"map block: %@", x);
    } error:^(NSError *error) {
        NSLog(@"map block error:%@", error);
    }];

    
    NSLog(@"end excute");
}

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
    
    //等价于===>
//    RACSignal *catchErrorSignal = [loginSignal catchTo:@[ @1, @2, @3, @4 ].rac_sequence.signal];

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
                                collect];//收集
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
