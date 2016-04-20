//
//  DPProxyViewController.m
//  Design_Patterns
//
//  Created by yixiaoluo on 15/9/8.
//  Copyright (c) 2015年 yixiaoluo. All rights reserved.
//

#import "DPProxyViewController.h"
#import "DPThunmbnailCell.h"
#import "DPAnimationLayout.h"
#import "DPFullScreenLayout.h"

static inline NSArray* dp_thumbnailImagePaths(){
    static NSArray *imagePaths = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        imagePaths = @[
                       @"http://ww2.sinaimg.cn/mw600/825b611djw1evvu6uowyyj20hs0hsac8.jpg",
                       @"http://i3.sinaimg.cn/ent/m/c/w/2013-07-14/U8711P28T3D3963713F326DT20130714152318.jpg",
                       @"http://ww3.sinaimg.cn/mw600/825b611djw1evvu6u6ehej20jg0dwdjn.jpg",
                       @"http://ww2.sinaimg.cn/mw600/005HF3KSjw1evv15zwk4oj30j60px40l.jpg",
                       @"http://ww3.sinaimg.cn/mw600/eaf8a597gw1evvb93nn2qj20fj0mtdh6.jpg",
                       @"http://ww1.sinaimg.cn/mw600/005vbOHfgw1evv8jsbryyj30f30j7tbu.jpg",
                       @"http://ww2.sinaimg.cn/mw600/005vbOHfgw1evv8kaqj8aj30i60r8423.jpg",
                       ];
    });
    
    return imagePaths;
};

@interface DPProxyViewController ()
<
    DPThumbnailProxyProtocol,
    DPFullScreenLayoutDelegate
>

@property (nonatomic) NSMutableArray *imagePaths;

@property (nonatomic) DPThumbnailProxyMode mode;
@property (nonatomic) NSIndexPath *currentSelectIndexPath;

@end

@implementation DPProxyViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.imagePaths = [dp_thumbnailImagePaths() mutableCopy];
    
    [self.collectionView registerClass:[DPThunmbnailCell class] forCellWithReuseIdentifier:@"DPThunmbnailCell"];

    if (self.mode == DPThumbnailProxyModeThumbnail) {
        UIBarButtonItem *insert = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertItem)];
        UIBarButtonItem *delete = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(deleteItem)];
        self.navigationItem.rightBarButtonItems = @[insert, delete];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.mode = self.navigationItem.rightBarButtonItem == nil ? DPThumbnailProxyModeOrigin : DPThumbnailProxyModeThumbnail;
}

#pragma mark - response event
- (void)insertItem
{
    [self.imagePaths insertObject:@"http://ww1.sinaimg.cn/mw600/005vbOHfgw1evv8jsbryyj30f30j7tbu.jpg" atIndex:0];
    [self.collectionView insertItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:0 inSection:0]]];
}

- (void)deleteItem
{
    if (self.imagePaths.count > 0) {
        [self.imagePaths removeObjectAtIndex:0];
        [self.collectionView deleteItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:0 inSection:0]]];
    }
}

#pragma mark - status bar
- (BOOL)prefersStatusBarHidden
{
    return self.navigationController.navigationBarHidden;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation
{
    return UIStatusBarAnimationSlide;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.imagePaths.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    DPThunmbnailCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DPThunmbnailCell" forIndexPath:indexPath];
    
    cell.delegate = self;
    cell.thunmbnailProxy.imagePath = [NSURL URLWithString:self.imagePaths[indexPath.row % self.imagePaths.count]];
    
    return cell;
}

- (DPThumbnailProxyMode)proxyMode
{
    return self.mode;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.mode == DPThumbnailProxyModeOrigin) {
        [self.navigationController setNavigationBarHidden:!(self.navigationController.navigationBarHidden) animated:YES];
        [UIView animateWithDuration:.25 animations:^(void) {
            [self setNeedsStatusBarAppearanceUpdate];
        } completion:^(BOOL finished) {}];

        return;
    }
    
    DPFullScreenLayout *layout = [[DPFullScreenLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumLineSpacing = 0;
    
    DPProxyViewController *detail = [[DPProxyViewController alloc] initWithCollectionViewLayout:layout];
    detail.useLayoutToLayoutNavigationTransitions = YES;
    detail.mode = DPThumbnailProxyModeOrigin;
    
    [self.navigationController pushViewController:detail animated:YES];
    detail.collectionView.pagingEnabled = YES;
    detail.collectionView.alwaysBounceHorizontal = YES;
    
    self.mode = DPThumbnailProxyModeOrigin;
    self.currentSelectIndexPath = indexPath;
}

@end
