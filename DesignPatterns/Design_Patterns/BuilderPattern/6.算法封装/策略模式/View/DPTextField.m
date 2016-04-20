//
//  DPTextField.m
//  Design_Patterns
//
//  Created by yixiaoluo on 15/9/2.
//  Copyright (c) 2015年 yixiaoluo. All rights reserved.
//

#import "DPTextField.h"

@implementation DPTextField

- (BOOL)validate
{
    NSError *error;
    BOOL validate = [self.inputValidator validateInput:self error:&error];
    if (!validate) {
        [[[UIAlertView alloc] initWithTitle:error.localizedDescription
                                    message:error.localizedFailureReason
                                   delegate:self
                          cancelButtonTitle:@"确定"
                          otherButtonTitles:nil, nil]
         show];
        return NO;
    }
    
    return validate;
}

@end
