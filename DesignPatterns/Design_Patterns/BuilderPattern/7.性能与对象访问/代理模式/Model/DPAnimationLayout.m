//
//  DPAnimationLayout.m
//  Design_Patterns
//
//  Created by yixiaoluo on 15/9/21.
//  Copyright © 2015年 yixiaoluo. All rights reserved.
//

#import "DPAnimationLayout.h"

@interface DPAnimationLayout ()

@property (nonatomic) NSMutableArray *indexPathsToAnimated;

@end

@implementation DPAnimationLayout

- (instancetype)init
{
    self = [super init];
    
    self.itemSize = CGSizeMake(90, 90);
    self.sectionInset = UIEdgeInsetsMake(64, 0, 0, 0);
    
    return self;
}

- (UICollectionViewLayoutAttributes *)initialLayoutAttributesForAppearingItemAtIndexPath:(NSIndexPath *)itemIndexPath
{
    UICollectionViewLayoutAttributes *attribute = [self layoutAttributesForItemAtIndexPath:itemIndexPath];
    
//    if ([self.indexPathsToAnimated containsObject:itemIndexPath]) {
//        attribute.transform = CGAffineTransformRotate(CGAffineTransformMakeScale(2, 2), 0);
//        [self.indexPathsToAnimated removeObject:itemIndexPath];
//    }
    
    return attribute;
}

- (void)prepareForCollectionViewUpdates:(NSArray<UICollectionViewUpdateItem *> *)updateItems
{
    [super prepareForCollectionViewUpdates:updateItems];
    
//    NSMutableArray *indexPathsToAnimated = [NSMutableArray array];
//    
//    [updateItems enumerateObjectsUsingBlock:^(UICollectionViewUpdateItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        switch (obj.updateAction) {
//            case UICollectionUpdateActionInsert:
//                [indexPathsToAnimated addObject:obj.indexPathAfterUpdate];
//                break;
//            case UICollectionUpdateActionDelete:
//                [indexPathsToAnimated addObject:obj.indexPathBeforeUpdate];
//                break;
//            case UICollectionUpdateActionMove:
//                [indexPathsToAnimated addObject:obj.indexPathBeforeUpdate];
//                [indexPathsToAnimated addObject:obj.indexPathAfterUpdate];
//                break;
//            default:
//                break;
//        }
//    }];
//    
//    self.indexPathsToAnimated = indexPathsToAnimated;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    CGRect oldBounds = self.collectionView.bounds;
    if (!CGSizeEqualToSize(oldBounds.size, newBounds.size)) {
        return YES;
    }
    return NO;
}

@end
