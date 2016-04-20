//
//  WBJSPathManager.m
//  workbench
//
//  Created by yixiaoluo on 15/9/16.
//  Copyright © 2015年 alibaba. All rights reserved.
//

#import "WBJSPathManager.h"
#import "JPEngine.h"

@implementation WBJSPathManager

+ (void)loadJSWithCode:(NSString *)jsCode
{
    if (jsCode.length == 0) { return; }
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [JPEngine startEngine];
    });
    [JPEngine evaluateScript:jsCode];
}

+ (void)downloadJSCode:(NSString *)updateUrl completion:(void(^)(NSString *jsCode))completion
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^(void) {
        NSError *error = nil;
        NSString *jsCode = nil;
        NSURL *URL = [NSURL URLWithString:updateUrl];
        NSData *data = [NSData dataWithContentsOfURL:URL options:NSDataReadingMappedAlways error:&error];
        if (!error) {
            jsCode = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        }
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            if (completion) {
                completion([jsCode copy]);
            }
        });
    });
}

#pragma mark - test code
+ (void)loadJSDemo
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"WBJSTest" ofType:@"js"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSString *js = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    [self loadJSWithCode:js];
}

+ (NSDictionary *)responseForTest
{
    return @{
             @"fileMd5": @"569b95b5fa291a988bb9a975c4e5fc3b", // hot patch文件的md5
             @"fileSize": @"75",   // hot patch文件大小
             @"needUpdate": @"1",  // 是否有hot patch升级包，1表示有，0表示没有，为0时其他几个字段不存在
             @"updateUrl": @"http://crm-wap.alitest.net:8555/mobile/client/alicrm2.do?platform=ios&file=UTB1FzPOXXXXXXcUXpXXJktXFXXXH.txt"
             };
}
@end
