//
//  DPTextField.h
//  Design_Patterns
//
//  Created by yixiaoluo on 15/9/2.
//  Copyright (c) 2015年 yixiaoluo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DPInputValidator.h"


@interface DPTextField : UITextField

@property (nonatomic, strong) DPInputValidator *inputValidator;

- (BOOL)validate;

@end
