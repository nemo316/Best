//
//  WXHTopicCell.m
//  Best1.0
//
//  Created by 初七 on 2016/11/11.
//  Copyright © 2016年 nemo. All rights reserved.
//

#import "WXHTopicCell.h"
#import "WXHTopic.h"
#import "UIImageView+load.h"
#import "WXHTopicVideoView.h"
#import "WXHTopicVoiceView.h"
#import "WXHTopicPictureView.h"
#import "WXHComment.h"
#import "WXHUser.h"
#import "WXHLoginTool.h"
@interface WXHTopicCell()<UIActionSheetDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *passtimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *text_label;
@property (weak, nonatomic) IBOutlet UIButton *dingButton;
@property (weak, nonatomic) IBOutlet UIButton *caiButton;
@property (weak, nonatomic) IBOutlet UIButton *repostButton;
@property (weak, nonatomic) IBOutlet UIButton *commentButton;
@property (weak, nonatomic) IBOutlet UIView *hotCommandView;
@property (weak, nonatomic) IBOutlet UILabel *hotCommandComent;
/** 新浪加V */
@property (weak, nonatomic) IBOutlet UIImageView *sinaVView;

//*********************中间三种不同视图***********************
/** 视频*/
@property(nonatomic,weak) WXHTopicVideoView *middleVideo;
/** 音频*/
@property(nonatomic,weak) WXHTopicVoiceView *middleVoice;
/** 图片*/
@property(nonatomic,weak) WXHTopicPictureView *middlePicture;

@end
@implementation WXHTopicCell

-(WXHTopicVideoView *)middleVideo{

    if (_middleVideo == nil) {
        WXHTopicVideoView *videoView = [WXHTopicVideoView viewFromXib];
        [self.contentView addSubview:videoView];
        _middleVideo = videoView;
    }
    return _middleVideo;
}
-(WXHTopicPictureView *)middlePicture{
    
    if (_middlePicture == nil) {
        WXHTopicPictureView *pictureView = [WXHTopicPictureView viewFromXib];
        [self.contentView addSubview:pictureView];
        _middlePicture = pictureView;
    }
    return _middlePicture;
}
-(WXHTopicVoiceView *)middleVoice{
    
    if (_middleVoice == nil) {
        WXHTopicVoiceView *voiceView = [WXHTopicVoiceView viewFromXib];
        [self.contentView addSubview:voiceView];
        _middleVoice = voiceView;
    }
    return _middleVoice;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // 设置cell背景图
    self.backgroundView = [[UIImageView alloc] initWithImage:[UIImage wxh_imageWithStretch:@"mainCellBackground"]];
}

- (void)setTopic:(WXHTopic *)topic
{
    _topic = topic;
    
    // 顶部控件的数据
//    UIImage *placeholder = [UIImage xmg_circleImageNamed:@"defaultUserIcon"];
    [self.profileImageView wxh_setHeader:topic.profile_image];
    self.nameLabel.text = topic.name;
    self.passtimeLabel.text = topic.passtime;
    self.text_label.text = topic.text;
    // 新浪加V
    self.sinaVView.hidden = !topic.isSina_v;
    // 中间视图
    if (topic.type == WXHTopicTypeVideo) { // 视频
        // 防止复用bug
        self.middleVideo.hidden = NO;
        self.middleVideo.topic = topic;
        self.middleVoice.hidden = YES;
        self.middlePicture.hidden = YES;
    }else if(topic.type == WXHTopicTypeVoice){ // 音频
        self.middleVideo.hidden = YES;
        self.middleVoice.hidden = NO;
        self.middleVoice.topic = topic;
        self.middlePicture.hidden = YES;
    }else if(topic.type == WXHTopicTypePicture){ // 图片
        self.middleVideo.hidden = YES;
        self.middleVoice.hidden = YES;
        self.middlePicture.hidden = NO;
        self.middlePicture.topic = topic;
    }else{ // 段子
        self.middleVideo.hidden = YES;
        self.middleVoice.hidden = YES;
        self.middlePicture.hidden = YES;
    }
    
    // 最热评论
    if (topic.top_cmt) {
        self.hotCommandView.hidden = NO;
        NSString *name = topic.top_cmt.user.username;
        NSString *comment = topic.top_cmt.content;
        if (comment.length == 0) { // 语音评论
            comment = @"语音评论";
        }
        NSString *hotStr = [NSString stringWithFormat:@"%@ : %@",name,comment];
        self.hotCommandComent.text = hotStr;
    }else{
        self.hotCommandView.hidden = YES;
    }
    // 底部按钮的文字
    [self setupButtonTitle:self.dingButton number:topic.ding placeholder:@"顶"];
    [self setupButtonTitle:self.caiButton number:topic.cai placeholder:@"踩"];
    [self setupButtonTitle:self.repostButton number:topic.repost placeholder:@"分享"];
    [self setupButtonTitle:self.commentButton number:topic.comment placeholder:@"评论"];
}

/**
 *  设置按钮文字
 *  @param number      按钮的数字
 *  @param placeholder 数字为0时显示的文字
 */
- (void)setupButtonTitle:(UIButton *)button number:(NSInteger)number placeholder:(NSString *)placeholder
{
    if (number >= 10000) {
        NSString *str = [NSString stringWithFormat:@"%.1f万", number / 10000.0];
        str = [str stringByReplacingOccurrencesOfString:@".0" withString:@""];
        [button setTitle:str forState:UIControlStateNormal];
    } else if (number > 0) {
        NSString *str = [NSString stringWithFormat:@"%ld", number];
        [button setTitle:str forState:UIControlStateNormal];
    } else {
        [button setTitle:placeholder forState:UIControlStateNormal];
    }
}

- (void)setFrame:(CGRect)frame
{
    frame.origin.x = WXHCommonMargin;
    frame.size.width -= 2 * WXHCommonMargin;
    frame.size.height = self.topic.cellHeight - WXHCommonMargin;
    frame.origin.y += WXHCommonMargin;
    [super setFrame:frame];
}

-(void)layoutSubviews{

    [super layoutSubviews];
    if (self.topic.type == WXHTopicTypeVideo) { // 视频
        self.middleVideo.frame = self.topic.frame;
    }else if(self.topic.type == WXHTopicTypeVoice){ // 音频
        self.middleVoice.frame = self.topic.frame;
    }else if(self.topic.type == WXHTopicTypePicture){ // 图片
        self.middlePicture.frame = self.topic.frame;
    }
}
- (IBAction)clickAction:(UIButton *)sender {
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"举报",@"收藏", nil];
    sheet.delegate = self;
    [sheet showInView:self.window];
}
#pragma mark - <UIActionSheetDelegate>
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
 
    
}
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    // 点击取消直接返回,否则需要登录
    if (buttonIndex == 2) return;
    if (![WXHLoginTool getUid:YES]) return;
    // 已经登录,执行相应操作
}
@end
