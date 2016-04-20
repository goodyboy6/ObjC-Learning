//
//  DetailViewController.m
//  Quartz 2D Demo
//
//  Created by yixiaoluo on 15/11/23.
//  Copyright © 2015年 yixiaoluo. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem {
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
            
        // Update the view.
        [self configureView];
    }
}

- (void)configureView {
    // Update the user interface for the detail item.
    if (self.detailItem) {
        self.detailDescriptionLabel.text = [self.detailItem description];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self configureView];
    
    self.detailDescriptionLabel.backgroundColor = [UIColor colorWithHue:.3333 saturation:1 brightness:1 alpha:1];
    
    
    // Create a light blue rectangle with a dark blue stroke
    CAShapeLayer *myLayer = [CAShapeLayer layer];
    [myLayer setFillColor:[[UIColor colorWithRed:0.9 green:0.9 blue:1.0 alpha:1.0] CGColor]];
    [myLayer setStrokeColor:[[UIColor colorWithRed:0.2 green:0.2 blue:0.8 alpha:1.0] CGColor]];
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(50, 100, 140, 80)];
    [myLayer setPath:[path CGPath]];
    
    // Style the dashed line
    // ------------------------------------
    // The line dash pattern is 2 points wide and 4 points long with
    // a 6 point space between the dashes.
    // The animation phase is one whole phase (4+6 = 10 points)
    //
    //                          <-4-><--6-->          <----10--->
    //     ___        ___        ___        ___        ___        ___
    //    |___|      |___|    2{|___|      |___|      |___|      |___|
    //
    [myLayer setLineWidth:2.0];
    [myLayer setLineDashPattern:[NSArray arrayWithObjects:
                                 [NSNumber numberWithFloat:4.0],
                                 [NSNumber numberWithFloat:6.0], nil]];
    [[[self view] layer] addSublayer:myLayer];
    
    // Animate the line dash phase from 0 to 10 (one whole phase) for
    // ever. This will make it look like infite marching ants.
    CABasicAnimation *march = [CABasicAnimation animationWithKeyPath:@"lineDashPhase"];
    [march setDuration:0.25];
    [march setFromValue:[NSNumber numberWithFloat:0.0]];
    [march setToValue:[NSNumber numberWithFloat:10.0]];
    [march setRepeatCount:INFINITY];
    
    [myLayer addAnimation:march forKey:@"marchTheAnts"];
    
    
    return;
    //一些总结
    //hue:色调, 似乎分为7色
    //saturation:饱和度
    //brightness:亮度
    CGFloat height = 8;
    for (NSInteger i=0; i<100; i++) {
        UIView *view  = [[UIView alloc] initWithFrame:CGRectMake(0, i*height, 100, height)];
        
        CGFloat hue = i/100.0;
        view.backgroundColor = [UIColor colorWithHue:hue saturation:1 brightness:1 alpha:1];
        [self.view addSubview:view];
        
        if (i%14 == 0) {
            UIView *line  = [[UIView alloc] initWithFrame:CGRectMake(0, i*height, 100, height)];
            line.backgroundColor = [UIColor blackColor];
            [self.view addSubview:line];
        }
    }
    
    for (NSInteger i=0; i<100; i++) {
        UIView *view  = [[UIView alloc] initWithFrame:CGRectMake(120, i*height, 100, height)];
        
        CGFloat hue = i/100.0;
        CGFloat saturation = i/100.0;
        view.backgroundColor = [UIColor colorWithHue:hue saturation:saturation brightness:1 alpha:1];
        [self.view addSubview:view];
        
        if (i%14 == 0) {
            UIView *line  = [[UIView alloc] initWithFrame:CGRectMake(120, i*height, 100, height)];
            line.backgroundColor = [UIColor blackColor];
            [self.view addSubview:line];
        }
    }

    for (NSInteger i=0; i<100; i++) {
        UIView *view  = [[UIView alloc] initWithFrame:CGRectMake(240, i*height, 100, height)];
        
        CGFloat hue = i/100.0;
        CGFloat saturation = i/100.0;
        CGFloat bright = i/100.0;
        view.backgroundColor = [UIColor colorWithHue:hue saturation:saturation brightness:bright alpha:1];
        [self.view addSubview:view];
        
        if (i%14 == 0) {
            UIView *line  = [[UIView alloc] initWithFrame:CGRectMake(240, i*height, 100, height)];
            line.backgroundColor = [UIColor blackColor];
            [self.view addSubview:line];
        }
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
