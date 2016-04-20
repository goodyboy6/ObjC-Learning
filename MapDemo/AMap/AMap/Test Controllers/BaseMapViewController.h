//
//  WBMapViewController.h
//  AMap
//
//  Created by yixiaoluo on 16/4/12.
//  Copyright © 2016年 yixiaoluo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import "masonry.h"

//开发文档：http://lbs.amap.com/api/ios-sdk/guide/mapkit/
//http://lbs.amap.com/api/uri-api/ios-uri-explain/
@interface BaseMapViewController : UIViewController<MAMapViewDelegate, AMapSearchDelegate>

@property (nonatomic) MAMapView *mapView;
@property (nonatomic) AMapSearchAPI *searchAPI;
@property (nonatomic) MAUserLocation *currentUserLocalion;

@end
