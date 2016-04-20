//
//  ViewController.m
//  Design_Patterns
//
//  Created by yixiaoluo on 15/4/28.
//  Copyright (c) 2015年 yixiaoluo. All rights reserved.
//

#import "ViewController.h"
#import "DPAnimationLayout.h"
#import "DPProxyViewController.h"

static NSString *const idenfier = @"cn.gikoo.patterns";

static NSDictionary *sb_allDesignPatternNames() {
    static NSDictionary *dictionnary = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dictionnary = @{@"生成者模式": @"BuilderViewController",
                        @"策略模式": @"DPStrategyViewController",
                        @"代理模式": @"DPProxyViewController",
                        @"责任链": @"DPChainOfResponsibilityViewController",
                        @"桥接模式": @"DPBridgeViewController"
                        };
    });
    return dictionnary;
}

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.title = @"设计模式";
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:idenfier];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

#pragma mark - UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:idenfier forIndexPath:indexPath];
    NSArray *allNames = sb_allDesignPatternNames().allKeys;
    cell.textLabel.text = allNames[indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return sb_allDesignPatternNames().allKeys.count;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *allControllers = sb_allDesignPatternNames().allValues;
    NSString *className = allControllers[indexPath.row];
    
    UIViewController *vc = nil;
    if ([className isEqualToString:@"DPProxyViewController"]) {
        DPAnimationLayout *layout = [[DPAnimationLayout alloc] init];
        vc = [[DPProxyViewController alloc] initWithCollectionViewLayout:layout];
        ((UICollectionViewController *)vc).useLayoutToLayoutNavigationTransitions = NO;
    }else{
        vc = [self.storyboard instantiateViewControllerWithIdentifier:className];
    }
    [self.navigationController pushViewController:vc animated:YES];
}

@end
