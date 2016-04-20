//
//  DPThumbnailView.h
//  Design_Patterns
//
//  Created by yixiaoluo on 15/9/8.
//  Copyright (c) 2015年 yixiaoluo. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, DPThumbnailProxyMode) {
    DPThumbnailProxyModeThumbnail = 0,
    DPThumbnailProxyModeOrigin
};

@protocol DPThumbnailProxyProtocol <NSObject>
@property (nonatomic, readonly) DPThumbnailProxyMode proxyMode;
@end


/*
 [image drawInRect:] 几张图片总体比用uiimageview少2M
 */
@interface DPThumbnailProxy : UIView

@property (nonatomic, weak) id<DPThumbnailProxyProtocol> delegate;

@property (nonatomic, readonly) BOOL isImageLoaded;
@property (nonatomic, readonly) UIImage *image;

@property (nonatomic, copy) NSURL *imagePath;

@end
