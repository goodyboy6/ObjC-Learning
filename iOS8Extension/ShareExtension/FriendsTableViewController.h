//
//  FriendsTableViewController.h
//  iOS8Extension
//
//  Created by yixiaoluo on 2016/8/22.
//  Copyright © 2016年 yixiaoluo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FriendsTableViewController : UITableViewController

@property (nonatomic, copy) void(^didFinishedSelectItemHandler)(NSString *item);

@end
