//
//  UIViewController+WBTextInput.m
//  TextInput
//
//  Created by yixiaoluo on 16/6/15.
//  Copyright © 2016年 yixiaoluo. All rights reserved.
//

#import "UIViewController+WBTextInput.h"
#import "masonry.h"
#import "BlocksKit+UIKit.h"

static NSInteger kTextInputViewTag = 1360000;//输入框视图tag
static NSInteger kCoverViewTag = 1360001;//灰色背景tag

@class TextInputView;
typedef void(^TextInputResultHandler)(TextInputView *view, NSString *text, BOOL isCancel);

@interface TextInputView : UIView <UITextViewDelegate>
@property (nonatomic, copy) void(^keyboardHiddenStatusHandler)(TextInputView *view, CGFloat keyboardHeight, CGFloat animatedDuring, BOOL hidden);//键盘弹出状态
- (void)setLayout:(TextInputLayout *)layout callBack:(TextInputResultHandler)resultHandler;
@end

@implementation UIViewController (WBTextInput)

- (void)beginTextInputWithLayout:(TextInputLayout *)layout resultHandler:(ResultHandler)handler;
{
    layout = layout ?: [TextInputLayout new];

    TextInputView *textInputView = [self.view viewWithTag:kTextInputViewTag];
    
    //清空可能遗留原有图层
    [textInputView removeFromSuperview];
    [[self.view viewWithTag:kCoverViewTag] removeFromSuperview];
    
    //添加新输入图层
    textInputView = [[TextInputView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, kTextInputBarHeight)];
    textInputView.tag = kTextInputViewTag;
    [self.view addSubview:textInputView];
    
    [textInputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).offset(kTextInputBarHeight);
        make.leading.equalTo(self.view.mas_leading);
        make.trailing.equalTo(self.view.mas_trailing);
        make.height.mas_equalTo(kTextInputBarHeight);
    }];
    
    [textInputView setLayout:layout callBack:^(TextInputView *view, NSString *text, BOOL isCancel) {
        if (isCancel) {
            [view endEditing:YES];
        }
        if (handler) {
            handler(text, isCancel, ^(BOOL success){
                if (success) {
                    [view endEditing:YES];
                }
            });
        }
    }];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [textInputView becomeFirstResponder];
    });
    
    __weak typeof(self) weakSelf = self;
    textInputView.keyboardHiddenStatusHandler = ^(TextInputView *textInputView, CGFloat keyboardHeight, CGFloat animatedDuring, BOOL hidden){
        __strong typeof(self) self = weakSelf;
        UIView *coverView = [self.view viewWithTag:kCoverViewTag];
        
        if (!hidden) {
            [coverView removeFromSuperview];
            
            coverView = [[UIView alloc] initWithFrame:self.view.bounds];
            coverView.tag = kCoverViewTag;
            coverView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.0];
            [self.view insertSubview:coverView belowSubview:textInputView];

            [coverView bk_whenTapped:^{
                [textInputView endEditing:YES];
            }];

            [textInputView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(textInputView.superview.mas_bottom).offset(-keyboardHeight);
            }];
            [UIView animateWithDuration:animatedDuring animations:^{
                coverView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.4];
                [self.view layoutIfNeeded];
            }];
        }else{
            [textInputView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self.view.mas_bottom).offset(kTextInputBarHeight);
            }];
            
            [UIView animateWithDuration:animatedDuring animations:^{
                coverView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.0];
                [self.view layoutIfNeeded];
            } completion:^(BOOL finished) {
                [textInputView removeFromSuperview];
                [coverView removeFromSuperview];
            }];
        }
    };
}

@end

@implementation TextInputLayout

- (instancetype)init
{
    self = [super init];
    _cancelButtonTitle = @"取消";
    _okButtonTitle = @"确认";
    _inputTitle = @"请输入";
    _maxCount = @"12";
    return self;
}

@end


CGFloat kBarHeight = 30;
CGFloat kButtonFontSize = 16;

@implementation TextInputView{
    UIButton *_okButton;
    UIButton *_cancelButton;
    UILabel *_titleLabel;
    UITextView *_textView;
    UILabel *_maxCountTipLabel;

    TextInputLayout *_layout;
    TextInputResultHandler _resultHandler;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    UIColor *bgColor = [UIColor colorWithRed:238/255. green:238/255. blue:238/255. alpha:1];
    UIColor *enabledColor = [UIColor darkGrayColor];
    
    self.backgroundColor = bgColor;
    
    //添加控件
    UIView *bar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, kBarHeight)];
    bar.backgroundColor = self.backgroundColor;
    [self addSubview:bar];
    
    UIButton *(^getAButton)(NSString *title, SEL sel) = ^(NSString *title, SEL sel){
        UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [cancelButton setTitle:title forState:UIControlStateNormal];
        [cancelButton setTitleColor:enabledColor forState:UIControlStateNormal];
        cancelButton.titleLabel.font = [UIFont systemFontOfSize:kButtonFontSize];
        [cancelButton addTarget:self action:sel forControlEvents:UIControlEventTouchUpInside];
        return cancelButton;
    };
    
    _cancelButton = getAButton(nil, @selector(cancel));
    [_cancelButton setContentHuggingPriority:UILayoutPriorityRequired+1 forAxis:UILayoutConstraintAxisHorizontal];
    [bar addSubview:_cancelButton];
    
    _okButton = getAButton(nil, @selector(save));
    _okButton.frame = CGRectMake(bar.frame.size.width-60, 0, 60, bar.frame.size.height);
    [_okButton setContentHuggingPriority:UILayoutPriorityRequired+1 forAxis:UILayoutConstraintAxisHorizontal];
    [bar addSubview:_okButton];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, bar.frame.size.height)];
    _titleLabel.textColor = enabledColor;
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.font = [UIFont systemFontOfSize:kButtonFontSize];
    [bar addSubview:_titleLabel];

    _textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 44, frame.size.width, frame.size.height - bar.frame.size.height)];
    _textView.font = [UIFont systemFontOfSize:kButtonFontSize];
    _textView.delegate = self;
    _textView.layer.cornerRadius = 5;
    _textView.layer.borderWidth = 1;
    _textView.layer.borderColor = [UIColor colorWithRed:232/255. green:232/255. blue:232/255. alpha:1].CGColor;
    [self addSubview:_textView];
    
    _maxCountTipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, frame.size.height - 20, frame.size.width, 20)];
    _maxCountTipLabel.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:.3];
    _maxCountTipLabel.textColor = [UIColor redColor];
    _maxCountTipLabel.textAlignment = NSTextAlignmentRight;
    _maxCountTipLabel.font = [UIFont systemFontOfSize:14];
    [self addSubview:_maxCountTipLabel];
    
    //添加布局依赖
    [bar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.mas_leading);
        make.trailing.equalTo(self.mas_trailing);
        make.top.equalTo(self.mas_top);
        make.height.mas_equalTo(kBarHeight);
    }];
    
    [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.mas_leading).offset(17);
        make.trailing.equalTo(self.mas_trailing).offset(-17);
        make.top.equalTo(bar.mas_bottom);
        make.bottom.equalTo(self.mas_bottom).offset(-8);
    }];
    
    [_cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(_cancelButton.superview.mas_leading).offset(10);
        make.top.equalTo(_cancelButton.superview.mas_top);
        make.bottom.equalTo(_cancelButton.superview.mas_bottom);
    }];
    
    [_okButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(_okButton.superview.mas_trailing).offset(-10);
        make.top.equalTo(_okButton.superview.mas_top);
        make.bottom.equalTo(_okButton.superview.mas_bottom);
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(_cancelButton.mas_trailing).offset(10);
        make.top.equalTo(_titleLabel.superview.mas_top);
        make.bottom.equalTo(_titleLabel.superview.mas_bottom);
        make.trailing.equalTo(_okButton.mas_leading).offset(-10);
    }];

    [_maxCountTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(_maxCountTipLabel.superview).offset(-23);
        make.bottom.equalTo(_maxCountTipLabel.superview).offset(-15);
    }];
    
    //添加键盘服务
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)setLayout:(TextInputLayout *)layout callBack:(TextInputResultHandler)resultHandler;
{
    _layout = layout;
    _resultHandler = [resultHandler copy];
    
    [_okButton setTitle:_layout.okButtonTitle forState:UIControlStateNormal];
    [_cancelButton setTitle:_layout.cancelButtonTitle forState:UIControlStateNormal];
    _titleLabel.text = _layout.inputTitle;
    _maxCountTipLabel.hidden = _layout.maxCount == nil;
    
    //初始化状态
    [self textViewDidChange:_textView];
}

- (BOOL)becomeFirstResponder
{
    return [_textView becomeFirstResponder];
}

#pragma mark - notification
- (void)keyboardWillShow:(NSNotification *)noti
{
    NSDictionary *info = [noti userInfo];
    CGFloat keyboardHeight = [info[UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    CGFloat duration = [info[UIKeyboardAnimationDurationUserInfoKey] floatValue];

    if (self.keyboardHiddenStatusHandler) {
        self.keyboardHiddenStatusHandler(self, keyboardHeight, duration, NO);
    }
}

- (void)keyboardWillHide:(NSNotification *)noti
{
    NSDictionary *info = [noti userInfo];
    CGFloat duration = [info[UIKeyboardAnimationDurationUserInfoKey] floatValue];

    if (self.keyboardHiddenStatusHandler) {
        self.keyboardHiddenStatusHandler(self, 0, duration, YES);
    }
}

#pragma mark - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView
{
    NSString *text = [_textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSInteger maxCount = _layout.maxCount ? _layout.maxCount.integerValue : LONG_MAX;
    
    UIColor *enabledColor = [UIColor darkGrayColor];
    UIColor *disabledColor = [[UIColor lightGrayColor] colorWithAlphaComponent:.7];

    BOOL greaterThanMaxCount = text.length > maxCount;
    BOOL buttonDisabled = greaterThanMaxCount || text.length == 0;
    
    [_okButton setTitleColor:buttonDisabled ? disabledColor : enabledColor forState:UIControlStateNormal];
    _okButton.userInteractionEnabled = !buttonDisabled;
    
    _maxCountTipLabel.textColor = greaterThanMaxCount ? [UIColor redColor] : disabledColor;
    
    NSString *tip = nil;
    if (greaterThanMaxCount) {
        tip = [NSString stringWithFormat:@"已超过%lu字", text.length - maxCount];
    }else{
        tip = [NSString stringWithFormat:@"还剩%lu字", maxCount - text.length];
    }
    _maxCountTipLabel.text = tip;
}

#pragma mark - event response
- (void)save
{
    if (_resultHandler) {
        _resultHandler(self, [_textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]], NO);
    }
}

- (void)cancel
{
    if (_resultHandler) {
        _resultHandler(self, nil, YES);
    }
}
@end
