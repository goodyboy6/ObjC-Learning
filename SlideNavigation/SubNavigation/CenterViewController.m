//
//  CenterViewController.m
//  SubNavigation
//
//  Created by yixiaoluo on 16/4/1.
//  Copyright © 2016年 alibaba.com. All rights reserved.
//

#import "CenterViewController.h"

@implementation CenterViewController

#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"%@_%@", NSStringFromClass(self.class), NSStringFromSelector(_cmd));
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"tt"];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"%@_%@", NSStringFromClass(self.class), NSStringFromSelector(_cmd));
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSLog(@"%@_%@", NSStringFromClass(self.class), NSStringFromSelector(_cmd));
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    NSLog(@"%@_%@", NSStringFromClass(self.class), NSStringFromSelector(_cmd));
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    NSLog(@"%@_%@", NSStringFromClass(self.class), NSStringFromSelector(_cmd));
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.navigationController pushViewController:[[self.class alloc] init] animated:YES];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tt" forIndexPath:indexPath];
    
    cell.textLabel.text = [[NSDate date] description];
    cell.detailTextLabel.text = @"click here";
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}



@end
