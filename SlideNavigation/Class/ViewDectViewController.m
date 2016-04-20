//
//  SNViewController.m
//  SubNavigation
//
//  Created by yixiaoluo on 16/3/31.
//  Copyright © 2016年 yixiaoluo. All rights reserved.
//

#import "ViewDectViewController.h"

@interface TouchView : UIView
@property (copy, nonatomic) void(^touchCallBack)(TouchView *view);
@end

@implementation TouchView

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (_touchCallBack) {
        _touchCallBack(self);
    }
}

@end

static inline CGFloat distanceBetween(CGPoint start, CGPoint end) {
    return start.x - end.x;
}

//x alias changed distance should be more than y's
static inline BOOL isValidDirection(CGPoint start, CGPoint end) {
    CGFloat xDistance = start.x - end.x;
    CGFloat yDistance = start.y - end.y;
    
    return fabs(xDistance) > fabs(yDistance);
}

NSString *const ViewDectPositionLog[] = {
    [ViewDectPositionLeft] = @"Left",
    [ViewDectPositionRight] = @"Right",
    [ViewDectPositionCenter] = @"Center"
};

@interface ViewDectViewController () <UIGestureRecognizerDelegate, UIScrollViewDelegate>{
    UIView *_contentViewInScrollView;//true content view
    TouchView *_touchView;
    BOOL _didScrollToCenter;//iOS9
}

@property (nonatomic) ViewDectPosition viewDectPosition;
@property (nonatomic, getter=getScrollView) UIScrollView *scrollView;//control the toggle

@end

@implementation ViewDectViewController

#pragma mark - life cycle
- (instancetype)initWithCenterViewController:(__kindof UIViewController *)centerViewController
                      leftSideViewController:(__kindof UIViewController *)leftViewController
                     rightSideViewController:(__kindof UIViewController *)rightViewController
{
    self = [super init];
    
    NSAssert(leftViewController && rightViewController, @"need left or/both right side view controller");

    _centerViewController = centerViewController;
    _rightViewController = rightViewController;
    _leftViewController = leftViewController;
    
    if (_leftViewController) {  _leftSideWidth = 200;  }
    
    if (_rightViewController) {  _rightSideWidth = 200; }
    
    [self addChildViewController:_centerViewController];
    
    _leftOpenCloseThreshold = 50;
    _rightOpenCloseThreshold = 100;
    
    _viewDectPosition = ViewDectPositionCenter;

    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.canOpenSideWhenAfterCenterPush = NO;
    
    [self layoutAllViews];
    [self makeAsChildrenController];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self updateScrollViewScrolable];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self updateScrollViewScrolable];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    if (!_didScrollToCenter) {
        [_scrollView setContentOffset:CGPointMake(_leftSideWidth, 0)];
        _didScrollToCenter = YES;
    }
}

#pragma mark - private
- (void)updateScrollViewScrolable
{
    if (self.canOpenSideWhenAfterCenterPush) {
        self.scrollView.scrollEnabled = YES;
    }else{
        if ([self.centerViewController isKindOfClass:[UINavigationController class]] && [(UINavigationController *)self.centerViewController viewControllers].count == 1) {
            //root view controller should be scrollable
            self.scrollView.scrollEnabled = YES;
        }else{
            self.scrollView.scrollEnabled = NO;
        }
    }
}

#pragma mark - setter && getter
- (void)setCanOpenSideWhenAfterCenterPush:(BOOL)canOpenSideWhenAfterPush
{
    NSAssert([_centerViewController isKindOfClass:[UINavigationController class]], @"center view controller should be a UINavigationViewController");
    _canOpenSideWhenAfterCenterPush = canOpenSideWhenAfterPush;
    
    [self updateScrollViewScrolable];
}

- (void)setLeftSideWidth:(CGFloat)leftSideWidth
{
    NSAssert(_leftViewController, @"left side view controller non-exist");
    _leftSideWidth = leftSideWidth;
}

- (void)setRightSideWidth:(CGFloat)rightSideWidth
{
    NSAssert(_leftViewController, @"right side view controller non-exist");
    _rightSideWidth = rightSideWidth;
}

- (UIViewController *)viewControllerAtPostion:(ViewDectPosition)positon
{
    switch (positon) {
        case ViewDectPositionCenter:
            return self.centerViewController;
            break;
        case ViewDectPositionLeft:
            return self.leftViewController;
            break;
        case ViewDectPositionRight:
            return self.rightViewController;
            break;
        default:
            break;
    }
}

- (UIScrollView *)getScrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
        _scrollView.backgroundColor = [UIColor purpleColor];
        _scrollView.bounces = NO;
        _scrollView.delegate = self;
        _scrollView.scrollsToTop = NO;
        _scrollView.directionalLockEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.directionalLockEnabled = YES;
        _scrollView.decelerationRate = 0.01;
    }
    return _scrollView;
}

#pragma mark - actions
- (void)openLeftSideAnimated:(BOOL)animated
{
    NSAssert(_leftViewController, @"left side view controller non-exist");
    
    [self.class openFromSide:[self viewControllerAtPostion:_viewDectPosition] toSide:_leftViewController animations:^{
        _scrollView.contentOffset = CGPointZero;
    } completion:^(BOOL finished) {
        self.viewDectPosition = ViewDectPositionLeft;
    }];
}

- (void)openCenterAnimated:(BOOL)animated
{
    [self.class openFromSide:[self viewControllerAtPostion:_viewDectPosition] toSide:_centerViewController animations:^{
        _scrollView.contentOffset = CGPointMake(_leftSideWidth, 0);
    } completion:^(BOOL finished) {
        self.viewDectPosition = ViewDectPositionCenter;
    }];
}

- (void)openRightSideAnimated:(BOOL)animated
{
    NSAssert(_leftViewController, @"right side view controller non-exist");

    [self.class openFromSide:[self viewControllerAtPostion:_viewDectPosition] toSide:_leftViewController animations:^{
        _scrollView.contentOffset = CGPointMake(CGRectGetWidth(_contentViewInScrollView.frame) - _rightSideWidth, 0);
    } completion:^(BOOL finished) {
        self.viewDectPosition = ViewDectPositionRight;
    }];
}

+ (void)openFromSide:(UIViewController *)from toSide:(UIViewController *)to animations:(dispatch_block_t)animations completion:(void(^)(BOOL finished))completion
{
    [from viewWillDisappear:YES];
    [to viewWillAppear:YES];
    
    [UIView animateWithDuration:.3 animations:^{
        if (animations) {
            animations();
        }
    } completion:^(BOOL finished) {
        [from viewDidAppear:YES];
        [to viewDidAppear:YES];
    }];
}

- (void)scrollFromPostion:(ViewDectPosition)from toPosition:(ViewDectPosition)to completion:(void(^)(BOOL finished))completion
{
    UIViewController *fromVC = [self viewControllerAtPostion:from];
    UIViewController *toVC = [self viewControllerAtPostion:to];

    [fromVC viewWillDisappear:YES];
    [toVC viewWillAppear:YES];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [fromVC viewDidAppear:YES];
        [toVC viewDidAppear:YES];
        
        if (from == ViewDectPositionCenter) {
            //add touch view to center view
            [_touchView removeFromSuperview];
            _touchView = [[TouchView alloc] initWithFrame:self.centerViewController.view.frame];
            _touchView.backgroundColor = [[UIColor blueColor] colorWithAlphaComponent:.3];
            [_scrollView addSubview:_touchView];
            
            __weak typeof(self) weakSelf = self;
            _touchView.touchCallBack = ^(TouchView *view){
                __strong __typeof(weakSelf)strongSelf = weakSelf;
                [strongSelf->_scrollView setContentOffset:CGPointMake(strongSelf->_leftSideWidth, 0) animated:YES];
                [view removeFromSuperview];
            };
        }else{
            //remove touch view from center view
            [_touchView removeFromSuperview];
            _touchView = nil;
        }
        
        self.viewDectPosition = to;
        
        if (completion) {
            completion(YES);
        }
    });
}

#pragma mark - UIScrollViewDelegate
static CGPoint _beginDragingPoint;
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    _beginDragingPoint = scrollView.contentOffset;
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    CGPoint theDestineLocation = scrollView.contentOffset;
    
    switch (_viewDectPosition) {
        case ViewDectPositionLeft:
            if (( distanceBetween(_beginDragingPoint, theDestineLocation) < 0) || (fabs(distanceBetween(_beginDragingPoint, theDestineLocation)) >= self.leftOpenCloseThreshold)) {
                //velocity in x, change to ViewDectPositionCenter
                targetContentOffset->x = _leftSideWidth;
                [self scrollFromPostion:_viewDectPosition toPosition:ViewDectPositionCenter completion:NULL];
            }else{
                //still is ViewDectPositionLeft
                //resume to start point
                targetContentOffset->x = 0;
            }
            break;
        case ViewDectPositionCenter:
            if (( distanceBetween(_beginDragingPoint, theDestineLocation) > 0) && (fabs(distanceBetween(_beginDragingPoint, theDestineLocation)) >= self.leftOpenCloseThreshold)) {
                //open left, change to ViewDectPositionLeft
                targetContentOffset->x = 0;
                [self scrollFromPostion:_viewDectPosition toPosition:ViewDectPositionLeft completion:NULL];
            }else if (( distanceBetween(_beginDragingPoint, theDestineLocation) < 0) &&  (fabs(distanceBetween(_beginDragingPoint, theDestineLocation)) >= self.rightOpenCloseThreshold)) {
                //velocity in x, change to ViewDectPositionCenter
                targetContentOffset->x = CGRectGetWidth(_contentViewInScrollView.frame) - _rightSideWidth;
                [self scrollFromPostion:_viewDectPosition toPosition:ViewDectPositionLeft completion:NULL];
            }else{
                //still is ViewDectPositionCenter
                targetContentOffset->x = _leftSideWidth;
            }
            break;
        case ViewDectPositionRight:
            if (( distanceBetween(_beginDragingPoint, theDestineLocation) > 0) || (fabs(distanceBetween(_beginDragingPoint, theDestineLocation)) >= self.leftOpenCloseThreshold)) {
                //velocity in x, change to ViewDectPositionCenter
                targetContentOffset->x = _leftSideWidth;
                [self scrollFromPostion:_viewDectPosition toPosition:ViewDectPositionCenter completion:NULL];
            }else{
                //still is ViewDectPositionLeft
                //resume to start point
                targetContentOffset->x = CGRectGetWidth(_contentViewInScrollView.frame) - _rightSideWidth;
            }
            break;
        default:
            break;
    }
}

#pragma mark - layout subviews
- (void)makeAsChildrenController
{
    if (_leftViewController) { [self addChildViewController:_leftViewController]; }
    if (_rightViewController) { [self addChildViewController:_rightViewController]; }

    [self addChildViewController:_leftViewController];
}

- (void)layoutAllViews
{
    [self getScrollView];
    _contentViewInScrollView = [[UIView alloc] initWithFrame:self.view.bounds];
    
    //_scrollView
    [self.view addSubview:_scrollView];
    _scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_scrollView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_scrollView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_scrollView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_scrollView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    
    //_contentViewInScrollView
    [_scrollView addSubview:_contentViewInScrollView];
    _contentViewInScrollView.translatesAutoresizingMaskIntoConstraints = NO;
    [_scrollView addConstraint:[NSLayoutConstraint constraintWithItem:_contentViewInScrollView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_scrollView attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
    [_scrollView addConstraint:[NSLayoutConstraint constraintWithItem:_contentViewInScrollView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_scrollView attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    [_scrollView addConstraint:[NSLayoutConstraint constraintWithItem:_contentViewInScrollView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:_scrollView attribute:NSLayoutAttributeTrailing multiplier:1 constant:0]];
    [_scrollView addConstraint:[NSLayoutConstraint constraintWithItem:_contentViewInScrollView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_scrollView attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_contentViewInScrollView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeHeight multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_contentViewInScrollView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:CGRectGetWidth([UIScreen mainScreen].bounds)+_leftSideWidth+_rightSideWidth]];

    
    //left center view controllers
    if (_leftViewController) {
        [_contentViewInScrollView addSubview:_leftViewController.view];
        _leftViewController.view.translatesAutoresizingMaskIntoConstraints = NO;
        [_contentViewInScrollView addConstraint:[NSLayoutConstraint constraintWithItem:_leftViewController.view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_contentViewInScrollView attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
        [_contentViewInScrollView addConstraint:[NSLayoutConstraint constraintWithItem:_leftViewController.view attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_contentViewInScrollView attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
        [_contentViewInScrollView addConstraint:[NSLayoutConstraint constraintWithItem:_leftViewController.view attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:_contentViewInScrollView attribute:NSLayoutAttributeLeading multiplier:1 constant:0]];
        [_contentViewInScrollView addConstraint:[NSLayoutConstraint constraintWithItem:_leftViewController.view attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:_leftSideWidth]];
    }
    
    //right view controller
    if (_rightViewController) {
        [_contentViewInScrollView addSubview:_rightViewController.view];
        _rightViewController.view.translatesAutoresizingMaskIntoConstraints = NO;
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_rightViewController.view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_contentViewInScrollView attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_rightViewController.view attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_contentViewInScrollView attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_rightViewController.view attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:_contentViewInScrollView attribute:NSLayoutAttributeTrailing multiplier:1 constant:0]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_rightViewController.view attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:_rightSideWidth]];
    }
    
    //center view controller
    [_contentViewInScrollView addSubview:_centerViewController.view];
    _centerViewController.view.translatesAutoresizingMaskIntoConstraints = NO;
    [_contentViewInScrollView addConstraint:[NSLayoutConstraint constraintWithItem:_centerViewController.view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_contentViewInScrollView attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    [_contentViewInScrollView addConstraint:[NSLayoutConstraint constraintWithItem:_centerViewController.view attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_contentViewInScrollView attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    
    //-->left and right
    NSLayoutConstraint *leftLayoutConstraint = nil;
    NSLayoutConstraint *rightLayoutConstraint = nil;
    if (_leftViewController) {
        leftLayoutConstraint = [NSLayoutConstraint constraintWithItem:_centerViewController.view attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:_leftViewController.view attribute:NSLayoutAttributeTrailing multiplier:1 constant:0];
    }else{
        leftLayoutConstraint = [NSLayoutConstraint constraintWithItem:_centerViewController.view attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1 constant:0];
    }
    if (_rightViewController) {
        rightLayoutConstraint = [NSLayoutConstraint constraintWithItem:_centerViewController.view attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:_rightViewController.view attribute:NSLayoutAttributeLeading multiplier:1 constant:0];
    }else{
        rightLayoutConstraint = [NSLayoutConstraint constraintWithItem:_centerViewController.view attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1 constant:0];
    }
    [_contentViewInScrollView addConstraint:leftLayoutConstraint];
    [_contentViewInScrollView addConstraint:rightLayoutConstraint];
}

@end
