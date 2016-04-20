//
//  DetailViewController.m
//  LayerRenderDemo
//
//  Created by yixiaoluo on 15/11/19.
//  Copyright © 2015年 yixiaoluo. All rights reserved.
//

#import "LRDetailViewController.h"

@interface LRDetailViewController ()

@property (nonatomic) UIImageView *snapShot;

@end

@implementation LRDetailViewController

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
        
        self.snapShot.image = (UIImage *)self.detailItem;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.snapShot = [[UIImageView alloc] init];
    self.snapShot.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:self.snapShot];
    
    
    [self configureView];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    self.snapShot.frame = ({
        CGRect f = self.view.bounds;
        f.origin.x = f.origin.y = 50;
        f.size.width -= 100;
        f.size.height -= 100;
        f;
    });
}
@end
