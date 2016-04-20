//
//  TableViewController.m
//  NSLockTest
//
//  Created by yixiaoluo on 15/2/26.
//  Copyright (c) 2015年 cn.gikoo. All rights reserved.
//

#import "DispatchTimerTest.h"

@interface DispatchTimerTest ()

@property (nonatomic) NSInteger leftTime;
@property (nonatomic) dispatch_source_t timer;

@end

@implementation DispatchTimerTest

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    
    self.leftTime = 10;
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    
    __weak typeof(self) wself = self;
    dispatch_source_set_event_handler(timer, ^{
        
        __strong typeof(self) strongSelf = self;
        if (strongSelf.leftTime >= 0) {
            [wself.tableView reloadData];
        }else{
            dispatch_source_cancel(timer);
        }
        
        NSLog(@"leftTime : %d", wself.leftTime);
        strongSelf.leftTime--;
    });
    dispatch_resume(timer);
    
    dispatch_source_set_cancel_handler(timer, ^{
        NSLog(@"dispatch_source_set_cancel_handler");
    });
    
    self.timer = timer;
    
//    NSTimer *time = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(downCount) userInfo:nil repeats:YES];
//    [[NSRunLoop mainRunLoop] addTimer:time forMode:NSRunLoopCommonModes];//NSDefaultRunLoopMode];
}

//- (void)downCount
//{
//    if (self.leftTime >= 0) {
//        NSLog(@"leftTime : %d", self.leftTime);
//        [self.tableView reloadData];
//    }else{
//        ;
//    }
//    
//    self.leftTime--;
//}

- (void)dealloc
{
    //dispatch_source_cancel(self.timer);
    
    NSLog(@"%@ - %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 2000;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ttt"];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ttt"];
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"%d", self.leftTime];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
