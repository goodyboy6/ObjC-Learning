//
//  AMapGeoPoint+Format.m
//  AMap
//
//  Created by yixiaoluo on 16/4/13.
//  Copyright © 2016年 yixiaoluo. All rights reserved.
//

#import "AMapGeoPoint+Format.h"

@implementation AMapGeoPoint (Format)

- (CLLocationCoordinate2D)toCLLocationCoordinate2D
{
    return CLLocationCoordinate2DMake(self.latitude, self.longitude);
}

@end
