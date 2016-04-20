//
//  WeChatAvtivity.m
//  Objccn Demo
//
//  Created by yixiaoluo on 15/9/21.
//  Copyright © 2015年 yixiaoluo. All rights reserved.
//

#import "WeChatAvtivity.h"

static NSString *const WBActivityTypeWeChat = @"objccn.wechat";

@implementation WeChatAvtivity

+ (UIActivityCategory)activityCategory
{
    return UIActivityCategoryShare;
}

- (nullable NSString *)activityType       // default returns nil. subclass may override to return custom activity type that is reported to completion handler
{
    return  WBActivityTypeWeChat;
}

- (nullable NSString *)activityTitle      // default returns nil. subclass must override and must return non-nil value
{
    return @"微信";
}

- (nullable UIImage *)activityImage       // default returns nil. subclass must override and must return non-nil value
{
    return [UIImage imageNamed:@"WeChat"];
}

- (BOOL)canPerformWithActivityItems:(NSArray *)activityItems   // override this to return availability of activity based on items. default returns NO
{
    return YES;
}

- (void)prepareWithActivityItems:(NSArray *)activityItems      // override to extract items and set up your HI. default does nothing
{
    
}

- (nullable UIViewController *)activityViewController   // return non-nil to have view controller presented modally. call activityDidFinish at end. default returns nil
{
    return nil;
}

- (void)performActivity                        // if no view controller, this method is called. call activityDidFinish when done. default calls [self activityDidFinish:NO]
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"未添加微信SDK" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];

    [[[UIApplication sharedApplication].windows[0] rootViewController] presentViewController:alert animated:YES completion:nil];
}

@end
