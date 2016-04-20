//
//  DPStrategyViewController.m
//  Design_Patterns
//
//  Created by yixiaoluo on 15/9/2.
//  Copyright (c) 2015年 yixiaoluo. All rights reserved.
//

#import "DPStrategyViewController.h"
#import "DPTextField.h"
#import "DPCharaterInputValidator.h"
#import "DPNumberInputValidator.h"

@interface DPStrategyViewController ()
<
UITextFieldDelegate
>

@property (weak, nonatomic) IBOutlet DPTextField *numberTextField;
@property (weak, nonatomic) IBOutlet DPTextField *characterTextField;

@end

@implementation DPStrategyViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.numberTextField.inputValidator = [DPNumberInputValidator new];
    self.characterTextField.inputValidator = [DPCharaterInputValidator new];
}


- (BOOL)textFieldShouldReturn:(DPTextField *)textField
{
    if ([textField validate]) {
        return NO;
    }
    return YES;
}
@end
