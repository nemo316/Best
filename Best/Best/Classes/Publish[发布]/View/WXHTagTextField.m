//
//  WXHTagTextField.m
//  Best
//
//  Created by 初七 on 2016/11/27.
//  Copyright © 2016年 nemo. All rights reserved.
//

#import "WXHTagTextField.h"

@implementation WXHTagTextField

#pragma mark - 设置初始化属性
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.placeholder = @"多个标签用逗号或者换行隔开";
        // 设置了占位文字内容后,才能设置占位文字的颜色
        [self setValue:[UIColor grayColor] forKeyPath:@"_placeholderLabel.textColor"];
        self.wxh_width = [self.text sizeWithAttributes:@{NSFontAttributeName : self.font}].width;
        self.font = WXHTagFont;
        self.wxh_height = WXHTagH;
    }
    return self;
}
#pragma mark - 删除事件
- (void)deleteBackward{
    !self.delegateBlock ? : self.delegateBlock();
    // 回调完block再继承父类,否则会造成删除最后一个文字的时候.标签按钮一并删除
    [super deleteBackward];
}
@end
