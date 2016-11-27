//
//  WXHTagViewController.m
//  Best
//
//  Created by 初七 on 2016/11/25.
//  Copyright © 2016年 nemo. All rights reserved.
//

#import "WXHTagViewController.h"
#import "WXHTagTextField.h"
#import "WXHTagButton.h"
#import <SVProgressHUD.h>
@interface WXHTagViewController ()<UITextFieldDelegate>
/** 所有的标签按钮 */
@property (nonatomic, strong) NSMutableArray *tagButtons;
/** 内容 */
@property (nonatomic, weak) UIView *contentView;
/** 文本输入框*/
@property(nonatomic,weak) WXHTagTextField *textField;
/** 添加标签按钮*/
@property(nonatomic,weak) UIButton *addTagButton;
@end

@implementation WXHTagViewController
#pragma mark - lazyLoad
- (UIView *)contentView{
    if (_contentView == nil) {
        UIView *contentView = [[UIView alloc] init];
        [self.view addSubview:contentView];
        _contentView = contentView;
    }
    return _contentView;
}
- (WXHTagTextField *)textField{
    if (_textField == nil) {
        WXHTagTextField *textField = [[WXHTagTextField alloc] init];
        WXHWeakSelf;
        textField.delegateBlock = ^{
            // 有文字直接返回
            if (weakSelf.textField.hasText) return;
            // 否则调用标签按钮的点击事件
            [weakSelf tagButtonAction:[weakSelf.tagButtons lastObject]];
        };
        textField.delegate = self;
        // 监听输入框文字的改变
        [textField addTarget:self action:@selector(textDidChange) forControlEvents:UIControlEventEditingChanged];
        // 让输入框作为第一响应者,一进来就弹出键盘
        [textField becomeFirstResponder];
        [self.contentView addSubview:textField];
        _textField = textField;
    }
    return _textField;
}
- (UIButton *)addTagButton{
    if (_addTagButton == nil) {
        UIButton *addTagButton = [UIButton buttonWithType:UIButtonTypeCustom];
        addTagButton.wxh_height = 35;
        [addTagButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        addTagButton.backgroundColor = WXHTagBgColor;
        [addTagButton addTarget:self action:@selector(addTagAction) forControlEvents:UIControlEventTouchUpInside];
        addTagButton.titleLabel.font = WXHTagFont;
        addTagButton.hidden = YES;
        // 左右收进
        addTagButton.contentEdgeInsets = UIEdgeInsetsMake(0, WXHTagMargin, 0, WXHTagMargin);
        // 让按钮内部的文字跟图片都左对齐
        addTagButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [self.contentView addSubview:addTagButton];
        _addTagButton = addTagButton;
    }
    return _addTagButton;
}
- (NSMutableArray *)tagButtons{
    if (_tagButtons == nil) {
        _tagButtons = [NSMutableArray array];
    }
    return _tagButtons;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNav];
}

#pragma mark - 设置导航栏
- (void)setupNav{
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"添加标签";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(doneAction)];
}
#pragma mark - 监听完成点击事件
- (void)doneAction{
    // 将数据传给上一个控制器
    // 传递tags给block
    NSArray *tags = [self.tagButtons valueForKey:@"currentTitle"];
    !self.tagsBlock ? : self.tagsBlock(tags);
    // 跳转
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)textDidChange{
    
    // 更新文本框的frame
    [self updateTextFieldFrame];
    
    if (self.textField.hasText) { // 有文字
        // 显示添加标签的按钮
        self.addTagButton.hidden = NO;
        self.addTagButton.wxh_y = CGRectGetMaxY(self.textField.frame) + WXHTagMargin;
        [self.addTagButton setTitle:[NSString stringWithFormat:@"添加标签: %@",self.textField.text] forState:UIControlStateNormal];
        
        // 获取最后一个字符
        NSString *text = self.textField.text;
        NSUInteger length = text.length;
        NSString *lastLetter = [text substringFromIndex:length - 1];
        if ([lastLetter isEqualToString:@"，"] || [lastLetter isEqualToString:@","]) {
            // 去除逗号
            self.textField.text = [text substringToIndex:length - 1];
            [self addTagAction];
        }
    }else{ // 没有文字
        // 隐藏添加标签的按钮
        self.addTagButton.hidden = YES;
    }
}

#pragma mark - 监听点击事件
- (void)addTagAction{
    if (self.tagButtons.count == 5) {
        [SVProgressHUD showErrorWithStatus:@"最多添加5个标签"];
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
        return;
    }
    // 添加一个标签
    WXHTagButton *tagButton = [WXHTagButton buttonWithType:UIButtonTypeCustom];
    [tagButton setTitle:self.textField.text forState:UIControlStateNormal];
    [tagButton addTarget:self action:@selector(tagButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:tagButton];
    // 添加到数组中
    [self.tagButtons addObject:tagButton];
    
    // 清空textField的文字
    self.textField.text = nil;
    self.addTagButton.hidden = YES;
    
    // 更新标签按钮的frame
    [self updateTagButtonFrame];
    // 更新文本框的frame
    [self updateTextFieldFrame];
}
- (void)tagButtonAction:(WXHTagButton *)tagButton{
    [tagButton removeFromSuperview];
    [self.tagButtons removeObject:tagButton];
    // 重新更新所有标签按钮和文本输入框的frame
    [UIView animateWithDuration:0.25 animations:^{
        [self updateTagButtonFrame];
        [self updateTextFieldFrame];
    }];
}

#pragma mark - 更新文本框的frame
- (void)updateTextFieldFrame{
    // 获取最后一个标签按钮
    WXHTagButton *lastTagButton = [self.tagButtons lastObject];
    // 左边的宽度
    CGFloat leftWidth = CGRectGetMaxX(lastTagButton.frame) + WXHTagMargin;
    // 更新textField的frame
    if ((self.contentView.wxh_width - leftWidth) >= [self textWidthOfTextField]) { // 同行
        self.textField.wxh_x = leftWidth;
        self.textField.wxh_y = lastTagButton.wxh_y;
    }else{ // 下一行
        self.textField.wxh_x = 0;
        self.textField.wxh_y = CGRectGetMaxY(lastTagButton.frame) + WXHTagMargin;
    }
    // 更新添加标签按钮的frame
    self.addTagButton.wxh_y = CGRectGetMaxY(self.textField.frame) + WXHTagMargin;
}
#pragma mark - 更新标签按钮的frame
- (void)updateTagButtonFrame{
    for (int i = 0; i < self.tagButtons.count; i ++) {
        WXHTagButton *tagButton = self.tagButtons[i];
        if (i == 0) { // 最前面的标签按钮
            tagButton.wxh_x = 0;
            tagButton.wxh_y = 0;
        }else{ // 其他标签按钮
            // 上一个标签按钮
            WXHTagButton *previousTagButton = self.tagButtons[i - 1];
            // 左边的宽度
            CGFloat leftWidth= CGRectGetMaxX(previousTagButton.frame) + WXHTagMargin;
            // 右边的宽度
            CGFloat rightWidth = self.contentView.wxh_width - leftWidth;
            if (rightWidth >= tagButton.wxh_width) { // 同行
                tagButton.wxh_x = leftWidth;
                tagButton.wxh_y = previousTagButton.wxh_y;
            }else{ // 下一行
                tagButton.wxh_x = 0;
                tagButton.wxh_y = CGRectGetMaxY(previousTagButton.frame) + WXHTagMargin;
            }
        }
    }
}
#pragma mark - 布局控制器view的子控件
- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    self.contentView.wxh_x = WXHTagMargin;
    self.contentView.wxh_width = self.view.wxh_width - 2 * self.contentView.wxh_x;
    self.contentView.wxh_y = WXHNavBarMaxY + WXHTagMargin;
    self.contentView.wxh_height = kHeight - self.contentView.wxh_y;
    
    self.textField.wxh_width = self.contentView.wxh_width;
    
    self.addTagButton.wxh_width = self.contentView.wxh_width;
    
    // 设置标签
    [self setupTags];
}
#pragma mark - 设置标签
- (void)setupTags{
    if (self.tags.count) {
        for (NSString *tag in self.tags) {
            self.textField.text = tag;
            [self addTagAction];
        }
        self.tags = nil;
    }
}
#pragma mark - textField的文字宽度
- (CGFloat)textWidthOfTextField{
    CGFloat textWidth = [self.textField.text sizeWithAttributes:@{NSFontAttributeName : self.textField.font}].width;
    //    return MAX(self.textField.wxh_width, textWidth);
    return MAX(100, textWidth);
}
#pragma mark - <UITextFieldDelegate>
#pragma mark * 监听键盘最右下角按钮的点击（return key， 比如“换行”、“完成”等等）
- (BOOL)textFieldShouldReturn:(WXHTagTextField *)textField{
    if (textField.hasText) {
        [self addTagAction];
    }
    return YES;
}
@end
