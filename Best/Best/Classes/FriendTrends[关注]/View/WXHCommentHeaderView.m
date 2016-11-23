//
//  WXHCommentHeaderView.m
//  Best1.0
//
//  Created by 初七 on 2016/11/22.
//  Copyright © 2016年 nemo. All rights reserved.
//

#import "WXHCommentHeaderView.h"
@interface WXHCommentHeaderView()
/** 文本标签*/
@property(nonatomic,weak) UILabel *label;
@end
static NSString *const ID = @"header";
@implementation WXHCommentHeaderView

-(instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = WXHGrayColor(244);
      // 创建label
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont systemFontOfSize:14];
        label.textColor = WXHGrayColor(67);
        label.wxh_width = 200;
        label.wxh_x = WXHCommonMargin;
        label.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        [self.contentView addSubview:label];
        self.label = label;
       
    }
    return self;
}

+(instancetype)headerViewWithTableView:(UITableView *)tableView{

    WXHCommentHeaderView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:ID];
    if (view == nil) {
        view = [[WXHCommentHeaderView alloc] initWithReuseIdentifier:ID];
    }
    return view;
}
-(void)setHeaderTitle:(NSString *)headerTitle{
    _headerTitle = [headerTitle copy];
    self.label.text = headerTitle;
    WXHLOG(@"%@  %@",self.label.text,self.label.text);
}
@end
