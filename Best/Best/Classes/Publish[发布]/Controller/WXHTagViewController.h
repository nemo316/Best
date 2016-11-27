//
//  WXHTagViewController.h
//  Best
//
//  Created by 初七 on 2016/11/25.
//  Copyright © 2016年 nemo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WXHTagViewController : UIViewController
/** 获取tags的block*/
@property(nonatomic,copy) void(^tagsBlock)(NSArray *tags);
/** 存放标签数组*/
@property(nonatomic,strong) NSArray *tags;
@end
