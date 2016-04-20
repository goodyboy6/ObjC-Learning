//
//  SNViewController.h
//  SubNavigation
//
//  Created by yixiaoluo on 16/3/31.
//  Copyright © 2016年 yixiaoluo. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    ViewDectPositionLeft,
    ViewDectPositionCenter,
    ViewDectPositionRight
} ViewDectPosition;

//style like 知乎
@interface ViewDectViewController : UIViewController

@property (nonatomic) CGFloat leftSideWidth;//leftViewController width, default is 200px
@property (nonatomic) CGFloat rightSideWidth;//leftViewController width, default is 200px
@property (nonatomic) CGFloat leftOpenCloseThreshold;//the distance swiped to open or close the left. defualt is 50px
@property (nonatomic) CGFloat rightOpenCloseThreshold;//the distance swiped to open the right. default is 50px

//centerViewController should be a UINavigationController.
//When centerViewController push/present a new controller, it may should not open side in the visiable controller. default is NO.
@property (nonatomic) BOOL canOpenSideWhenAfterCenterPush;

@property (nonatomic, nonnull) __kindof UIViewController *centerViewController;
@property (nonatomic, nonnull) __kindof UIViewController *leftViewController;
@property (nonatomic, nullable) __kindof UIViewController *rightViewController;

- (nonnull instancetype)initWithCenterViewController:(nonnull __kindof UIViewController *)centerViewController
                              leftSideViewController:(nullable __kindof UIViewController *)leftViewController
                             rightSideViewController:(nullable __kindof UIViewController *)rightViewController;

- (void)openLeftSideAnimated:(BOOL)animated;
- (void)openCenterAnimated:(BOOL)animated;
- (void)openRightSideAnimated:(BOOL)animated;

@end
