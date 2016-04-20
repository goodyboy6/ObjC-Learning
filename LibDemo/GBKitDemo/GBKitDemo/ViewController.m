//
//  ViewController.m
//  GBKitDemo
//
//  Created by yixiaoluo on 15/12/7.
//  Copyright © 2015年 yixiaoluo. All rights reserved.
//

#import "ViewController.h"
#import <GBKit/GBKit.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    GBPerson *person = [GBPerson new];
    NSLog(@"%@", person.description);
}

- (IBAction)openViewInDylib:(id)sender {
    GBViewController *vc = [[GBViewController alloc] init];
    vc.imageInGBKit = ^(GBViewController *v){
        NSString *mainBundlePath = [[NSBundle mainBundle] resourcePath];
        NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:mainBundlePath error:nil];
//        NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"GBKit" ofType:@"bundle"];
//        NSBundle *bundle = [NSBundle bundleWithPath:bundlePath];
//        NSString *path = [];
        UIImage *image = [UIImage imageNamed:@"Frameworks/GBKit.framework/GBKit.bundle/img_02"];
        return image;
    };
    [self presentViewController:vc animated:YES completion:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
