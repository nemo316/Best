//
//  WXHLoginTool.m
//  Best
//
//  Created by 初七 on 2016/11/28.
//  Copyright © 2016年 nemo. All rights reserved.
//

#import "WXHLoginTool.h"
#import "WXHSaveTool.h"
#import "WXHLogRegistViewController.h"
static NSString *const key = @"uid";
@implementation WXHLoginTool
+ (NSString *)getUid{
    NSString *uid = [WXHSaveTool objectForKey:key];
    if (!uid) {
        // 弹出登录界面
        WXHLogRegistViewController *loginVC= [[WXHLogRegistViewController alloc] init];
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:loginVC animated:YES completion:nil];
    }
    return uid;
}

+ (void)setUid:(NSString *)uid{
    [WXHSaveTool setObject:uid forKey:key];
}
@end
