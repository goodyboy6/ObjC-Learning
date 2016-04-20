//
//  DPThumbnailView.m
//  Design_Patterns
//
//  Created by yixiaoluo on 15/9/8.
//  Copyright (c) 2015年 yixiaoluo. All rights reserved.
//

#import "DPThumbnailProxy.h"

static inline NSCache * dp_defaultCache(){
    static NSCache *imageCache = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        imageCache = [[NSCache alloc] init];
        imageCache.totalCostLimit = 20*1024*1024;//20M
    });
    
    return imageCache;
}

@interface DPThumbnailProxy ()

@property (nonatomic, readwrite) UIImage *image;
@property (nonatomic, readwrite) BOOL isImageLoaded;
@property (nonatomic) UIActivityIndicatorView *indicator;

@property (nonatomic) UIImageView *imageView;

@end

@implementation DPThumbnailProxy

#pragma mark - setter && getter
- (UIImage *)image
{
    if (_image == nil) {
        UIImage *tempImage = nil;
        if ([self.imagePath isFileURL]) {
            tempImage = [UIImage imageWithContentsOfFile:self.imagePath.absoluteString];
        }else{
            NSData *imageData = [NSData dataWithContentsOfURL:self.imagePath];
            tempImage = [UIImage imageWithData:imageData];
        }
        
        _image = [self cropImage:tempImage];
        [self cacheImage:tempImage forKey:[self originImageCacheName]];
        [self cacheImage:_image forKey:[self thumbnailImageCacheName]];
    }else{
        _image = [self imageFromCache];
    }
    return _image;
}

//cell重用问题
- (void)setImagePath:(NSURL *)imagePath
{
    if (self.imagePath && ![imagePath isEqual: self.imagePath]) {
        _imagePath = imagePath;
        
        UIImage *cachedImage = [self imageFromCache];
        
        if (cachedImage) {
            self.image = cachedImage;
            self.isImageLoaded = YES;
        }else{
            self.image = nil;
            self.isImageLoaded = NO;
        }
        
        [self setNeedsLayout];
    }else{
        _imagePath = imagePath;
    }
}

#pragma mark - imageCache
- (UIImage *)imageFromCache
{
    UIImage *cachedImage = nil;
    
    if ([self.delegate proxyMode] == DPThumbnailProxyModeThumbnail) {
        cachedImage = [self imageCachedForKey:[self thumbnailImageCacheName]];
    }else{
        cachedImage = [self imageCachedForKey:[self originImageCacheName]];
    }
    
    return cachedImage;
}

- (NSString *)thumbnailImageCacheName
{
    return self.imagePath.absoluteString;
}

- (NSString *)originImageCacheName
{
    return [[self.imagePath.absoluteString dataUsingEncoding:NSUTF8StringEncoding] base64EncodedStringWithOptions:0];
}

- (UIImage *)imageCachedForKey:(NSString *)key
{
    return [dp_defaultCache() objectForKey:key];
}

- (void)cacheImage:(UIImage *)image forKey:(NSString *)key
{
    [dp_defaultCache() setObject:image forKey:key];
}

#pragma mark - image handle
- (UIImage *)cropImage:(UIImage *)img
{
    CGFloat scale = [UIScreen mainScreen].scale;
    CGFloat xFactor = img.size.width/self.frame.size.width;
    CGFloat yFactor = img.size.height/self.frame.size.height;
    CGFloat scaleFactor = xFactor > yFactor ? xFactor : yFactor;
    
    CGSize size = CGSizeMake(img.size.width/scaleFactor*scale, img.size.height/scaleFactor*scale);
    
    UIGraphicsBeginImageContext(size);
    [img drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //字节对齐处理
    //...
    
    return image;
}

- (CGRect)imageDrawRect:(CGRect)rect
{
    CGPoint origin = CGPointZero;
    
    CGFloat scale = [UIScreen mainScreen].scale;
    CGSize imageSize = CGSizeZero;
    if (self.image.size.width < self.frame.size.width && self.image.size.height < self.frame.size.height) {
        imageSize = self.image.size;
    }else{
        imageSize = CGSizeMake(self.image.size.width/scale, self.image.size.height/scale);
    }
    
    origin.y = (self.frame.size.height - imageSize.height)/2;
    origin.x = (self.frame.size.width - imageSize.width)/2;
    
    CGSize size = CGSizeMake(rect.size.width - 2*origin.x, rect.size.height - 2*origin.y);
    
    return (CGRect){origin, size};
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (!self.imageView) {
        self.imageView = [[UIImageView alloc] init];
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:self.imageView];
    }
    
    self.imageView.frame = self.bounds;
    
    if (self.isImageLoaded) {
        self.image = [self imageCachedForKey:[self originImageCacheName]];
        self.imageView.image = self.image;
    }
}

#pragma mark - draw
- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (!self.isImageLoaded) {
        
        //虚线框
        //虚线宽度
        CGContextSetLineWidth(context, 2);
        
        //设置为虚线
        const CGFloat dashLengths[2] = {10, 3};
        CGContextSetLineDash(context, 3, dashLengths, 2);
        
        //虚线颜色
        CGContextSetStrokeColorWithColor(context, [UIColor lightGrayColor].CGColor);
        CGContextStrokeRect(context, rect);
        
        //矩形框填充色
        CGContextSetFillColorWithColor(context, [[UIColor lightGrayColor] colorWithAlphaComponent:.3].CGColor);
        CGContextFillRect(context, rect);
        
        //loading动画
        if (!self.indicator) {
            UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            indicator.hidesWhenStopped = YES;
            [self addSubview:indicator];
            indicator.center = CGPointMake(CGRectGetWidth(self.frame)/2, CGRectGetHeight(self.frame)/2);
            self.indicator = indicator;
        }
        [self.indicator startAnimating];
        
        //加载图片
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            self.isImageLoaded = NO;
            [self image];
            self.isImageLoaded = YES;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self setNeedsDisplay];
                [self setNeedsLayout];
            });
        });
    }else{
        [self.indicator stopAnimating];
        
        //        CGContextSetFillColorWithColor(context, [UIColor blackColor].CGColor);
        //        CGContextFillRect(context, rect);
        //
        //        [self.image drawInRect:[self imageDrawRect:rect]];
    }
}

@end
