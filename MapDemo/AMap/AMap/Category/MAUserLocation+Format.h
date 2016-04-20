//
//  MAUserLocation+Format.h
//  AMap
//
//  Created by yixiaoluo on 16/4/13.
//  Copyright © 2016年 yixiaoluo. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>

@class AMapGeoPoint;
@interface MAUserLocation (Format)

- (AMapGeoPoint *)toAMapGeoPoint;

@end
