//
//  ViewTestViewController.m
//  NSLockTest
//
//  Created by yixiaoluo on 15/3/9.
//  Copyright (c) 2015年 cn.gikoo. All rights reserved.
//

#import "ViewTest.h"
#import "FBKVOController.h"
#import "Masonry.h"

@interface ViewTest ()

@property (weak, nonatomic) IBOutlet UIImageView *demoImageView;
@property (weak, nonatomic) IBOutlet UIImageView *meinvImageView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView3;
@property (weak, nonatomic) IBOutlet UIImageView *imageView4;

@property (weak, nonatomic) IBOutlet UISwitch *switchButton;


@end

@implementation ViewTest

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.tintAdjustmentMode = UIViewTintAdjustmentModeNormal;

    //a safe && convenient kvo form facebook
    [self.KVOController observe:self.meinvImageView keyPath:NSLocalizedString(@"ttt",nil) options:NSKeyValueObservingOptionNew block:^(id observer, id object, NSDictionary *change) {
        NSLog(@"kvoController: %@", change);
    }];
    
    TextViewTest *viewTest = [[TextViewTest alloc] initWithFrame:CGRectMake(40, 40, 200, 40)];
    [self.view addSubview:viewTest];
    
    [self.KVOController observe:viewTest keyPath:@"textView.contentSize" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld block:^(id observer, id object, NSDictionary *change) {
        CGSize size = [change[NSKeyValueChangeNewKey] CGSizeValue];
        CGRect frame = viewTest.frame;
        frame.size.height = size.height + viewTest.textViewVerticalPadding;
        viewTest.frame = frame;
    }];
    
    
    //default tintcolor is green.
    //the image seems to be a png which can not be the one tranfromed from jpg, or it's color can not be changed belong with superview's change. i donot know the reason.
    void(^addTintColor)(UIImageView *imageView) = ^(UIImageView *imageView) {
        UIImage *mm = imageView.image;
        mm = [mm imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        imageView.image = mm;
    };
    
    addTintColor(self.meinvImageView);
    addTintColor(self.demoImageView);
    addTintColor(self.imageView3);
    addTintColor(self.imageView4);
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSString *ss = NSLocalizedString(@"hello_tip",nil);
        NSShadow *shadow = [[NSShadow alloc] init];
        shadow.shadowBlurRadius = 5;
        shadow.shadowColor = [UIColor greenColor];
        shadow.shadowOffset = CGSizeMake(10, 15);
        
        UILabel *labe = [[UILabel alloc] initWithFrame:CGRectMake(400, 0, 200, 200)];
        labe.textColor = [UIColor redColor];
        labe.numberOfLines = 0;
        labe.font = [UIFont systemFontOfSize:60];
        labe.attributedText = [[NSAttributedString alloc] initWithString:ss attributes:@{NSShadowAttributeName: shadow}];
        [labe sizeToFit];
        [self.view addSubview:labe];
    });
};

- (IBAction)switchDidChanged:(UISwitch *)sender {
    
    if (sender.isOn) {
        self.view.tintColor = [UIColor redColor];
    }else{
        self.view.tintColor = [UIColor purpleColor];
    }
}

- (void)dealloc
{
    NSLog(@"%@ - %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    NSLog(@"%@ - %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
}

@end


@implementation TextViewTest

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        
        self.textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        self.textView.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.textView];
        
        [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self).with.insets(UIEdgeInsetsMake(10, 10, 10, 10));
        }];
    }
    return self;
}

- (CGFloat)textViewVerticalPadding
{
    return 20;
}

@end
