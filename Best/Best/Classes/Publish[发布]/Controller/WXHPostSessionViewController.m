//
//  WXHPostSessionViewController.m
//  Best
//
//  Created by 初七 on 2016/11/24.
//  Copyright © 2016年 nemo. All rights reserved.
//

#import "WXHPostSessionViewController.h"
#import "WXHPlaceHolderTextView.h"
@interface WXHPostSessionViewController ()<UITextViewDelegate>

@end

@implementation WXHPostSessionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNav];
    [self setupTextField];
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
@end
