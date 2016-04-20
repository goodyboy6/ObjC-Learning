//
//  SegueTestViewController.m
//  NSLockTest
//
//  Created by yixiaoluo on 15/3/9.
//  Copyright (c) 2015年 cn.gikoo. All rights reserved.
//

#import "SegueTest.h"
#import "UIStoryboard+Shared.h"

@interface SegueTest ()

@property (nonatomic) UIViewController *lastTransitionController;

@end

@implementation SegueTest

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //the following we target to add children view controller to this controller
    
    //first method:
    //see UIContainerView in storyboard
    //through which here we add children view controllers in this controller

    //second method:
    //we create a segue which inherits UIStoryboardSegue
    //use it to link the controller with its children, then use "- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender" add them as a childrn controller
    
    //this will locate the controller's container view which is the self.childViewControllers.firstObject container
    self.lastTransitionController = self.childViewControllers.firstObject;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"%@ - %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    
    UIViewController *destine = segue.destinationViewController;
    if ([self.childViewControllers containsObject:segue.destinationViewController]) {

    }else{
        [self addChildViewController:segue.destinationViewController];
        
        if (self.lastTransitionController) {
            [self transitionFromViewController:self.lastTransitionController toViewController:destine duration:.3 options:UIViewAnimationOptionTransitionFlipFromTop animations:^{        } completion:^(BOOL finished) {
                self.lastTransitionController = destine;
                [self.view bringSubviewToFront:self.clickIt];
            }];

        }else{
            [self.view addSubview:destine.view];
        }
    }
}

@end

@implementation PrivateSegue

- (instancetype)initWithIdentifier:(NSString *)identifier source:(UIViewController *)source destination:(UIViewController *)destination
{
    return [super initWithIdentifier:identifier source:source destination:destination];
}

- (void)perform
{
    //do nothing
    //animation be be done in prepareForSegue: sender:...
}

@end

@implementation Child1

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    NSLog(@"%@ - %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
}

@end

@implementation Child2

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    NSLog(@"%@ - %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
}

@end

@implementation Child3

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    NSLog(@"%@ - %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
}

@end