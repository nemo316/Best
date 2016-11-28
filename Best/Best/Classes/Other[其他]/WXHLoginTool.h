//
//  WXHLoginTool.h
//  Best
//
//  Created by 初七 on 2016/11/28.
//  Copyright © 2016年 nemo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WXHLoginTool : NSObject
/**
 *  获得当前登录用户的uid
 *
 *  @return 返回NSString 已经登录  返回nil 没有登录
 */
+ (NSString *)getUid;
/**
 *  获得当前登录用户的uid,是否需要弹出登录模块
 *
 *  @param showLoginController 登录模块
 *
 *  @return 返回
 */
+ (NSString *)getUid:(BOOL)showLoginController;
/**
 *  存储当前用户的uid
 *
 *  @param uid uid
 */
+ (void)setUid:(NSString *)uid;
@end
