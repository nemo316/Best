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
+ (NSString *)getUid:(BOOL)showLoginController{
    NSString *uid = [WXHSaveTool objectForKey:key];
    if (!uid && showLoginController) {
        // 弹出登录界面
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            WXHLogRegistViewController *loginVC= [[WXHLogRegistViewController alloc] init];
            [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:loginVC animated:YES completion:nil];
        });
        
    }
    return uid;
}
+ (NSString *)getUid{
    return [self getUid:NO];
}

+ (void)setUid:(NSString *)uid{
    [WXHSaveTool setObject:uid forKey:key];
}
@end
