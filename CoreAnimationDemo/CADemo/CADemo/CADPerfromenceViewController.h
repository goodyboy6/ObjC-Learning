//
//  CADPerfromenceViewController.h
//  CADemo
//
//  Created by yixiaoluo on 15/11/5.
//  Copyright © 2015年 yixiaoluo. All rights reserved.
//

#import <UIKit/UIKit.h>


//https://github.com/danielamitay/iOS-App-Performance-Cheatsheet/blob/master/QuartzCore.md
@interface CADPerfromenceViewController : UITableViewController

@end


/*
 在iOS中，软件绘图通常是由Core Graphics框架来完成。但是，在一些必要的情况下，相比Core Aniamtion和Open GL， Core Graphics要慢不少。
 
 软件绘图不仅效率低，还会消耗可观的内存。CALayer只需要一些与自己相关的内存：只有它的寄宿图会消耗一定的内存空间。只是直接赋值给contents属性一张图片，也不需要增加额外的图片存储大小。如果相同的一张图片被多个图层作为contetns属性，那么他们将会功用同一块内存，而不是复制内存块。
 
 但一旦你是吸纳了CALayerDelegate协议中的－drawLayer：inCOntext：方法或者UIView中的－drawRect：方法（其实就是前者包装的方法），图层久创建了一个绘制上下文，这个上下文需要的大小的内存可以计算出：图层宽＊图层高＊4字节，宽高的单位居委像素。对于一个在retina ipad上的全屏图层来说，这个内存就是2048*1536*4字节＝12M（ipad air是），图层每次重绘的时候都需要重新抹掉内存，然后从新分配。
 
 软件绘图的代价是昂贵的，除非据对必要，你应该避免重绘你的视图。提高绘制性能的秘诀就在于尽量避免去绘制。
 */