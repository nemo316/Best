//
//  WXHPostSessionViewController.m
//  Best
//
//  Created by 初七 on 2016/11/24.
//  Copyright © 2016年 nemo. All rights reserved.
//

#import "WXHPostSessionViewController.h"
#import "WXHPlaceHolderTextView.h"
#import "WXHTagToolBar.h"
@interface WXHPostSessionViewController ()<UITextViewDelegate>
/** 自定义文本控件*/
@property(nonatomic,weak) WXHPlaceHolderTextView *placeholderTextView;
/** 工具条 */
@property (nonatomic, weak) WXHTagToolBar *toolbar;
@end

@implementation WXHPostSessionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 设置导航栏
    [self setupNav];
    // 设置占位文本框
    [self setupTextField];
    // 设置工具条
    [self setupToolBar];
}
#pragma mark - 设置导航栏
-(void)setupNav{

    self.title = @"发表文字";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(cancelAction)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发表" style:UIBarButtonItemStyleDone target:self action:@selector(postAction)];
    // 默认发表不能点击
    self.navigationItem.rightBarButtonItem.enabled = NO;
    // 强制刷新
    [self.navigationController.navigationBar layoutIfNeeded];
}
#pragma mark - 监听NavItem点击
- (void)cancelAction{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)postAction{
    WXHLOG(@"%s",__func__);
}
#pragma mark - 设置自定义文本框
- (void)setupTextField{
    WXHPlaceHolderTextView *placeholderTextView = [[WXHPlaceHolderTextView alloc] init];
    placeholderTextView.placeholder = @"把好玩的图片，好笑的段子或糗事发到这里，接受千万网友膜拜吧！发布违反国家法律内容的，我们将依法提交给有关部门处理。";
    placeholderTextView.frame = self.view.bounds;
    placeholderTextView.delegate = self;
    [self.view addSubview:placeholderTextView];
    self.placeholderTextView = placeholderTextView;
}
#pragma mark - 设置工具条
- (void)setupToolBar{
    WXHTagToolBar *toolBar = [WXHTagToolBar viewFromXib];
    toolBar.wxh_width = self.view.wxh_width;
    toolBar.wxh_y = self.view.wxh_height - toolBar.wxh_height;
    [self.view addSubview:toolBar];
    self.toolbar = toolBar;
    // 键盘改变frame的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
}
#pragma mark - 监听键盘改变frame
- (void)keyboardWillChangeFrame:(NSNotification *)note{
    // 键盘最终的frame
    CGRect keyBoardEndFrame = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    // 动画时间
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    [UIView animateWithDuration:duration animations:^{
        self.toolbar.transform = CGAffineTransformMakeTranslation(0, keyBoardEndFrame.origin.y - kHeight);
    }];
}
#pragma mark - <UITextViewDelegate>
- (void)textViewDidChange:(UITextView *)textView{
    self.navigationItem.rightBarButtonItem.enabled = textView.hasText;
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
    
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    // 呼出键盘
    [self.placeholderTextView becomeFirstResponder];
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
