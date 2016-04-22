//
//  ObjCViewController.m
//  JSPatchSwiftTest
//
//  Created by yixiaoluo on 16/4/20.
//  Copyright © 2016年 yixiaoluo. All rights reserved.
//

#import "ObjCViewController.h"
#import "JSPatchSwiftTest-Swift.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

static NSUInteger const kUserNameMinLength = 3;
static NSUInteger const kPasswordMinLength = 6;


@interface ObjCViewController ()

@property (weak, nonatomic) IBOutlet UITextField *userNameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;

@property (weak, nonatomic) IBOutlet UIButton *loginButton;

@end

@implementation ObjCViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //JSPatch to change kPasswordMinLength to 2
    RACSignal *userNameFieldSignal = [self.userNameField rac_textSignal];
    RACSignal *passwordFieldSignal = [self.passwordField rac_textSignal];

    RACSignal *enableSignal = [RACSignal combineLatest:@[userNameFieldSignal, passwordFieldSignal] reduce:^id(NSString *useName, NSString *password){
        BOOL enable = useName.length >= kUserNameMinLength && password.length >= kPasswordMinLength;
        return @(enable);
    }];

    RAC(self.loginButton, enabled) = enableSignal;
    //equal to ==>
    //[[[RACSubscriptingAssignmentTrampoline alloc] initWithTarget:self.loginButton nilValue:@0] setObject:enableSignal forKeyedSubscript:@"enabled"];
    
    @weakify(self);
    [RACObserve(self.loginButton, enabled)  subscribeNext:^(NSNumber *x) {
        @strongify(self);
        if (x.boolValue) {
            [self dismissViewControllerAnimated:YES completion:NULL];
        }
    }];
    //equal to ==>
//    [[(id)(self.loginButton) rac_valuesForKeyPath:@"enabled" observer:self] subscribeNext:^(NSNumber *x) {
//        @strongify(self);
//        if (x.boolValue) {
//          [self dismissViewControllerAnimated:YES completion:NULL];
//        }
//    }];
    
    
    
    //difference between filter and map ??
    [[[RACObserve(self.userNameField, text) filter:^BOOL(NSString *value) {
        return [value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }] map:^id(id value) {
        return value;
    }] subscribeNext:^(id x) {
        NSLog(@"userName did changed: %@", x);
    }];

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    NSLog(@"%@", [self getNameAsync]);
}

- (void)dealloc
{
    NSLog(@"%@ %s", NSStringFromSelector(_cmd), __FILE__);
}

//JSPatch to change the return value
- (NSString *)getNameAsync {
    return @"Origin ObjCViewController";
}

- (void)printV:(id)obj {
    NSLog(@"text from js: %@", obj);
}

@end
