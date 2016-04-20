//
//  ViewController.m
//  NSLockTest
//
//  Created by yixiaoluo on 15/2/25.
//  Copyright (c) 2015年 cn.gikoo. All rights reserved.
//

#import "RootViewController.h"
#import "DetailViewController.h"
#import "Contant.h"

@interface RootViewController ()

@property (strong, nonatomic) NSArray *testArray;

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.navigationController.hidesBarsOnSwipe = YES;
}

- (NSArray *)testArray
{
    if (_testArray == nil) {
        _testArray =  [Contant allTestTypeStrings];
    }
    return _testArray;
}

#pragma mark -
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([sender isKindOfClass:[UITableViewCell class]]) {
        DetailViewController *child = segue.destinationViewController;
        child.type = [self.tableView indexPathForCell:sender].row + 1;
    }
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.testArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ttt"];
    cell.textLabel.text = self.testArray[indexPath.row];
    return cell;
}
@end
