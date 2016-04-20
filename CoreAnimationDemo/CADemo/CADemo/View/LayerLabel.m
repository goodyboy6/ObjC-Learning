//
//  LayerLabel.m
//  CADemo
//
//  Created by yixiaoluo on 15/11/5.
//  Copyright © 2015年 yixiaoluo. All rights reserved.
//

#import "LayerLabel.h"

@implementation LayerLabel

+ (Class)layerClass
{
    return [CATextLayer class];
}

- (CATextLayer *)textLayer
{
    return (CATextLayer *)self.layer;
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
    //uilabel will do it for us
    //[self textLayer].contentsScale = [UIScreen mainScreen].scale;
    
    [self textLayer].alignmentMode = kCAAlignmentCenter;
    
    //will in bounds
    [self textLayer].wrapped = YES;
}

#pragma mark - setter && getter
- (void)setText:(NSString *)text
{
    [self textLayer].string = text;
}

- (void)setTextColor:(UIColor *)textColor
{
    [self textLayer].foregroundColor = textColor.CGColor;
}

- (void)setFont:(UIFont *)font
{
    NSString *fontName = font.fontName;
    CGFontRef  fontRef = CGFontCreateWithFontName((__bridge CFStringRef)fontName);
    [self textLayer].font = fontRef;
    [self textLayer].fontSize = font.pointSize;
    CGFontRelease(fontRef);
}

@end
