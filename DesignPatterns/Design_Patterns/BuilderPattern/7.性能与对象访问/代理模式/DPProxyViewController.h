//
//  DPProxyViewController.h
//  Design_Patterns
//
//  Created by yixiaoluo on 15/9/8.
//  Copyright (c) 2015年 yixiaoluo. All rights reserved.
//

#import <UIKit/UIKit.h>

//动态代理：http://www.zhihu.com/question/20021706

@interface DPProxyViewController : UICollectionViewController

@end


//对于UICollectionViewController的useLayoutToLayoutNavigationTransitions属性，
//从API文档和iOS7 PTL的例子来看，使用流程必须这样:previous VC此属性为NO，next VC在push前此属性设为YES。
//push next VC后，next VC的dataSource为前者的dataSource，但是layout为后者的layout。
//NOTE: 不要用storyboard／xib