//
//  NSOperationTestViewController.h
//  NSLockTest
//
//  Created by yixiaoluo on 15/3/2.
//  Copyright (c) 2015年 cn.gikoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSOperationTest : UIViewController

@end

/**
 *  NSOperation本身是个抽象类，不能直接使用，只能使用系统封装好的NSBlockOperation和NSInvocationOperation，或者自己定制一个
 *  这个类我们封装了一个用于图片下载的operation
 */
typedef NS_ENUM(NSUInteger, DownloadStatus) {
    kDownloading,
    kDownloaded,
    kUnstart
};

@interface ImageDownloadOperation : NSOperation

- (instancetype)initWithImageURL:(NSURL *)url
                      compeltion:(void(^)(UIImage *image))downloadCompletion;

@end

