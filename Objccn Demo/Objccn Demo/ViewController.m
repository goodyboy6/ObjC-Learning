//
//  ViewController.m
//  Objccn Demo
//
//  Created by yixiaoluo on 15/9/21.
//  Copyright © 2015年 yixiaoluo. All rights reserved.
//

#import "ViewController.h"
#import <SafariServices/SafariServices.h>
#import "WeChatAvtivity.h"

@interface ViewController ()
<
SFSafariViewControllerDelegate
>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    SFSafariViewController *safari = [[SFSafariViewController alloc] initWithURL:[NSURL URLWithString:@"http://objccn.io"] entersReaderIfAvailable:YES];
    safari.delegate = self;
    [self pushViewController:safari animated:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - delegate
/*! @abstract Called when the view controller is about to show UIActivityViewController after the user taps the action button.
 @param URL, the URL of the web page.
 @param title, the title of the web page.
 @result Returns an array of UIActivity instances that will be appended to UIActivityViewController.
 */
- (NSArray<UIActivity *> *)safariViewController:(SFSafariViewController *)controller activityItemsForURL:(NSURL *)URL title:(nullable NSString *)title
{
    WeChatAvtivity *activity = [[WeChatAvtivity alloc] init];
    return @[activity];
}

/*! @abstract Delegate callback called when the user taps the Done button. Upon this call, the view controller is dismissed modally. */
- (void)safariViewControllerDidFinish:(SFSafariViewController *)controller
{

}

/*! @abstract Invoked when the initial URL load is complete.
 @param success YES if loading completed successfully, NO if loading failed.
 @discussion This method is invoked when SFSafariViewController completes the loading of the URL that you pass
 to its initializer. It is not invoked for any subsequent page loads in the same SFSafariViewController instance.
 */
- (void)safariViewController:(SFSafariViewController *)controller didCompleteInitialLoad:(BOOL)didLoadSuccessfully
{

}

@end
