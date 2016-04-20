//
//  LoadView.m
//  NSLockTest
//
//  Created by yixiaoluo on 15/4/21.
//  Copyright (c) 2015年 cn.gikoo. All rights reserved.
//

#import "LoadView.h"

@implementation LoadView

- (void)loadView
{
    NSLog(@"%@ - %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    self.view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSLog(@"%@ - %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    
    IamAPurpleView *purpleView = [[IamAPurpleView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
    purpleView.backgroundColor = [[UIColor purpleColor] colorWithAlphaComponent:1];
    purpleView.tag = 101;
    
    IamABlueView *blueView = [[IamABlueView alloc] initWithFrame:CGRectMake(100, 100, 200, 200)];
    blueView.backgroundColor = [[UIColor blueColor] colorWithAlphaComponent:1];
    blueView.tag = 102;

    [self.view addSubview:purpleView];
    [self.view addSubview:blueView];
    
    HilightBorderTextField *textField = [[HilightBorderTextField alloc] initWithFrame:CGRectMake(150, 150, 200, 40)];
    textField.backgroundColor = [UIColor whiteColor];
    textField.leftViewMode = UITextFieldViewModeAlways;
    textField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    textField.tag = 103;
    [self.view addSubview:textField];
}

- (void)viewDidAppear:(BOOL)animated
{
    //[[self.view viewWithTag:103] becomeFirstResponder];
}

@end


@implementation IamABlueView

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"%@ - %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    NSLog(@"next responder : %@", self.nextResponder);
}

@end

@implementation IamAPurpleView

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"%@ - %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
}

@end

@implementation HilightBorderTextField

- (BOOL)becomeFirstResponder
{
    self.leftViewMode = UITextFieldViewModeAlways;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 10)];
    view.alpha = .3;
    self.leftView = view;

    self.layer.borderColor = [UIColor redColor].CGColor;
    self.layer.borderWidth = 3;
    self.layer.masksToBounds = YES;
    
    return [super becomeFirstResponder];
}

- (BOOL)resignFirstResponder
{
    self.layer.borderWidth = 0;
    
    return [super resignFirstResponder];
}
@end