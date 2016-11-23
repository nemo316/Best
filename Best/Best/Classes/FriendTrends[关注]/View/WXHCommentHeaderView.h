//
//  WXHCommentHeaderView.h
//  Best1.0
//
//  Created by 初七 on 2016/11/22.
//  Copyright © 2016年 nemo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WXHCommentHeaderView : UITableViewHeaderFooterView
+(instancetype)headerViewWithTableView:(UITableView *)tableView;
/** 标题*/
@property(nonatomic,copy) NSString *headerTitle;
@end
