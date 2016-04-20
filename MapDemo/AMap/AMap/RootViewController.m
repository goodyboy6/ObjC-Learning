//
//  RootViewController.m
//  AMap
//
//  Created by yixiaoluo on 16/4/12.
//  Copyright © 2016年 yixiaoluo. All rights reserved.
//

#import "RootViewController.h"

static NSString *cellId = @"amap cell";

typedef enum : NSUInteger {
    AMapTestContentTypeTrackingMode,
    AMapTestContentTypeSearching,
    AMapTestContentTypeRoute,
    AMapTestContentTypeCount
} AMapTestContentType;

NSString *const AMapTestContentTypeText[] = {
    [AMapTestContentTypeTrackingMode] = @"定位模式切换测试",
    [AMapTestContentTypeSearching] = @"搜索测试",
    [AMapTestContentTypeRoute] = @"路径规划"
};

NSString *const AMapTestContentTypeClass[] = {
    [AMapTestContentTypeTrackingMode] = @"TrackingModeViewController",
    [AMapTestContentTypeSearching] = @"SearchKindViewController",
    [AMapTestContentTypeRoute] = @"RouteViewController"
};

@implementation RootViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"高德地图测试";
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellId];
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Class aClass = NSClassFromString(AMapTestContentTypeClass[indexPath.row]);
    UIViewController *vc = [aClass new];
    vc.title = AMapTestContentTypeText[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return AMapTestContentTypeCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
    cell.textLabel.text = AMapTestContentTypeText[indexPath.row];
    return cell;
}

@end
