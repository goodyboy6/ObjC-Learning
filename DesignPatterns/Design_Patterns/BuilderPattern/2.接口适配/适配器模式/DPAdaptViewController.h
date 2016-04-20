//
//  DPAdaptViewController.h
//  Design_Patterns
//
//  Created by yixiaoluo on 15/9/24.
//  Copyright © 2015年 yixiaoluo. All rights reserved.
//

#import <UIKit/UIKit.h>

//http://design-patterns.readthedocs.org/zh_CN/latest/structural_patterns/adapter.html?highlight=适配器模式
@interface DPAdaptViewController : UIViewController

@end

/*
 设计模式接触的越多，越觉他她们都很相似，前面看外观模式的时候觉得和中介者模式相似，查了下区别，还真有区别。
 
 现在看到这个适配器模式，模式的动机似乎和代理模式、外观模式很像，都是封装其他对象，对外提供合适的访问接口，内部实现对客户端透明。然后搜索了一下发现有个软考的哥们做了个总结：http://blog.csdn.net/zhangzijiejiayou/article/details/46278077

 自己的总结如下：代理模式倾向于控制内部对象做各种状态切换，参考我上面写的代理模式的demo；适配器倾向于对可能已经用于其他模块的现有的一些类进行重新的封装，组合出成客户端需要的接口类；中介者和外观在外观模式里面有总结。
 
 
 不同：
 代理：为其他对象提供一个代理以控制对这个对象的访问。
 适配器：将一个类的接口转换成客户希望的另外一个接口。adapter模式使得原本由于接口不兼容而不能一起工作的那些类可以一起工作。
 中介者模式：用一个中介对象来封装一系列的对象交互。中介者使各对象不需要显式地相互引用，从而使其耦合松散，而且可以独立地改变它们之间的交互。
 
 相同：
 代理：是在代理类中调用被代理的方法，由于代理和被代理的方法都是相同的，所以会抽象出公共的方法。
 适配器：适配器中调用被适配的方法。
 中介者：在中介者同时调用多个类中的方法，通过判断来对不同的方法进行传递信息。
 
 总结：这三个设计模式本质上都是一样的，在一个类中调用另一个类中的方法，从而来适配或减少耦合
 
 */
