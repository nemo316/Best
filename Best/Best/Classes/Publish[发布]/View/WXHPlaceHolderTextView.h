//
//  WXHPlaceHolderTextView.h
//  Best
//
//  Created by 初七 on 2016/11/24.
//  Copyright © 2016年 nemo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WXHPlaceHolderTextView : UITextView
/** 占位文字 */
@property (nonatomic, copy) NSString *placeholder;
/** 占位文字的颜色 */
@property (nonatomic, strong) UIColor *placeholderColor;
@end
