//
//  DPShape.h
//  Design_Patterns
//
//  Created by yixiaoluo on 15/9/24.
//  Copyright © 2015年 yixiaoluo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DPShape : NSObject

- (void)draw;

@end

@interface DPLine : DPShape

@end

@interface DPCycle: DPShape

@end

@interface DPPoint: DPShape

@end



