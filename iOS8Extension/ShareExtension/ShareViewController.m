//
//  ShareViewController.m
//  ShareExtension
//
//  Created by yixiaoluo on 2016/8/22.
//  Copyright © 2016年 yixiaoluo. All rights reserved.
//

#import "ShareViewController.h"
#import "FriendsTableViewController.h"
#import "HomeViewController.h"

static CGFloat const kOffsetY = 500;

@interface ShareViewController ()<UINavigationControllerDelegate>

@property (nonatomic) UINavigationController *rootViewController;

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containerViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containerCenterY;

@property (nonatomic) BOOL contentAnimated;

@end

@implementation ShareViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //根视图
    __weak typeof(self) weakSelf = self;
    HomeViewController *home = [[HomeViewController alloc] init];
    home.gobackHandler = ^{ [weakSelf dismiss]; };
    [home setPreferredContentSize:CGSizeMake(0, 80+44*3+44)];
    
    self.rootViewController = [[UINavigationController alloc] initWithRootViewController:home];
    self.rootViewController.delegate = self;
    
    //添加子视图
    [self addChildViewController:self.rootViewController];
    [self.containerView addSubview:self.rootViewController.view];
    [self.rootViewController didMoveToParentViewController:self];
    
    self.containerCenterY.constant = kOffsetY;

    self.rootViewController.view.frame = self.containerView.bounds;
    self.rootViewController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    self.containerView.layer.cornerRadius = 7;
    self.containerView.layer.masksToBounds = YES;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (!self.contentAnimated) {
        [UIView animateWithDuration:.3 delay:.1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.containerCenterY.constant = 0;
            [self.view layoutIfNeeded];
        }completion:^(BOOL finished) {
            self.contentAnimated = YES;
        }];
    }
}

#pragma mark - action
- (void)dismiss
{
    [UIView animateWithDuration:.5 animations:^{
        self.containerCenterY.constant = kOffsetY;
        [self.view layoutIfNeeded];
    }completion:^(BOOL finished) {
        [self.extensionContext completeRequestReturningItems:@[] completionHandler:^(BOOL expired) {
        }];
    }];
}

#pragma mark - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [UIView animateWithDuration:.2 delay:.1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.containerViewHeight.constant = viewController.preferredContentSize.height;
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        
    }];
}
@end
