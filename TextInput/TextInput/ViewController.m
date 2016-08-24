//
//  ViewController.m
//  TextInput
//
//  Created by yixiaoluo on 16/6/15.
//  Copyright © 2016年 yixiaoluo. All rights reserved.
//

#import "ViewController.h"
#import "UIViewController+WBTextInput.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
}

- (IBAction)input:(id)sender {
    [self beginTextInputWithLayout:[TextInputLayout new] resultHandler:^(NSString *text, BOOL isCancel, void (^dismissKeyboardHandler)(BOOL dismiss)) {
        NSLog(@"success: %@: %@", @(isCancel), text);
        dismissKeyboardHandler(YES);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}

@end
