//
//  ViewController.m
//  AMap
//
//  Created by yixiaoluo on 16/4/12.
//  Copyright © 2016年 yixiaoluo. All rights reserved.
//

#import "TrackingModeViewController.h"
#import "MAUserLocation+Format.h"

NSString *const TrackingModeImageNames[] = {
    [MAUserTrackingModeNone] = @"location",
    [MAUserTrackingModeFollow] = @"location2",
    [MAUserTrackingModeFollowWithHeading] = @"location3"
};

@interface TrackingModeViewController ()

@property (nonatomic) UIButton *locationButton;

@end

@implementation TrackingModeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //定位按钮
    [self.mapView addSubview:self.locationButton];
    [self.locationButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.locationButton.superview.mas_leading).offset(10);
        make.bottom.equalTo(self.locationButton.superview.mas_bottom).offset(-30);
        make.size.mas_equalTo(self.locationButton.frame.size);
    }];
    
    //追踪模式
    self.mapView.userTrackingMode = MAUserTrackingModeFollow;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - actions
- (void)showGoeInUserLocation
{
    AMapReGeocodeSearchRequest *requst = [[AMapReGeocodeSearchRequest alloc] init];
    requst.location = [self.currentUserLocalion toAMapGeoPoint];
    [self.searchAPI AMapReGoecodeSearch:requst];
}

- (void)changeTrackingMode
{
    MAUserTrackingMode mode = MAX((self.mapView.userTrackingMode+1)%3, MAUserTrackingModeFollow);
    [self.mapView setUserTrackingMode:mode animated:YES];
}

#pragma mark -  AMapSearchDelegate
- (void)AMapSearchRequest:(id)request didFailWithError:(NSError *)error
{
    NSLog(@"%@", error);
}

- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response;
{
    NSString *title = response.regeocode.addressComponent.province;
    NSString *des = response.regeocode.formattedAddress;
    NSLog(@"%@: %@", title, des);
    
    self.mapView.userLocation.title = title;
    self.mapView.userLocation.subtitle = des;
}

#pragma mark -  MAMapViewDelegate
//追踪模式发生变化
- (void)mapView:(MAMapView *)mapView didChangeUserTrackingMode:(MAUserTrackingMode)mode animated:(BOOL)animated
{
    [self.locationButton setImage:[UIImage imageNamed:TrackingModeImageNames[mode]] forState:UIControlStateNormal];
}

//用户位置发生变更
- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation;
{
    self.currentUserLocalion = userLocation;
}

//选中标记
- (void)mapView:(MAMapView *)mapView didSelectAnnotationView:(MAAnnotationView *)view;
{
    if ([view.annotation isKindOfClass:[MAUserLocation class]]) {
        [self showGoeInUserLocation];
    }
}

#pragma mark - getter
- (UIButton *)locationButton
{
    if (!_locationButton) {
        UIButton *locationButton = [UIButton buttonWithType:UIButtonTypeCustom];
        locationButton.frame = CGRectMake(0, 0, 44, 44);
        [locationButton addTarget:self action:@selector(changeTrackingMode) forControlEvents:UIControlEventTouchUpInside];
        _locationButton = locationButton;
    }
    
    return _locationButton;
}

@end
