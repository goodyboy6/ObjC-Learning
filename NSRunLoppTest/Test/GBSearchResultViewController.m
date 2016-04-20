//
//  GBSearchResultViewController.m
//  Test
//
//  Created by yixiaoluo on 15/8/19.
//  Copyright (c) 2015年 yixiaoluo. All rights reserved.
//

#import "GBSearchResultViewController.h"

@implementation GBSearchResultViewController{
    UISearchDisplayController *_searchDisplayController;
    UISearchBar *_bar;
    
    UIImageView *_imageView;
    
    NSInteger _timerCountInBackgroundRunLoop;
    NSTimer *_timerInBackgroundRunLoop;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UISearchBar *bar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    bar.delegate = self;
    _bar = bar;
    
    self.tableView.tableHeaderView = bar;

//    self.searchDisplayController.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 100, 64)];
    _searchDisplayController   = [[UISearchDisplayController alloc] initWithSearchBar:bar contentsController:self];
    _searchDisplayController.searchResultsTableView.tableHeaderView=nil;
    _searchDisplayController.delegate=self;
    _searchDisplayController.searchResultsDataSource=self;
    _searchDisplayController.searchResultsDelegate=self;
    _searchDisplayController.searchResultsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _searchDisplayController.displaysSearchBarInNavigationBar = YES;
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [_bar becomeFirstResponder];
    
    [_bar setShowsCancelButton:YES animated:YES];
    
    
    [self performSelectorInBackground:@selector(getImageInbackground) withObject:nil];
    NSLog(@"hello");
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar                    // called when cancel button pressed
{
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)getImageInbackground
{
    @autoreleasepool {
        NSRunLoop *currentRunLoop = [NSRunLoop currentRunLoop];
        
        _timerInBackgroundRunLoop = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(changeImage) userInfo:nil repeats:YES];
        [currentRunLoop addTimer:_timerInBackgroundRunLoop forMode:NSRunLoopCommonModes];
        [currentRunLoop run];
    }
}

- (void)changeImage
{
    _timerCountInBackgroundRunLoop++;

    NSString *url = @"http://b.hiphotos.baidu.com/image/pic/item/42166d224f4a20a4cf57a6ce92529822720ed06a.jpg";
    if (_timerCountInBackgroundRunLoop%2 == 0) {
        url = @"http://img.alicdn.com/tps/i2/TB1UvRhIpXXXXczXpXX4OB5KVXX-466-180.png";
    }
    UIImage  *image = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:url]]];
    
    [self performSelectorOnMainThread:@selector(showImage:) withObject:image waitUntilDone:NO];
}

- (void)showImage:(UIImage *)img
{
    NSLog(@"changed");
    
    [_imageView removeFromSuperview];
    
    _imageView = [[UIImageView alloc] initWithImage:img];
    [self.view addSubview:_imageView];
    
    if (_timerCountInBackgroundRunLoop == 5) {
        [_timerInBackgroundRunLoop invalidate];
        _timerInBackgroundRunLoop = nil;
    }
}
@end
