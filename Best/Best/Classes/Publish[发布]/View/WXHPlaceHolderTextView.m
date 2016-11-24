//
//  WXHPlaceHolderTextView.m
//  Best
//
//  Created by 初七 on 2016/11/24.
//  Copyright © 2016年 nemo. All rights reserved.
//

#import "WXHPlaceHolderTextView.h"
@interface WXHPlaceHolderTextView()
/** 占位文字的textLabel*/
@property(nonatomic,weak) UILabel *placeholderLabel;
@end
@implementation WXHPlaceHolderTextView
- (UILabel *)placeholderLabel{
    if (_placeholderLabel == nil) {
        // 添加一个用来显示占位文字的label
        UILabel *placeholderLabel = [[UILabel alloc] init];
        placeholderLabel.numberOfLines = 0;
        placeholderLabel.wxh_x = 5;
        placeholderLabel.wxh_y = 5;
        [self addSubview:placeholderLabel];
        _placeholderLabel = placeholderLabel;
    }
    return _placeholderLabel;
}
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        // 设置垂直方向上永远有弹簧效果
        self.alwaysBounceVertical = YES;
        // 默认字体
        self.font = [UIFont systemFontOfSize:15];
        // 默认占位文字的颜色
        self.placeholderColor = [UIColor grayColor];
        // 监听文字的改变
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:nil];
    }
    return self;
}
#pragma mark - 监听文字的改变
- (void)textDidChange{
    // 只要有文字,就隐藏占位label
    self.placeholderLabel.hidden = self.hasText;
}
#pragma mark - 更新占位label的尺寸
- (void)layoutSubviews{
    [super layoutSubviews];
    self.placeholderLabel.wxh_width = self.wxh_width - 2 * self.placeholderLabel.wxh_x;
    [self.placeholderLabel sizeToFit];
}
#pragma mark - 重写属性
- (void)setPlaceholderColor:(UIColor *)placeholderColor{
    _placeholderColor = placeholderColor;
    self.placeholderLabel.textColor = placeholderColor;
}
/**
 * setNeedsDisplay方法 : 会在恰当的时刻自动调用drawRect:方法
 * setNeedsLayout方法 : 会在恰当的时刻调用layoutSubviews方法
 */
- (void)setPlaceholder:(NSString *)placeholder{
    _placeholder = [placeholder copy];
    self.placeholderLabel.text = placeholder;
    [self setNeedsLayout];
}
#pragma mark - 以防调用者用直接用系统的方法修改属性
- (void)setFont:(UIFont *)font{
    [super setFont:font];
    self.placeholderLabel.font = font;
    [self setNeedsLayout];
}
- (void)setText:(NSString *)text{
    [super setText:text];
    [self textDidChange];
}
- (void)setAttributedText:(NSAttributedString *)attributedText{
    [super setAttributedText:attributedText];
    [self textDidChange];
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
