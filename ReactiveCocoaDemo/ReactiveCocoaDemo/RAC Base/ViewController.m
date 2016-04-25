//
//  ViewController.m
//  ReactiveCocoaDemo
//
//  Created by yixiaoluo on 16/4/20.
//  Copyright © 2016年 yixiaoluo. All rights reserved.
//

#import "ViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "LoginViewModel+RACCommand.h"
#import "Examples.h"

static NSInteger const kMinUserNameLength = 5;
static NSInteger const kMinPasswordLength = 6;

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITextField *userNameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

@property (nonatomic) LoginViewModel *loginViewModel;

@property (nonatomic) Examples *examples;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self bandingAction];
    [self bandingData];
    
    //examples
    self.examples = [Examples new];
    [self.examples excuteExamples];
}

- (LoginViewModel *)loginViewModel
{
    if (!_loginViewModel) {
        _loginViewModel = [LoginViewModel new];
    }
    return _loginViewModel;
}

- (void)bandingData
{
    RACSignal *userNameSignal = self.userNameField.rac_textSignal;
    RACSignal *passwordSignal = self.passwordField.rac_textSignal;
    
    //http://limboy.me/ios/2013/06/19/frp-reactivecocoa.html
    //banding viewModel data with user interface
    RAC(self.loginViewModel, userName) = [[[[[[[userNameSignal
                                            deliverOn:[RACScheduler scheduler]]//创建一个新的 signals 信号对象,以在将map操作放到其他队列来处理他们的任务
                                            map:^id(NSString *value) {//map将一个值转化为另一个值输出
                                                return [value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                                            }]
                                             throttle:0.5]// 返回0.5s间隔内收到的最新值
                                            distinctUntilChanged]//要求输出前后的值不同
                                            deliverOn:RACScheduler.mainThreadScheduler]//后续操作切换到主线程完成
                                            startWith:@"kitty"]// startWith 一开始返回的初始值
                                            filter:^BOOL(id value) {//filter使满足条件的值才能传出
                                               return YES;
                                            }];
    
    RAC(self.loginViewModel, password) = passwordSignal;
}

- (void)bandingAction
{
//    //方法1-------
//    //loginButton touch action signal
//    @weakify(self);
//    [[[[self.loginButton rac_signalForControlEvents:UIControlEventTouchUpInside]
//      doNext:^(id x) {//
//          @strongify(self);
//          self.loginButton.enabled = NO;
//      }]
//#warning !!!! flattenMap: difference with map:
//      flattenMap:^RACStream *(id value) {//flattenMap subscribe to the returned singnal
//        @strongify(self);
//        return [self.loginViewModel loginRequestSignal];
//    }] subscribeNext:^(id x) {
//        self.loginButton.enabled = YES;
//        NSLog(@"login success? : %@", x);
//    }];
    
    //方法2=========
    //banding loginButton status with view model
    RACSignal *enabledSignal = [[RACSignal combineLatest:@[RACObserve(self.loginViewModel, userName), RACObserve(self.loginViewModel, password)]
                                                  reduce:^id(NSString *userName, NSString *password){//删除多余信息
                                                      return @(userName.length >= kMinUserNameLength && password.length >= kMinPasswordLength);
                                                  }]
                                startWith:@(NO)];//startWith 一开始返回的初始值
    @weakify(self);
    RACCommand *command = [[RACCommand alloc] initWithEnabled:enabledSignal signalBlock:^RACSignal *(id input) {
        @strongify(self);
        return [self.loginViewModel loginRequestSignal];
    }];
    [[command.executionSignals flattenMap:^RACStream *(id value) {//flattenMap subscribe to the returned singnal
        return value;
    }] subscribeNext:^(id x) {
        NSLog(@"command.executionSignals : %@", x);
    }];
    
    self.loginButton.rac_command = command;
}

@end
