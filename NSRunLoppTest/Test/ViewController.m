//
//  ViewController.m
//  Test
//
//  Created by yixiaoluo on 15/8/19.
//  Copyright (c) 2015年 yixiaoluo. All rights reserved.
//

#import "ViewController.h"
#import <objc/message.h>
#import "GBSearchResultViewController.h"

#define REFACTOR  10000000000000

#define NAME(t) (t->_name)
#define COUNT(c) (c * REFACTOR)

@interface ViewController ()
{
    NSString *_name;
}

@end

@implementation ViewController

static inline NSString *currentName(ViewController *vc){
    return vc->_name;
}

static NSString *currentName2(ViewController *vc){
    return vc->_name;
}

NSString *currentName3(ViewController *vc){
    return vc->_name;
}

static inline NSInteger currentCount(NSInteger count){
    return count * REFACTOR;
}

static NSInteger currentCount2(NSInteger count){
    return count * REFACTOR;
}

NSInteger currentCount3(NSInteger count){
    return count * REFACTOR;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //加入cache list
    _name = [self description];
    [[NSDate date] timeIntervalSince1970];
    
    NSInteger maxTime = 10000000;
    
    NSTimeInterval before = [[NSDate date] timeIntervalSince1970];
    IMP descIMP = [self methodForSelector:@selector(m_currentName:)];
    SEL selector = @selector(m_currentName:);
    id sender = self;
    for (NSInteger i = maxTime; i>0; i--) {
        ((NSString* (*)(id, SEL, ViewController *))descIMP)(sender, selector, sender);
    }
    NSLog(@"end1 : %@", @([[NSDate date] timeIntervalSince1970] - before));

    before = [[NSDate date] timeIntervalSince1970];
    selector = @selector(m_currentName:);
    for (NSInteger i = maxTime; i>0; i--) {
        NSString * (*msg)(id, SEL, ViewController *) = (NSString * (*)(id, SEL, ViewController *))objc_msgSend;
        msg(self, selector, self);
    }
    NSLog(@"end2 : %@", @([[NSDate date] timeIntervalSince1970] - before));

    before = [[NSDate date] timeIntervalSince1970];
    for (NSInteger i = maxTime; i>0; i--) {
        [self m_currentName:self];
    }
    NSLog(@"end3 : %@", @([[NSDate date] timeIntervalSince1970] - before));
    
    /*
     result:
     2015-08-19 14:27:50.861 Test[13151:3120676] end1 : 0.661607027053833
     2015-08-19 14:27:51.512 Test[13151:3120676] end2 : 0.6508529186248779
     2015-08-19 14:27:52.148 Test[13151:3120676] end3 : 0.6359350681304932
     
     2015-08-19 14:28:04.402 Test[13176:3121526] end1 : 0.6553080081939697
     2015-08-19 14:28:05.058 Test[13176:3121526] end2 : 0.6552021503448486
     2015-08-19 14:28:05.686 Test[13176:3121526] end3 : 0.6279449462890625
     
     2015-08-19 14:28:19.832 Test[13201:3122439] end1 : 0.638512134552002
     2015-08-19 14:28:20.470 Test[13201:3122439] end2 : 0.6379251480102539
     2015-08-19 14:28:21.109 Test[13201:3122439] end3 : 0.6384539604187012
     
     大家都说for循环下调用一个方法使用IMP会更快，可是测试结果是即使这个for循环达到千万级别，时间看起来没什么差
     */

    if (0) {
        before = [[NSDate date] timeIntervalSince1970];
        for (NSInteger i = maxTime; i>0; i--) {
            currentName(self);
        }
        NSLog(@"end1 : %@", @([[NSDate date] timeIntervalSince1970] - before));
        
        before = [[NSDate date] timeIntervalSince1970];
        for (NSInteger i = maxTime; i>0; i--) {
            currentName2(self);
        }
        NSLog(@"end2 : %@", @([[NSDate date] timeIntervalSince1970] - before));
        
        before = [[NSDate date] timeIntervalSince1970];
        for (NSInteger i = maxTime; i>0; i--) {
            currentName3(self);
        }
        NSLog(@"end3 : %@", @([[NSDate date] timeIntervalSince1970] - before));
        
        before = [[NSDate date] timeIntervalSince1970];
        for (NSInteger i = maxTime; i>0; i--) {
            NAME(self);
        }
        NSLog(@"end4 : %@", @([[NSDate date] timeIntervalSince1970] - before));
        
        before = [[NSDate date] timeIntervalSince1970];
        for (NSInteger i = maxTime; i>0; i--) {
            [self m_currentName:self];
        }
        NSLog(@"end5 : %@", @([[NSDate date] timeIntervalSince1970] - before));
        
        /*
         2015-08-19 13:54:13.581 Test[12394:3067499] end1 : 0.6718540191650391
         2015-08-19 13:54:14.245 Test[12394:3067499] end2 : 0.6632938385009766
         2015-08-19 13:54:14.891 Test[12394:3067499] end3 : 0.646111011505127
         2015-08-19 13:54:14.911 Test[12394:3067499] end4 : 0.01956701278686523
         2015-08-19 13:54:15.546 Test[12394:3067499] end5 : 0.6351327896118164
         
         2015-08-19 13:54:39.529 Test[12422:3069027] end1 : 0.6518650054931641
         2015-08-19 13:54:40.167 Test[12422:3069027] end2 : 0.6371870040893555
         2015-08-19 13:54:40.793 Test[12422:3069027] end3 : 0.6257219314575195
         2015-08-19 13:54:40.812 Test[12422:3069027] end4 : 0.01969623565673828
         2015-08-19 13:54:41.452 Test[12422:3069027] end5 : 0.6390390396118164
         
         2015-08-19 13:55:07.430 Test[12450:3070629] end1 : 0.6797499656677246
         2015-08-19 13:55:08.091 Test[12450:3070629] end2 : 0.6602680683135986
         2015-08-19 13:55:08.754 Test[12450:3070629] end3 : 0.6627740859985352
         2015-08-19 13:55:08.774 Test[12450:3070629] end4 : 0.02021598815917969
         2015-08-19 13:55:09.493 Test[12450:3070629] end5 : 0.718332052230835
         
         其他的调用方式都差不多， 唯有访址的速度最快。
         */
        
        
        before = [[NSDate date] timeIntervalSince1970];
        for (NSInteger i = maxTime; i>0; i--) {
            currentCount(100);
        }
        NSLog(@"end1 : %@", @([[NSDate date] timeIntervalSince1970] - before));
        
        before = [[NSDate date] timeIntervalSince1970];
        for (NSInteger i = maxTime; i>0; i--) {
            currentCount2(100);
        }
        NSLog(@"end2 : %@", @([[NSDate date] timeIntervalSince1970] - before));
        
        before = [[NSDate date] timeIntervalSince1970];
        for (NSInteger i = maxTime; i>0; i--) {
            currentCount3(100);
        }
        NSLog(@"end3 : %@", @([[NSDate date] timeIntervalSince1970] - before));
        
        before = [[NSDate date] timeIntervalSince1970];
        for (NSInteger i = maxTime; i>0; i--) {
            COUNT(100);
        }
        NSLog(@"end4 : %@", @([[NSDate date] timeIntervalSince1970] - before));
        
        before = [[NSDate date] timeIntervalSince1970];
        for (NSInteger i = maxTime; i>0; i--) {
            [self m_currentCount:10];
        }
        NSLog(@"end5 : %@", @([[NSDate date] timeIntervalSince1970] - before));
        
        /*
         2015-08-19 14:15:53.125 Test[12839:3098783] end1 : 0.02652907371520996
         2015-08-19 14:15:53.151 Test[12839:3098783] end2 : 0.02557611465454102
         2015-08-19 14:15:53.177 Test[12839:3098783] end3 : 0.02561593055725098
         2015-08-19 14:15:53.200 Test[12839:3098783] end4 : 0.02243208885192871
         2015-08-19 14:15:53.241 Test[12839:3098783] end5 : 0.04178404808044434
         
         2015-08-19 14:16:18.898 Test[12866:3100263] end1 : 0.02603387832641602
         2015-08-19 14:16:18.924 Test[12866:3100263] end2 : 0.02561211585998535
         2015-08-19 14:16:18.950 Test[12866:3100263] end3 : 0.02555108070373535
         2015-08-19 14:16:18.973 Test[12866:3100263] end4 : 0.02228498458862305
         2015-08-19 14:16:19.014 Test[12866:3100263] end5 : 0.04124903678894043
         
         2015-08-19 14:16:38.207 Test[12892:3101473] end1 : 0.02639889717102051
         2015-08-19 14:16:38.234 Test[12892:3101473] end2 : 0.0256659984588623
         2015-08-19 14:16:38.260 Test[12892:3101473] end3 : 0.02612519264221191
         2015-08-19 14:16:38.282 Test[12892:3101473] end4 : 0.02169227600097656
         2015-08-19 14:16:38.326 Test[12892:3101473] end5 : 0.04400491714477539
         */
    }
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(search)];
}

- (void)search
{
    GBSearchResultViewController *controller = [[GBSearchResultViewController alloc] initWithStyle:UITableViewStylePlain];
    
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:controller];
    [self presentViewController:navi animated:NO completion:nil];

//    
//    UISearchController *searchViewCOntroller = [[UISearchController alloc] initWithSearchResultsController:nil];
//    [self presentViewController:searchViewCOntroller animated:YES completion:nil];
}

- (NSString *)m_currentName:(ViewController *)vc
{
    return vc->_name;
}

- (NSInteger)m_currentCount:(NSInteger)count
{
    return count * REFACTOR;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
