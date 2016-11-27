//
//  WXHProgressView.m
//  Best1.0
//
//  Created by 初七 on 2016/11/20.
//  Copyright © 2016年 nemo. All rights reserved.
//

#import "WXHProgressView.h"

@implementation WXHProgressView
//-(void)awakeFromNib{
//    [super awakeFromNib];
//    self.backgroundRingWidth = 0;
//    self.progressRingWidth = 10;
//    self.showPercentage = YES;
//    self.primaryColor = [UIColor whiteColor];
//}
- (void)awakeFromNib
{
    [super awakeFromNib];
    self.roundedCorners = 2;
    self.progressLabel.textColor = [UIColor whiteColor];
}

- (void)setProgress:(CGFloat)progress animated:(BOOL)animated
{
    [super setProgress:progress animated:animated];
    
    NSString *text = [NSString stringWithFormat:@"%.0f%%", progress * 100];
    self.progressLabel.text = [text stringByReplacingOccurrencesOfString:@"-" withString:@""];
}
@end
