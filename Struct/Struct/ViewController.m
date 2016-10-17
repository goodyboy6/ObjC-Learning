//
//  ViewController.m
//  Struct
//
//  Created by yixiaoluo on 2016/10/17.
//  Copyright © 2016年 yixiaoluo. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

typedef struct {
    int8_t age;
    int8_t sex;
    char *name;
    char *motherName;
} Contact;

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    NSDictionary *json = @{
                          @"type":@"callCommand",
                          @"content": @{//约定为字典
                                  @"age": @2,
                                  @"sex": @(NO),
                                  @"name": @"Yi Ran",
                                  @"motherName": @"崔宇"
                                  }
                          };
    
    //==>string
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:json options:0 error:nil];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    //==>json
    NSData *data1 = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data1 options:0 error:nil];
    
    //==>parse
    NSString *commandType = result[@"type"];
    NSDictionary *content = result[@"content"];
    if (commandType && content && [content isKindOfClass:[NSDictionary class]]) {
        
        Contact c;
        c.age = [content[@"age"] integerValue] ?: 0;
        c.sex = [content[@"sex"] integerValue] ?: 0;
        
        //name
        NSString *name = content[@"name"] ?: @"";
        const char *cName = [name UTF8String];
        c.name = (char *)cName;
        
        //motherName
        NSString *mName = content[@"motherName"] ?: @"";
        const char *cmName = [mName UTF8String];
        c.motherName = (char *)cmName;

        //struct==>NSData
        NSData *data = [NSData dataWithBytes:&c length:sizeof(c)];
        
        //NSData==>struct
        Contact copiedC;
        [data getBytes:&copiedC length:data.length];
        NSLog(@"age: %i, sex:%i, name:%@, motherName:%@",
              copiedC.age,
              copiedC.sex,
              [NSString stringWithUTF8String:copiedC.name],
              [NSString stringWithUTF8String:copiedC.motherName]);
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
