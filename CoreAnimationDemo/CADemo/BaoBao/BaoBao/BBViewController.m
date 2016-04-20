//
//  ViewController.m
//  BaoBao
//
//  Created by yixiaoluo on 15/11/17.
//  Copyright © 2015年 yixiaoluo. All rights reserved.
//

#import "BBViewController.h"
#import "BBDrawView.h"
#import "BBDrawView1.h"
#import "BBDrawView2.h"

@interface BBViewController ()
<
BBDrawViewDelegate
>

@property (weak, nonatomic) IBOutlet BBDrawView *drawView;

@property (weak, nonatomic) IBOutlet UIButton *goBackButton;
@property (weak, nonatomic) IBOutlet UIButton *drainButton;

@end

@implementation BBViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateButtonsStatus
{
    BOOL canGoBack = [self.drawView canGoBack];
    
    self.goBackButton.enabled = canGoBack;
    self.drainButton.enabled = canGoBack;
}

#pragma mark - events response
- (IBAction)back:(UIButton *)sender {
    [self.drawView goBack];
}

- (IBAction)clear:(UIButton *)sender {
    [self.drawView clear];
}

#pragma mark - BBDrawViewDelegate
- (void)drawViewDidFinishChange:(BBDrawView *)view
{
    NSLog(@"%@", NSStringFromSelector(_cmd));
    [self updateButtonsStatus];
}


@end
