//
//  DPThunmbnailCell.h
//  Design_Patterns
//
//  Created by yixiaoluo on 15/9/8.
//  Copyright (c) 2015年 yixiaoluo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DPThumbnailProxy.h"

@interface DPThunmbnailCell : UICollectionViewCell

@property (nonatomic, weak) id<DPThumbnailProxyProtocol> delegate;
@property (nonatomic) IBOutlet DPThumbnailProxy *thunmbnailProxy;

@end
