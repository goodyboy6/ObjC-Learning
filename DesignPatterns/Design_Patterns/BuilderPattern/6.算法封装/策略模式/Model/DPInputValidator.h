//
//  DPInputValidator.h
//  Design_Patterns
//
//  Created by yixiaoluo on 15/9/2.
//  Copyright (c) 2015年 yixiaoluo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

static NSString *const InputInvalidationErrorDomain = @"InputInvalidationErrorDomain";

@interface DPInputValidator : NSObject

- (BOOL)validateInput:(UITextField *)input error:(NSError **)error;

@end
