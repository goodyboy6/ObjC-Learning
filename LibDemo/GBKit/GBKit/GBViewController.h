//
//  GBViewController.h
//  GBKit
//
//  Created by yixiaoluo on 15/12/7.
//  Copyright © 2015年 yixiaoluo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GBViewController : UIViewController

@property (nonatomic, copy) UIImage *(^imageInGBKit)(GBViewController *vc);

@end
