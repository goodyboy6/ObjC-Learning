//
//  UIImage+Helper.m
//  CADemo
//
//  Created by yixiaoluo on 15/11/10.
//  Copyright © 2015年 yixiaoluo. All rights reserved.
//

#import "UIImage+Helper.h"

NSString* CAD_DocumentOfSmallImage()
{
    return NSTemporaryDirectory();
}

@implementation UIImage (Helper)

+ (void)divideToSmallImageFromBigImageAtPath:(NSString *)filePath
                                  completion:(DividedHandler)handler
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^(void) {
        
        CGSize tileSize = CGSizeMake(256, 256);//tile layer default value
        NSString *outPath = CAD_DocumentOfSmallImage();
        
        UIImage *image = [UIImage imageWithContentsOfFile:filePath];
        CGImageRef fullImageRef = image.CGImage;
        
        NSInteger row = ceil(image.size.width/tileSize.width);
        NSInteger column = ceil(image.size.height/tileSize.height);
        
        NSMutableArray *imagePaths = [NSMutableArray array];
        for (NSInteger i=0; i<row; i++) {
            for (NSInteger j=0; j<column; j++) {
                CGRect subFrame = CGRectMake(i*tileSize.width, j*tileSize.height, tileSize.width, tileSize.height);
                
                NSString *imageName = [NSString stringWithFormat:@"_%02li_%02li.jpg", (long)i, (long)j];
                NSString *path = [outPath stringByAppendingString:imageName];
                
                CGImageRef ref = CGImageCreateWithImageInRect(fullImageRef, subFrame);
                UIImage *subImage = [UIImage imageWithCGImage:ref];
                NSData *subImageData = UIImageJPEGRepresentation(subImage, 1);
                CGImageRelease(ref);
                
                __unused BOOL saved = [subImageData writeToFile:path atomically:NO];
                
                [imagePaths addObject:path];
            }
        }

        dispatch_async(dispatch_get_main_queue(), ^(void) {
            if (handler) {
                handler(imagePaths);
            }
        });
    });
}

@end
