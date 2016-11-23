//
//  XMGTopic.h
//  BuDeJie
//
//  Created by nemo on 16/3/22.
//  Copyright © 2016年 初七. All rights reserved.
//

#import <Foundation/Foundation.h>
@class WXHComment;
//typedef enum {
//    /** 全部 */
//    XMGTopicTypeAll = 1,
//    /** 图片 */
//    XMGTopicTypePicture = 10,
//    /** 段子 */
//    XMGTopicTypeWord = 29,
//    /** 声音 */
//    XMGTopicTypeVoice = 31,
//    /** 视频 */
//    XMGTopicTypeVideo = 41
//} XMGTopicType;

typedef NS_ENUM(NSUInteger, WXHTopicType){
    /** 全部 */
    WXHTopicTypeAll = 1,
    /** 图片 */
    WXHTopicTypePicture = 10,
    /** 段子 */
    WXHTopicTypeWord = 29,
    /** 声音 */
    WXHTopicTypeVoice = 31,
    /** 视频 */
    WXHTopicTypeVideo = 41
};
@interface WXHTopic : NSObject
/** 用户的名字 */
@property (nonatomic, copy) NSString *name;
/** 用户的头像 */
@property (nonatomic, copy) NSString *profile_image;
/** 帖子的文字内容 */
@property (nonatomic, copy) NSString *text;
/** 帖子审核通过的时间 */
@property (nonatomic, copy) NSString *passtime;

/** 顶数量 */
@property (nonatomic, assign) NSInteger ding;
/** 踩数量 */
@property (nonatomic, assign) NSInteger cai;
/** 转发\分享数量 */
@property (nonatomic, assign) NSInteger repost;
/** 评论数量 */
@property (nonatomic, assign) NSInteger comment;
/** id */
@property (nonatomic, copy) NSString *ID;

/** 帖子的类型 10为图片 29为段子 31为音频 41为视频 */
@property (nonatomic, assign) NSInteger type;
/** 最热评论*/
@property(nonatomic, strong) WXHComment *top_cmt;
/** 宽度(像素) */
@property (nonatomic, assign) NSInteger width;
/** 高度(像素) */
@property (nonatomic, assign) NSInteger height;
/** 是否为动图 */
@property (nonatomic, assign) BOOL is_gif;
//**********************音频 视频属性*********************
/** 音频时长 */
@property (nonatomic, assign) NSInteger voicetime;
/** 视频时长 */
@property (nonatomic, assign) NSInteger videotime;
/** 音频\视频的播放次数 */
@property (nonatomic, assign) NSInteger playcount;
/** 小图 */
@property (nonatomic, copy) NSString *small_image;
/** 中图 */
@property (nonatomic, copy) NSString *middle_image;
/** 大图 */
@property (nonatomic, copy) NSString *large_image;
/** 是否为新浪加V用户 */
@property (nonatomic, assign, getter=isSina_v) BOOL sina_v;

//**********************非服务器返回的其他属性*********************
/** cell的高度*/
@property(nonatomic, assign) CGFloat cellHeight;
/** 中间视图的frame*/
@property(nonatomic, assign) CGRect frame;
/** 是否为超长图片 */
@property (nonatomic, assign, getter=isBigPicture) BOOL bigPicture;
/** 图片的下载进度 */
@property (nonatomic, assign) CGFloat pictureProgress;
@end
