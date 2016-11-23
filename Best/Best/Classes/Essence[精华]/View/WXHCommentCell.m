//
//  WXHCommentCell.m
//  Best1.0
//
//  Created by 初七 on 2016/11/22.
//  Copyright © 2016年 nemo. All rights reserved.
//

#import "WXHCommentCell.h"
#import "UIImageView+load.h"
#import "WXHComment.h"
#import "WXHUser.h"
@interface WXHCommentCell()
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UIImageView *sexView;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *likeCountLabel;
@property (weak, nonatomic) IBOutlet UIButton *voiceButton;
@end

@implementation WXHCommentCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    UIImageView *bgView = [[UIImageView alloc] init];
    bgView.image = [UIImage wxh_imageWithStretch:@"mainCellBackground"];
    self.backgroundView = bgView;
}

-(void)setComment:(WXHComment *)comment{

    _comment = comment;
    
    [self.profileImageView wxh_loadImageWithURL:comment.user.profile_image placeholderImage:[UIImage imageNamed:@"defaultUserIcon"]];
    self.sexView.image = [comment.user.sex isEqualToString:WXHUserSexMale] ? [UIImage imageNamed:@"Profile_manIcon"] : [UIImage imageNamed:@"Profile_womanIcon"];
    self.contentLabel.text = comment.content;
    self.usernameLabel.text = comment.user.username;
    self.likeCountLabel.text = [NSString stringWithFormat:@"%zd", comment.like_count];
    
    if (comment.voiceuri.length) {
        self.voiceButton.hidden = NO;
        [self.voiceButton setTitle:[NSString stringWithFormat:@"%zd''", comment.voicetime] forState:UIControlStateNormal];
    } else {
        self.voiceButton.hidden = YES;
    }
}

- (void)setFrame:(CGRect)frame
{
    frame.origin.x = WXHCommonMargin;
    frame.size.width -= 2 * WXHCommonMargin;
    
    [super setFrame:frame];
}
#pragma mark - MenuController
-(BOOL)canBecomeFirstResponder{
    return YES;
}
-(BOOL)canPerformAction:(SEL)action withSender:(id)sender{
    return NO;
}
@end
