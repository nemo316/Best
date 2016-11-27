//
//  WXHTagButton.m
//  Best
//
//  Created by 初七 on 2016/11/27.
//  Copyright © 2016年 nemo. All rights reserved.
//

#import "WXHTagButton.h"

@implementation WXHTagButton
#pragma mark - 初始化属性设置
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setImage:[UIImage imageNamed:@"chose_tag_close_icon"] forState:UIControlStateNormal];
        self.backgroundColor = WXHTagBgColor;
        self.titleLabel.font = WXHTagFont;
    }
    return self;
}
#pragma mark - 改变titleLabel跟imageView的frame
- (void)layoutSubviews{
    [super layoutSubviews];
    self.titleLabel.wxh_x = WXHTagMargin;
    self.imageView.wxh_x = CGRectGetMaxX(self.titleLabel.frame) + WXHTagMargin;
}
#pragma mark - 重写setTitle方法
- (void)setTitle:(NSString *)title forState:(UIControlState)state{
    [super setTitle:title forState:state];
    // 文字自适应
    [self sizeToFit];
    // 设置按钮的size
    self.wxh_width += 3 *WXHTagMargin;
    self.wxh_height = WXHTagH;
}
@end
