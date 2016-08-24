//
//  UIViewController+WBTextInput.h
//  TextInput
//
//  Created by yixiaoluo on 16/6/15.
//  Copyright © 2016年 yixiaoluo. All rights reserved.
//

#import <UIKit/UIKit.h>

static CGFloat kTextInputBarHeight = 132;//输入框高度

/**
 *  输入操作结果回调
 *
 *  @param text   输入返回值，已经去除了前后空格和破折号
 *  @param isCancel 是否是点击了取消。如果为YES，键盘会自动消失。
 *  @param dismissKeyboardHandler 当isCancel为NO，键盘不会消失，调用方调用此回调来控制键盘消失。
 */
typedef void(^ResultHandler)(NSString *text, BOOL isCancel, void(^dismissKeyboardHandler)(BOOL dismiss));

//布局对象
@interface TextInputLayout : NSObject
@property (nonatomic) NSString *cancelButtonTitle;//取消按钮，默认为“取消”
@property (nonatomic) NSString *okButtonTitle;//确定输入按钮，默认为“确认”
@property (nonatomic) NSString *inputTitle;//输入框标题，默认为“请输入”
@property (nonatomic) NSString *maxCount;//文字个数限制，默认为512，中英文都算1个
@end

@interface UIViewController (WBTextInput)

//开始进行输入操作
- (void)beginTextInputWithLayout:(TextInputLayout *)layout resultHandler:(ResultHandler)handler;

@end
