//
//  ViewController.m
//  __Attribute__Demo
//
//  Created by yixiaoluo on 15/11/5.
//  Copyright © 2015年 yixiaoluo. All rights reserved.
//

#import "ViewController.h"

int my_printf (void *my_object, const char *my_format, ...)
{
    NSLog(@"%s%s", my_object, my_format);
    return 1;
}

NSString * NSStringFromStrings(NSString *str1, NSString *str2, NSInteger i)
{
    return @"test __attribute__((nonnull (1,2)))";
}

void __attribute__((noreturn)) die(const char *format, ...)
{
    exit(0);
}

//c函数重载
__attribute__((overloadable)) void foo(int a){
    printf("%d\n",a);
}
__attribute__((overloadable)) void foo(float a){
    printf("%f\n",a);
}

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    __unused NSString *tt = [NSString stringWithFormat:@"%@", @"tt"];
    
    __unused NSString *eee = NSStringFromStrings(@" ", @" ", 0);
    
    [NSString stringWithFormat:@"%@", @"dsada"];
    
    char *chas = "fffff";
    void *ttt = "tttt";
    my_printf(ttt, chas, @"yyyyyyy");
    
    NSString *fff = [self test];
    
    fios();
}

-  (NSString *)test
{
    return nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
