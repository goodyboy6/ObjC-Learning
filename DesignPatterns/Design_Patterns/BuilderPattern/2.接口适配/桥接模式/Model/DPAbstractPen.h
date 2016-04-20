//
//  DPAbstractPen.h
//  Design_Patterns
//
//  Created by yixiaoluo on 15/9/24.
//  Copyright © 2015年 yixiaoluo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DPShape.h"

@interface DPAbstractPen : NSObject

- (void)draw:(DPShape *)shape;

@end

@interface DPPen : DPAbstractPen

@end

@interface DPPencil : DPAbstractPen

@end