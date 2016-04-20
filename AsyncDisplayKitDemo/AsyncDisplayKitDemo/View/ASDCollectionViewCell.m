//
//  ASDCollectionViewCell.m
//  AsyncDisplayKitDemo
//
//  Created by yixiaoluo on 16/1/21.
//  Copyright © 2016年 yixiaoluo. All rights reserved.
//

#import "ASDCollectionViewCell.h"
#import "ASDCollectionViewModel.h"
#import "AsyncDisplayKit.h"
#import "ASDAnimatedImageNode.h"
#import "ASDGradientNode.h"

@interface ASDCollectionViewCell ()

@property (nonatomic) ASDisplayNode *canvasNode;//作为父node来控制subnode的显示，用cell.contentView控制太麻烦
@property (nonatomic) ASDGradientNode *gradientNode;//渐变色作为图片背景
@property (nonatomic) ASDAnimatedImageNode *imageNode;//图片

@property (nonatomic) NSBlockOperation *nodeConstructionOperation;

@end

@implementation ASDCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    //demo1 常规初始化方法：放在主线程；demo2参考configCellWithModel:方法：异步初始化
//    self.imageNode = ({
//        ASImageNode *imageNode = [self buildAnImageNode];
//        imageNode;
//    });
//    
//    [self.contentView.layer addSublayer:self.imageNode.layer];
    
    return self;
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    
    //如果self.imageNode为一个拥有多个subnode的结构，使用这个代码比较好，这样每个subnode是否进行绘制就可控了；目前是虫蛹了sellf.imagenode
    [self.nodeConstructionOperation cancel];
    
    [self.canvasNode recursivelySetDisplaySuspended:YES];
    [self.canvasNode.layer removeFromSuperlayer];
    self.canvasNode = nil;
}

- (void)configCellWithModel:(ASDCollectionViewModel *)model nodeConstructionQueue:(NSOperationQueue *)queue
{
    if (![self.nodeConstructionOperation isCancelled]) {
        [self.nodeConstructionOperation cancel];
    }
    
    NSBlockOperation *nodeConstructionOperation = [self nodeConstructionOperationWithModel:model];
    self.nodeConstructionOperation = nodeConstructionOperation;
    
//    if (self.imageNode) {
//        [self loadImageAsyncWithModel:model];
//        self.imageNode.frame = self.bounds;
//        return;
//    }
    
    //demo2:异步初始化、并布局对象
    __weak typeof(self) weakSelf = self;
    [self.nodeConstructionOperation addExecutionBlock:^{
        ASDCollectionViewCell *strongSelf = weakSelf;
        
        if ([strongSelf.canvasNode displaySuspended]) {
            return;
        }
        
        if ([strongSelf.nodeConstructionOperation isCancelled]) {
            return;
        }
        
        //初始化
        strongSelf.canvasNode = [ASDisplayNode new];//画布
        strongSelf.gradientNode = [ASDGradientNode new]; //背景色
        strongSelf.imageNode = [strongSelf buildAnImageNodeWithModel:model];//图片

        //布局
        strongSelf.canvasNode.frame = strongSelf.bounds;
        strongSelf.gradientNode.frame = strongSelf.bounds;
        strongSelf.imageNode.frame = strongSelf.bounds;
        
        strongSelf.canvasNode.layerBacked = YES;
        strongSelf.gradientNode.layerBacked = YES;
        strongSelf.imageNode.layerBacked = YES;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [strongSelf.contentView.layer addSublayer:strongSelf.canvasNode.layer];
            [strongSelf.canvasNode addSubnode:strongSelf.gradientNode];
            [strongSelf.canvasNode addSubnode:strongSelf.imageNode];
            
//            [strongSelf setNeedsLayout];//layoutSubviews may be called before image node created
//            [strongSelf loadImageAsyncWithModel:model]; //goto see ASNetworkImageNode
        });
    }];
    
    [queue addOperation:nodeConstructionOperation];
}

//- (void)layoutSubviews
//{
//    [super layoutSubviews];
//
//    //self.imageNode may be nil. goto see ASNetworkImageNode
//    self.imageNode.frame = self.bounds;
//}

#pragma mark - private
//goto see ASNetworkImageNode
- (void)loadImageAsyncWithModel:(ASDCollectionViewModel *)model
{
    ASBasicImageDownloader *downloader = [ASBasicImageDownloader sharedImageDownloader];
    
    NSURL *URL = [NSURL URLWithString:model.imageUrl];
    __weak typeof(self)weakSelf = self;
    [downloader downloadImageWithURL:URL
                       callbackQueue:dispatch_get_main_queue()
               downloadProgressBlock:nil
                          completion:^(CGImageRef image, NSError *error) {
                              
                              ASDCollectionViewCell *strongSelf2 = weakSelf;
                              
                              if (strongSelf2.nodeConstructionOperation != weakSelf.nodeConstructionOperation) {
                                  return;
                              }
                              
                              if ([strongSelf2.imageNode displaySuspended]) {
                                  return;
                              }
                              
                              if ([strongSelf2.nodeConstructionOperation isCancelled]) {
                                  return;
                              }
                              
                              strongSelf2.imageNode.image = [UIImage imageWithCGImage:image];
                          }];
}

//优势是可以放在任意的队列来执行
- (NSBlockOperation *)nodeConstructionOperationWithModel:(ASDCollectionViewModel *)model
{
    NSBlockOperation *operation = [[NSBlockOperation alloc] init];
    return operation;
}


//demo1
- (ASDAnimatedImageNode *)buildAnImageNodeWithModel:(ASDCollectionViewModel *)model
{
    ASDAnimatedImageNode *imageNode = [[ASDAnimatedImageNode alloc] init];
    imageNode.layerBacked = YES;
    imageNode.backgroundColor = [UIColor redColor];
    //    imageNode.placeholderEnabled = YES;
    //    imageNode.placeholderColor = [UIColor purpleColor];
    //    imageNode.placeholderFadeDuration = .5;
    
    //must called together
    //    imageNode.contentMode = UIViewContentModeScaleAspectFill;
    //    imageNode.cropEnabled = YES;
    
    imageNode.contentMode = UIViewContentModeScaleAspectFit;
    
    //对栅格化后得到的图片做处理
    imageNode.imageModificationBlock = ^UIImage *(UIImage *image){
        if (image == nil) {
            return nil;
        }
        
        UIGraphicsBeginImageContext(self.frame.size);
        
        [image drawInRect:(CGRect){.size = self.frame.size} blendMode:kCGBlendModePlusDarker alpha:1];
        
        image = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
        
        
        return image;
    };
    
    //回头才发现ASNetworkImageNode
    imageNode.URL = [NSURL URLWithString:model.imageUrl];
    
    return imageNode;
}

@end
