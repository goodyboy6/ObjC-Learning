//
//  FriendsTableViewController.m
//  iOS8Extension
//
//  Created by yixiaoluo on 2016/8/22.
//  Copyright © 2016年 yixiaoluo. All rights reserved.
//

#import "FriendsTableViewController.h"

@interface FriendsTableViewController ()

@property (nonatomic) NSArray *titlesArray;

@end

@implementation FriendsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    self.tableView.rowHeight = 46;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"tt"];

    self.title = @"发送";
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.titlesArray = @[
                         @"发送给朋友",
                         @"分享到朋友圈",
                         @"收藏"
                         ];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titlesArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tt" forIndexPath:indexPath];
    
    // Configure the cell...
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = self.titlesArray[indexPath.row];
    cell.textLabel.textColor = [UIColor purpleColor];
    cell.imageView.image = [UIImage imageNamed:@"iMac-icon"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.didFinishedSelectItemHandler) {
        self.didFinishedSelectItemHandler(self.titlesArray[indexPath.row]);
    }
}

@end
