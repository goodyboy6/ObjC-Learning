//
//  SearchKindViewController.m
//  AMap
//
//  Created by yixiaoluo on 16/4/13.
//  Copyright © 2016年 yixiaoluo. All rights reserved.
//

#import "SearchKindViewController.h"
#import "MAUserLocation+Format.h"
#import "AMapGeoPoint+Format.h"
#import "CustomAnnotationView.h"

@interface SearchKindViewController ()<UISearchBarDelegate, CustomAnnotationViewDeletete>

@property (nonatomic) NSArray<AMapPOI *> *AMapPOIs;

@end

@implementation SearchKindViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationItem setHidesBackButton:YES];
    
    UISearchBar *bar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 20, 30)];
    bar.placeholder = @"输入关键字，比如：美食......";
    bar.delegate = self;
    self.navigationItem.titleView = bar;
    
    [bar setShowsCancelButton:YES animated:YES];
    [bar becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.view.window endEditing:YES];
}

#pragma mark - UISearchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    //周边搜索
    AMapPOIAroundSearchRequest *request = [[AMapPOIAroundSearchRequest alloc] init];
    
    request.keywords = [searchBar.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    request.location = [self.currentUserLocalion toAMapGeoPoint];//搜索中心点以“我”为中心
    request.radius = 5000;//搜索半径为3000米
    
    [self.searchAPI AMapPOIAroundSearch:request];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - CustomAnnotationViewDeletete
- (void)customAnnotationViewCallOutDidSelected:(CustomAnnotationView *)view
{
    NSLog(@"select call out: %@", view.annotation);
    
    [self.navigationController pushViewController:[[self class] new] animated:YES];
}

#pragma mark - MAMapViewDelegate
- (void)mapView:(MAMapView *)mapView didSelectAnnotationView:(MAAnnotationView *)view
{
    NSLog(@"select: %@", ((MAPointAnnotation *)view.annotation).title);
    [mapView setCenterCoordinate:((MAPointAnnotation *)view.annotation).coordinate animated:YES];
}

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MAPointAnnotation class]]) {
        static NSString *identifier = @"pinssss";
        MAPointAnnotation *p = annotation;
        
        CustomAnnotationView *view = (CustomAnnotationView *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        if (!view) {
            view = [[CustomAnnotationView alloc] initWithAnnotation:p reuseIdentifier:identifier];
        }
        view.annotation = p;
        view.canShowCallout = NO;
        view.delegate = self;
        
        //自定义标记图标
        view.image = [UIImage imageNamed:@"annotation"];
        view.centerOffset = CGPointMake(0, -view.image.size.height/2);
        
        return view;
    }
    
    return nil;
}

#pragma mark - AMapPOISearchRequestDelegate
- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response
{
    [self.view.window endEditing:YES];
    
    NSLog(@"%li %@", (long)response.count, response.pois);
    self.AMapPOIs = response.pois;
    [self.mapView addAnnotations:[self allAnnotations]];
}

#pragma mark - getter
- (NSArray *)allAnnotations
{
    NSMutableArray *array = [NSMutableArray array];
    
    [self.AMapPOIs enumerateObjectsUsingBlock:^(AMapPOI * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        MAPointAnnotation *p = [[MAPointAnnotation alloc] init];
        p.coordinate = [obj.location toCLLocationCoordinate2D];
        p.title = obj.name;
        p.subtitle = obj.address;
        [array addObject:p];
    }];
    
    return [array copy];
}

@end
