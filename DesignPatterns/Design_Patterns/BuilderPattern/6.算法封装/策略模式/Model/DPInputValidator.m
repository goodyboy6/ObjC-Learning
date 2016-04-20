//
//  DPInputValidator.m
//  Design_Patterns
//
//  Created by yixiaoluo on 15/9/2.
//  Copyright (c) 2015年 yixiaoluo. All rights reserved.
//

#import "DPInputValidator.h"

@implementation DPInputValidator

- (BOOL)validateInput:(UITextField *)input error:(NSError **)error
{
    if (error) {
        *error = nil;
    }
    
    return NO;
}

@end
