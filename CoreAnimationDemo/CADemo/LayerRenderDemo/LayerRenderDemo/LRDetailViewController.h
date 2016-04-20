//
//  DetailViewController.h
//  LayerRenderDemo
//
//  Created by yixiaoluo on 15/11/19.
//  Copyright © 2015年 yixiaoluo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LRDetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;
@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@end

