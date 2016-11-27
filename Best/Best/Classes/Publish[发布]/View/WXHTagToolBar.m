//
//  WXHTagToolBar.m
//  Best
//
//  Created by 初七 on 2016/11/25.
//  Copyright © 2016年 nemo. All rights reserved.
//

#import "WXHTagToolBar.h"
#import "WXHTagViewController.h"
@interface WXHTagToolBar()
/** 顶部控件 */
@property (weak, nonatomic) IBOutlet UIView *topView;
/** 添加按钮 */
@property (weak, nonatomic) UIButton *addButton;
/** 存放所有的标签label */
@property (nonatomic, strong) NSMutableArray *tagLabels;
@end

@implementation WXHTagToolBar
- (NSMutableArray *)tagLabels{
    if (_tagLabels == nil) {
        _tagLabels = [NSMutableArray array];
    }
    return _tagLabels;
}
- (void)awakeFromNib{
    [super awakeFromNib];
    // 添加加号按钮
    UIButton *addButton = [[UIButton alloc] init];
    [addButton addTarget:self action:@selector(addButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [addButton setImage:[UIImage imageNamed:@"tag_add_icon"] forState:UIControlStateNormal];
    addButton.wxh_size = addButton.currentImage.size;
    addButton.wxh_x = WXHTagMargin;
    addButton.wxh_y = WXHTagMargin;
    [self.topView addSubview:addButton];
    self.addButton = addButton;
    // 默认拥有两个标签
    [self createTagLabels:@[@"吐槽", @"糗事"]];
}
#pragma mark - 监听按钮的点击事件
- (void)addButtonClick{
    WXHTagViewController *tagVC = [[WXHTagViewController alloc] init];
    WXHWeakSelf
    [tagVC setTagsBlock:^(NSArray *tags) {
        [weakSelf createTagLabels:tags];
    }];
    tagVC.tags = [self.tagLabels valueForKey:@"text"];
    // 导航push
    UIViewController *root = [UIApplication sharedApplication].keyWindow.rootViewController;
    UINavigationController *nav = (UINavigationController *)root.presentedViewController;
    [nav pushViewController:tagVC animated:YES];
}
#pragma mark - 创建标签
- (void)createTagLabels:(NSArray *)tags{
    [self.tagLabels makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.tagLabels removeAllObjects];
    for (int i = 0; i < tags.count; i ++) {
        UILabel *tagLabel = [[UILabel alloc] init];
        // 为layoutSubViews作准备
        [self.tagLabels addObject:tagLabel];
        tagLabel.backgroundColor = WXHTagBgColor;
        tagLabel.textAlignment = NSTextAlignmentCenter;
        tagLabel.textColor = [UIColor whiteColor];
        tagLabel.text = tags[i];
        tagLabel.font = WXHTagFont;
        // 先设置完文字和字体后再进行计算
        [tagLabel sizeToFit];
        tagLabel.wxh_width += 2 * WXHTagMargin;
        tagLabel.wxh_height = WXHTagH;
        [self.topView addSubview:tagLabel];
    }
    // 重新布局子控件
    [self setNeedsLayout];
}
#pragma mark - 重新布局子控件
- (void)layoutSubviews{
    [super layoutSubviews];
    
    // 更新标签的位置
    for (int i = 0; i < self.tagLabels.count; i ++) {
        UILabel *tagLabel = self.tagLabels[i];
        // 设置tag位置
        if (i == 0) {
            tagLabel.wxh_x = 0;
            tagLabel.wxh_y = 0;
        }else{ // 其他标签
            // 上一个标签
            UILabel *previousLabel = self.tagLabels[i -1];
            // 当前左边的宽度
            CGFloat leftWidth = CGRectGetMaxX(previousLabel.frame) + WXHTagMargin;
            // 右边剩下的宽度
            CGFloat rightWidth = self.topView.wxh_width - leftWidth;
            if (rightWidth >= tagLabel.wxh_width) { // 标签显示在当前行
                tagLabel.wxh_x = leftWidth;
                tagLabel.wxh_y = previousLabel.wxh_y;
            }else{ // 标签显示在下一行
                tagLabel.wxh_x = 0;
                tagLabel.wxh_y = CGRectGetMaxY(previousLabel.frame) + WXHTagMargin;
            }
        }
    }
    // 更新添加按钮
        // 获取最后一个标签
    UILabel *lastTagLabel = [self.tagLabels lastObject];
    CGFloat leftWidth = CGRectGetMaxX(lastTagLabel.frame) + WXHTagMargin;
    if ((self.topView.wxh_width - leftWidth) >= self.addButton.wxh_width) { // 显示在当前行
        self.addButton.wxh_x = leftWidth;
        self.addButton.wxh_y = lastTagLabel.wxh_y;
    }else{ // 显示在下一行
        self.addButton.wxh_x = 0;
        self.addButton.wxh_y = CGRectGetMaxY(lastTagLabel.frame) + WXHTagMargin;
    }
    // 整体的高度
    CGFloat originalH = self.wxh_height;
    self.wxh_height = CGRectGetMaxY(self.addButton.frame) + 45;
    self.wxh_y -= self.wxh_height - originalH;
}
@end
