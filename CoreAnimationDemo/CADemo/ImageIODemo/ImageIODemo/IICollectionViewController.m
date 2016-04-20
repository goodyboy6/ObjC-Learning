//
//  IICollectionViewController.m
//  ImageIODemo
//
//  Created by yixiaoluo on 15/11/18.
//  Copyright © 2015年 yixiaoluo. All rights reserved.
//

#import "IICollectionViewController.h"

@interface IICollectionViewCell : UICollectionViewCell

@property (nonatomic) UIImageView *imageView;

@end

@interface BBTiledLayer : CATiledLayer

@end

@interface IICollectionViewController ()

@property (nonatomic) NSArray *imageArray;

@end

@implementation IICollectionViewController

static NSString * const reuseIdentifier = @"ii";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    [self.collectionView registerClass:[IICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    // Do any additional setup after loading the view.
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:1000];
    NSArray *items = [[NSBundle mainBundle] pathsForResourcesOfType:@"png" inDirectory:nil];
    for (NSInteger i = 0; i < 100; i++) {
        [array addObjectsFromArray:items];
    }
    self.imageArray = [array copy];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotate
{
    return NO;
}

static inline UIImage *scaleImage(UIImage *image, CGSize toSize)
{
    if (image.size.width > toSize.width || image.size.height > toSize.height ) {
        float widthRatio = toSize.width / image.size.width;
        float heightRatio = toSize.height / image.size.height;
        float scale = MIN(widthRatio, heightRatio);
        float imageWidth = scale * image.size.width;
        float imageHeight = scale * image.size.height;
        CGSize size = CGSizeMake(imageWidth, imageHeight);
        
        UIGraphicsBeginImageContextWithOptions(size, YES, 0);
        [image drawInRect:(CGRect){CGPointZero, size}];
        image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    
    return image;
}

#pragma mark - CALayerDelegate
- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx
{
    UIImage *image = [UIImage imageWithContentsOfFile:[layer valueForKey:@"imagePath"]];
    
    image = scaleImage(image, layer.frame.size);
    
    UIGraphicsPushContext(ctx);
    [image drawInRect:(CGRect){CGPointMake(0, layer.frame.size.height/2-image.size.height/2), image.size}];
    UIGraphicsPopContext();
}

#pragma mark <UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.imageArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    // Configure the cell
    [self configCell:(IICollectionViewCell *)cell atIndex:indexPath];
    
    return cell;
}

- (void)configCell:(IICollectionViewCell *)cell atIndex:(NSIndexPath *)indexPath
{
    NSString *imagePath = self.imageArray[indexPath.row];
    
    cell.tag = indexPath.row;
    
    //demo8:检测CFRunLoop的状态，当runloop即将休眠时进行预加载。
    
    //demo7: 在demo6的基础上加入预加载策略，在停止滚动的时候预加载图片放入cache
    //- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
    //- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
    
    //demo6: 提供缓存策略 能达到~59FPS
    static NSCache *cache = nil;
    if (!cache) {
        cache = [[NSCache alloc] init];
    }
    UIImage *cachedImage = [cache objectForKey:imagePath];
    if (cachedImage) {
        cell.imageView.image = cachedImage;
        return;
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^(void) {
        UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
        image = scaleImage(image, cell.imageView.frame.size) ;
        
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            if (cell.tag == indexPath.row) {
                cell.imageView.image = image;
                [cache setObject:image forKey:imagePath];
            }
        });
    });

    
    
    //demo5:先提供一个小图，停止滚动的时候提供清晰图
    //- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
    //- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
    
    
    //demo4:的确可达60FPS，但是tile一块一块显示，体验差了些
//    BBTiledLayer *layer = (BBTiledLayer *)[cell.contentView.layer.sublayers lastObject];
//    if (![layer isKindOfClass:[BBTiledLayer class]]) {
//        layer = [BBTiledLayer layer];
//        layer.frame = cell.bounds;
//        layer.delegate = self;
//        layer.contentsScale = [UIScreen mainScreen].scale;
//        layer.contentsGravity = kCAGravityResizeAspect;
//        [cell.contentView.layer addSublayer:layer];
//    }
//    layer.contents = nil;
//    [layer setValue:imagePath forKey:@"imagePath"];
//    [layer setNeedsDisplay];

    //demo3:~55FPS 好多了
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^(void) {
//        UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
//        image = scaleImage(image, cell.imageView.frame.size) ;
//        
//        dispatch_async(dispatch_get_main_queue(), ^(void) {
//            if (cell.tag == indexPath.row) {
//                cell.imageView.image = image;
//            }
//        });
//    });

    //demo2:~40FPS  比demo1还要卡
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^(void) {
//        UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
//        
//        dispatch_async(dispatch_get_main_queue(), ^(void) {
//            if (cell.tag == indexPath.row) {
//                cell.imageView.image = image;
//            }
//        });
//    });

    
    //demo1: ~42FPS帧每秒
    //cell.imageView.image = [UIImage imageWithContentsOfFile:imagePath];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    return CGSizeMake(self.view.bounds.size.width - [(UICollectionViewFlowLayout *)(self.collectionViewLayout) minimumLineSpacing], self.view.bounds.size.height);
}

@end

@implementation IICollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    [self setup];
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setup];
}

- (void)setup
{
    self.imageView = [[UIImageView alloc] init];
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:self.imageView];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.imageView.frame = self.contentView.bounds;
}

@end

@implementation BBTiledLayer

+ (CFAbsoluteTime)fadeDuration
{
    return 0.25;
}

@end
