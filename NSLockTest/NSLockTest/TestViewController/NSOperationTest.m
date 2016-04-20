//
//  NSOperationTestViewController.m
//  NSLockTest
//
//  Created by yixiaoluo on 15/3/2.
//  Copyright (c) 2015年 cn.gikoo. All rights reserved.
//

#import "NSOperationTest.h"

@interface NSOperationTest ()

@end

@implementation NSOperationTest

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //here we let them in main thread (which will give us a better log), but only one method is being excuted controlled by semaphore
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(1);
    dispatch_group_t testGroup = dispatch_group_create();
    
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    dispatch_queue_t backgroundQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
    
    
    NSLog(@"----------all operation tests begin------------");
    
    dispatch_group_async(testGroup, backgroundQueue, ^{
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        [self customOperationTestCompletion:^{
            dispatch_semaphore_signal(semaphore);
        }];
    });

    dispatch_group_async(testGroup, backgroundQueue, ^{
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        [self invocationOperationTestCompletion:^{
            dispatch_semaphore_signal(semaphore);
        }];
    });
    
    dispatch_group_async(testGroup, backgroundQueue, ^{
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        [self blockOperationTestCompletion:^{
            dispatch_semaphore_signal(semaphore);
        }];
    });

    dispatch_group_async(testGroup, backgroundQueue, ^{
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        [self operationQueueTestCompletion:^{
            dispatch_semaphore_signal(semaphore);
        }];
    });

    dispatch_group_notify(testGroup, mainQueue, ^{
        NSLog(@"----------all operation tests end------------");
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Test methods
/**
 *  NSInvocationOperation的好处是，可以向任意的target发送message；而NSBlockOperation不能做到这样，只能向自己发message，但执行主体是block，显然在向自己发message时，比前者这有优势。
 */
- (void)invocationOperationTestCompletion:(dispatch_block_t)compeltion
{
    NSLog(@"1. %@ - %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    
    NSInvocationOperation *invocationOp = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(invocationMethod) object:nil];
    invocationOp.completionBlock = ^{
        NSLog(@"NSInvocationOperation finished");
        compeltion();
    };
    [invocationOp start];
}

- (void)blockOperationTestCompletion:(dispatch_block_t)compeltion
{
    NSLog(@"2. %@ - %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    NSBlockOperation *blockOp = [[NSBlockOperation alloc] init];
    [blockOp addExecutionBlock:^{
        sleep(2);
    }];
    blockOp.completionBlock = ^{
        NSLog(@"NSBlockOperation finished");
        compeltion();
    };
    [blockOp start];
}

- (void)operationQueueTestCompletion:(dispatch_block_t)compeltion
{
    NSLog(@"3. %@ - %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));

    NSBlockOperation *op1 = [[NSBlockOperation alloc] init];
    [op1 addExecutionBlock:^{
        sleep(2);
    }];
    op1.completionBlock = ^{
        NSLog(@"op1 finished");
    };
    
    NSBlockOperation *op2 = [[NSBlockOperation alloc] init];
    [op2 addExecutionBlock:^{
        sleep(2);
    }];
    op2.completionBlock = ^{
        NSLog(@"op2 finished");
    };
    
    NSInvocationOperation *op3 = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(invocationMethod) object:nil];
    op3.completionBlock = ^{
        NSLog(@"op3 finished");
        compeltion();
    };
    
    //so op3 will be the last one that completed
    //execution sequence will be  op2, op1, op3
    [op1 addDependency:op2];
    [op3 addDependency:op1];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    queue.maxConcurrentOperationCount = 3;//althrough is concurrent, there are dependencies bettween them, they will be serial
    [queue addOperation:op1];
    [queue addOperation:op2];
    [queue addOperation:op3];
}

- (void)customOperationTestCompletion:(dispatch_block_t)compeltion
{
    NSLog(@"4. %@ - %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    
    NSString *url = @"http://ww1.sinaimg.cn/bmiddle/479e8d54jw1epzel9teg2j20rs5qgkjl.jpg";

    ImageDownloadOperation *downloadOp = [[ImageDownloadOperation alloc] initWithImageURL:[NSURL URLWithString:url] compeltion:^(UIImage *image) {
        NSLog(@"image finished");
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
            
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            [self.view addSubview:imageView];
            imageView.center = self.view.center;
            
            compeltion();
        }];
    }];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue addOperation:downloadOp];
}

#pragma mark - Private
- (void)invocationMethod
{
    sleep(5);
}

@end


@interface ImageDownloadOperation ()
<
NSURLConnectionDelegate
>

@property (nonatomic) NSURL *imageURL;
@property (nonatomic) NSMutableData *imageData;

@property (nonatomic) DownloadStatus status;
@property (nonatomic) NSURLConnection *connection;

@property (nonatomic) BOOL isFinished;

@end

@implementation ImageDownloadOperation

- (void)main
{
    //do not overwrite all other methods, main() will be called
    //completion block will be automatic called .  the truth is when main is over, the operation is finished
    @autoreleasepool {
        while (!self.isFinished && !self.isCancelled) {
            self.isFinished = NO;
            self.imageData = [[NSMutableData alloc] initWithContentsOfURL:self.imageURL];
            self.isFinished = YES;
        }
    }
}

- (instancetype)initWithImageURL:(NSURL *)url compeltion:(void (^)(UIImage *))downloadCompletion
{
    self = [super init];
    
    self.imageURL = url;

    __weak typeof(self) weakSelf = self;
    self.completionBlock = ^{
        downloadCompletion([[UIImage alloc] initWithData:weakSelf.imageData]);
    };

    return self;
}

#pragma mark - NSOperation
- (void)start
{

    NSURLRequest *request = [NSURLRequest requestWithURL:_imageURL];
    self.connection = [NSURLConnection connectionWithRequest:request delegate:self];
    [self.connection start];
    
    NSRunLoop *currentRunLoop = [NSRunLoop currentRunLoop];
    [self.connection scheduleInRunLoop:currentRunLoop forMode:NSRunLoopCommonModes];
    [currentRunLoop run];
}

- (void)cancel
{
    if (self.isExecuting) {
        [self.connection cancel];
    }
    
    [self willChangeValueForKey:@"isCancelled"];
    self.status = kUnstart;
    [self didChangeValueForKey:@"isCancelled"];
}

- (BOOL)isExecuting
{
    return self.status == kDownloading;
}

- (BOOL)isFinished
{
    return self.status == kDownloaded;
}

- (BOOL)isConcurrent
{
    return YES;
}

- (BOOL)isAsynchronous
{
    return YES;
}

- (BOOL)isReady
{
    return YES;
}

#pragma mark - NSURLConnectionDataDelegate
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    self.imageData = [NSMutableData data];
    
    [self willChangeValueForKey:@"isFinished"];
    [self willChangeValueForKey:@"isExecuting"];
    self.status = kUnstart;
    [self didChangeValueForKey:@"isExecuting"];
    [self didChangeValueForKey:@"isFinished"];

    NSLog(@"didReceiveResponse");
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.imageData appendData:data];
    
    [self willChangeValueForKey:@"isFinished"];
    [self willChangeValueForKey:@"isExecuting"];
    self.status = kDownloading;
    [self didChangeValueForKey:@"isExecuting"];
    [self didChangeValueForKey:@"isFinished"];

    NSLog(@"didReceiveData : %d", _imageData.length);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"DidFinishLoading");

    [self willChangeValueForKey:@"isFinished"];
    [self willChangeValueForKey:@"isExecuting"];
    self.status = kDownloaded;
    [self didChangeValueForKey:@"isExecuting"];
    [self didChangeValueForKey:@"isFinished"];
}

@end

