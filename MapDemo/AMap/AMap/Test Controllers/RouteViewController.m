//
//  RouteViewController.m
//  AMap
//
//  Created by yixiaoluo on 16/4/13.
//  Copyright © 2016年 yixiaoluo. All rights reserved.
//

#import "RouteViewController.h"
#import "MAUserLocation+Format.h"
#import "AMapGeoPoint+Format.h"

@implementation RouteViewController{
    NSArray<MAPolyline *> *_currentPolylines;
}

#pragma mark - MAMapViewDelegate
- (void)mapView:(MAMapView *)mapView didSingleTappedAtCoordinate:(CLLocationCoordinate2D)coordinate
{
    NSLog(@"long press: %g, %g", coordinate.latitude, coordinate.longitude);
    
    AMapGeoPoint *startPoint = [self.currentUserLocalion toAMapGeoPoint];
    AMapGeoPoint *destinationPoint = [AMapGeoPoint locationWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    
//    AMapGeoPoint *wayPoint1 = [AMapGeoPoint locationWithLatitude:30.18 longitude:120.152];
//    AMapGeoPoint *wayPoint2 = [AMapGeoPoint locationWithLatitude:30.2025 longitude:120.19];

    AMapDrivingRouteSearchRequest *requst = [[AMapDrivingRouteSearchRequest alloc] init];
    requst.origin = startPoint;
    requst.destination = destinationPoint;
//    requst.waypoints = @[wayPoint1, wayPoint2];
    [self.searchAPI AMapDrivingRouteSearch:requst];
}

- (MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id <MAOverlay>)overlay;
{
    MAPolylineRenderer *render = [[MAPolylineRenderer alloc] initWithOverlay:overlay];
    render.lineWidth = 6;
    render.strokeColor = [UIColor magentaColor];
    render.lineJoinType = kMALineJoinMiter;
    render.lineCapType = kMALineCapArrow;
    return render;
}

#pragma mark - AMapSearchDelegate
- (void)onRouteSearchDone:(AMapRouteSearchBaseRequest *)request response:(AMapRouteSearchResponse *)response
{
    NSLog(@"count %li: %@", (long)response.route.paths.count, response.route.paths);
    if (response.count == 0) {
        return;
    }
    
    if (_currentPolylines) {
        [self.mapView removeOverlays:_currentPolylines];
    }
    
    AMapPath *mapPath = response.route.paths[0];//只显示一条路径
    NSArray<MAPolyline *> *polylines = [self linesInMapPath:mapPath];
    [self.mapView addOverlays:polylines];
    
    _currentPolylines = polylines;
}

#pragma mark - private
- (NSArray<MAPolyline *> *)linesInMapPath:(AMapPath *)path
{
    NSLog(@"strategy: %@", path.strategy);
    
    NSMutableArray *lines = [NSMutableArray array];
    [path.steps enumerateObjectsUsingBlock:^(AMapStep *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *polyline = obj.polyline;
        [lines addObject:[self lineInStepPolyline:polyline]];
    }];
    
    return [lines copy];
}

- (MAPolyline *)lineInStepPolyline:(NSString *)polylineString
{
    if (polylineString.length == 0) {
        return nil;
    }
    
    NSArray<NSString *> *points = [polylineString componentsSeparatedByString:@";"];
    if (points.count == 0) {
        return nil;
    }
    
    CLLocationCoordinate2D coordinates[points.count];
    for (NSInteger i = 0; i<points.count; i++) {
        NSString *obj = points[i];
        NSArray<NSString *> *values = [obj componentsSeparatedByString:@","];
        
        if (values.count == 2) {
            CLLocationDegrees latitude = [values[1] doubleValue];
            CLLocationDegrees longitude = [values[0] doubleValue];
            coordinates[i] = CLLocationCoordinate2DMake(latitude, longitude);
        }else{
            NSLog(@"ignored: %@", obj);
        }
    }
    
    MAPolyline *line = [MAPolyline polylineWithCoordinates:coordinates count:points.count];
    
    return line;

}
@end
