//
//  WXHUser.h
//  Best1.0
//
//  Created by 初七 on 2016/11/22.
//  Copyright © 2016年 nemo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WXHUser : NSObject
/** 用户名 */
@property (nonatomic, copy) NSString *username;
/** 性别 */
@property (nonatomic, copy) NSString *sex;
/** 头像 */
@property (nonatomic, copy) NSString *profile_image;
@end
