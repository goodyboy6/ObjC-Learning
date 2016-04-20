//
//  DPCharaterInputValidator.m
//  Design_Patterns
//
//  Created by yixiaoluo on 15/9/2.
//  Copyright (c) 2015年 yixiaoluo. All rights reserved.
//

#import "DPCharaterInputValidator.h"

@implementation DPCharaterInputValidator

- (BOOL)validateInput:(UITextField *)input error:(NSError **)error
{
    NSError *regError = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"^[a-zA-Z]*$" options:NSRegularExpressionAnchorsMatchLines error:&regError];
    NSUInteger numberOfMatched = [regex numberOfMatchesInString:input.text options:NSMatchingAnchored range:NSMakeRange(0, [input.text length])];
    if (numberOfMatched == 0) {
        NSString *description = NSLocalizedString(@"Input invalidation failure", nil);
        NSString *reason = NSLocalizedString(@"The inpit can contain only letters", nil);
        *error = [NSError errorWithDomain:InputInvalidationErrorDomain code:1002 userInfo:@{
                                                                                            NSLocalizedDescriptionKey: description,
                                                                                            NSLocalizedFailureReasonErrorKey:reason
                                                                                            }];
        return NO;
    }
    
    return YES;
}

@end
