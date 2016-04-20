//
//  AVPlayerView.m
//  CADemo
//
//  Created by yixiaoluo on 15/11/11.
//  Copyright © 2015年 yixiaoluo. All rights reserved.
//

#import "AVPlayerView.h"
@import AVFoundation;

@implementation AVPlayerView

+ (Class)layerClass
{
    return [AVPlayerLayer class];
}

- (AVPlayerLayer *)playerLayer
{
    return (AVPlayerLayer *)self.layer;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setup];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    [self setup];
    return self;
}

- (void)setup
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"03000801C4" ofType:@"mp4"];
    [self playerLayer].player = [AVPlayer playerWithURL:[NSURL fileURLWithPath:filePath]];
    [[self playerLayer].player play];
    [self playerLayer].videoGravity = AVLayerVideoGravityResizeAspectFill;
}

@end
