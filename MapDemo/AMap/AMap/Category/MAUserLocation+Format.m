//
//  MAUserLocation+Format.m
//  AMap
//
//  Created by yixiaoluo on 16/4/13.
//  Copyright © 2016年 yixiaoluo. All rights reserved.
//

#import "MAUserLocation+Format.h"
#import <AMapSearchKit/AMapSearchKit.h>

@implementation MAUserLocation (Format)

- (AMapGeoPoint *)toAMapGeoPoint
{
    return [AMapGeoPoint locationWithLatitude:self.location.coordinate.latitude longitude:self.location.coordinate.longitude];
}

@end
