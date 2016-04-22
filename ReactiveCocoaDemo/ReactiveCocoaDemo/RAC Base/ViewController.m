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

static NSInteger const kMinUserNameLength = 5;
static NSInteger const kMinPasswordLength = 6;

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITextField *userNameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

@property (nonatomic) LoginViewModel *loginViewModel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self bandingAction];
    [self bandingUI];
}

- (LoginViewModel *)loginViewModel
{
    if (!_loginViewModel) {
        _loginViewModel = [LoginViewModel new];
    }
    return _loginViewModel;
}

- (void)bandingUI
{
    RACSignal *userNameSignal = self.userNameField.rac_textSignal;
    RACSignal *passwordSignal = self.passwordField.rac_textSignal;
    
    //http://limboy.me/ios/2013/06/19/frp-reactivecocoa.html
    //banding viewModel data with user interface
    RAC(self.loginViewModel, userName) = [[[[[[userNameSignal
                                            deliverOn:[RACScheduler scheduler]]//创建一个新的 signals 信号对象,以在将map操作放到其他队列来处理他们的任务
                                            map:^id(NSString *value) {//map将一个值转化为另一个值输出
                                                return [value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                                            }]
                                            deliverOn:RACScheduler.mainThreadScheduler]//切换为主线程完成
                                            distinctUntilChanged]//要求输出前后的值不同
                                            startWith:@"kitty"]// startWith 一开始返回的初始值
                                            filter:^BOOL(id value) {//filter使满足条件的值才能传出
                                               return YES;
                                            }];
    
    RAC(self.loginViewModel, password) = passwordSignal;
    
    //banding loginButton status with view model
    [[[RACSignal combineLatest:@[RACObserve(self.loginViewModel, userName), RACObserve(self.loginViewModel, password)]
                        reduce:^id(NSString *userName, NSString *password){//删除多余信息
                            return @(userName.length >= kMinUserNameLength && password.length >= kMinPasswordLength);
                        }]
     startWith:@(NO)]//startWith 一开始返回的初始值
     subscribeNext:^(NSNumber *x) {
         self.loginButton.enabled = x.boolValue;
     }];
    
    
    [RACObserve(self.loginButton, enabled) subscribeNext:^(id x) {
        NSLog(@"%@", x);
    }];
}

- (void)bandingAction
{
    //方法1-------
    //loginButton touch action signal
//    @weakify(self);
//    [[self.loginButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
//        @strongify(self);
//        [self.loginViewModel login];
//    }];
    
    //方法2=========
    //内部会将loginButton.enabled置为YES
    RACCommand *loginCommand = [self.loginViewModel loginCommand];
    self.loginButton.rac_command = loginCommand;
}

@end
