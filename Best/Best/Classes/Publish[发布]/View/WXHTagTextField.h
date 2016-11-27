//
//  WXHTagTextField.h
//  Best
//
//  Created by 初七 on 2016/11/27.
//  Copyright © 2016年 nemo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WXHTagTextField : UITextField
/** 按了删除键后的回调*/
@property(nonatomic,copy) void(^delegateBlock)();
@end
