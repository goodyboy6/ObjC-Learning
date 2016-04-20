//
//  WBMapViewController.m
//  AMap
//
//  Created by yixiaoluo on 16/4/12.
//  Copyright © 2016年 yixiaoluo. All rights reserved.
//

#import "BaseMapViewController.h"

static NSString *const apiKey = @"0fa1fd24ae18634a0c4141093efd915e";

@implementation BaseMapViewController

- (void)viewDidLoad
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [MAMapServices sharedServices].apiKey = apiKey;
        [AMapSearchServices sharedServices].apiKey = apiKey;
    });

    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self.view addSubview:[self mapView]];
    [self.mapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

#pragma mark - getter
- (MAMapView *)mapView
{
    if (!_mapView) {
        _mapView = [[MAMapView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _mapView.delegate = self;
        _mapView.compassOrigin = CGPointMake(_mapView.compassOrigin.x, 20);//罗盘位置
        _mapView.scaleOrigin = CGPointMake(_mapView.scaleOrigin.x, 20);//比例尺位置
        _mapView.mapType = MAMapTypeStandard;
        _mapView.zoomLevel = 16;//地图的缩放级别的范围是[3-19]
        _mapView.showsUserLocation = YES;//显示用户地理位置
    }
    return _mapView;
}

- (AMapSearchAPI *)searchAPI
{
    if (!_searchAPI) {
        _searchAPI = [[AMapSearchAPI alloc] init];
        _searchAPI.delegate = self;
    }
    return _searchAPI;
}

@end
