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
 *  获得当前登录用于的uid
 *
 *  @return 返回NSString 已经登录  返回nil 没有登录
 */
+ (NSString *)getUid;
/**
 *  存储当前用户的uid
 *
 *  @param uid uid
 */
+ (void)setUid:(NSString *)uid;
@end
