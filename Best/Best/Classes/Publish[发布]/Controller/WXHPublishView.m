//

//  Best1.0
//
//  Created by 初七 on 2016/11/7.
//  Copyright © 2016年 nemo. All rights reserved.
//


#import "WXHPublishView.h"
#import "WXHFastLogButton.h"
#import <POP.h>
#import "WXHPostSessionViewController.h"
#import "WXHMainNavigationController.h"
#import "WXHLoginTool.h"
#define WXHRootView [UIApplication sharedApplication].keyWindow.rootViewController.view

@interface WXHPublishView ()
/** 存放按钮跟标语的数组*/
@property(nonatomic,strong) NSMutableArray *factors;

@end
static CGFloat const WXHAnimationDelay = 0.05;
static CGFloat const WXHSpringFactor = 10;
@implementation WXHPublishView

-(NSMutableArray *)factors{
    if (_factors == nil) {
        _factors = [NSMutableArray array];
    }
    return _factors;
}
+(instancetype)publish{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] firstObject];
}
#pragma mark - 显示自定义窗口
static UIWindow *window_;
+(void)show{
    // 自定义一个窗口
    window_ = [[UIWindow alloc] init];
    window_.frame = [UIScreen mainScreen].bounds;
    window_.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8];
    window_.hidden = NO;
    
    WXHPublishView *publishView = [WXHPublishView publish];
    publishView.frame = window_.bounds;
    [window_ addSubview:publishView];
}
- (void)awakeFromNib{
    [super awakeFromNib];
    // 动画过程中,页面不能被点击
    self.userInteractionEnabled = NO;
    // 数据
    NSArray *images = @[@"publish-video", @"publish-picture", @"publish-text", @"publish-audio", @"publish-review", @"publish-offline"];
    NSArray *titles = @[@"发视频", @"发图片", @"发段子", @"发声音", @"审帖", @"离线下载"];
    
    // 中间的6个按钮
    int maxCols = 3;
    CGFloat buttonW = 72;
    CGFloat buttonH = buttonW + 30;
    CGFloat buttonStartY = (kHeight - 2 * buttonH) * 0.5;
    CGFloat buttonStartX = 20;
    CGFloat xMargin = (kWidth - 2 * buttonStartX - maxCols * buttonW) / (maxCols - 1);
    for (int i = 0; i<images.count; i++) {
        WXHFastLogButton *button = [[WXHFastLogButton alloc] init];
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        // 添加到数组中
        [self.factors addObject:button];
        button.tag = i;
        // 设置内容
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        [button setTitle:titles[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:images[i]] forState:UIControlStateNormal];
        
        // 计算X\Y
        int row = i / maxCols;
        int col = i % maxCols;
        CGFloat buttonX = buttonStartX + col * (xMargin + buttonW);
        CGFloat buttonEndY = buttonStartY + row * buttonH;
        CGFloat buttonBeginY = buttonEndY - kHeight;
        // 修复起始时按钮显示在左上角
        button.wxh_y = buttonBeginY;
        button.wxh_x = buttonX;
        //
        // 按钮动画
        POPSpringAnimation *anim = [POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
        anim.fromValue = [NSValue valueWithCGRect:CGRectMake(buttonX, buttonBeginY, buttonW, buttonH)];
        anim.toValue = [NSValue valueWithCGRect:CGRectMake(buttonX, buttonEndY, buttonW, buttonH)];
        anim.springBounciness = WXHSpringFactor;
        anim.springSpeed = WXHSpringFactor;
        anim.beginTime = CACurrentMediaTime() + WXHAnimationDelay * i;
        [button pop_addAnimation:anim forKey:nil];
    }
    // 添加标语
    UIImageView *sloganView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"app_slogan"]];
    [self addSubview:sloganView];
    // 添加到数组中
    [self.factors addObject:sloganView];
    // 标语动画
    POPSpringAnimation *anim = [POPSpringAnimation animationWithPropertyNamed:kPOPViewCenter];
    CGFloat centerX = kWidth * 0.5;
    CGFloat centerEndY = kHeight * 0.2;
    CGFloat centerBeginY = centerEndY - kHeight;
    // 修复起始时标语显示在左上角
    sloganView.wxh_centerY = centerBeginY;
    sloganView.wxh_centerX = centerX;
    anim.fromValue = [NSValue valueWithCGPoint:CGPointMake(centerX, centerBeginY)];
    anim.toValue = [NSValue valueWithCGPoint:CGPointMake(centerX, centerEndY)];
    anim.springBounciness = WXHSpringFactor;
    anim.springSpeed = WXHSpringFactor;
    anim.beginTime = CACurrentMediaTime() + images.count * WXHAnimationDelay;
    // 标语动画结束之后
    [anim setCompletionBlock:^(POPAnimation *anim, BOOL finished) {
        // 标语动画执行完毕, 恢复点击事件
        self.userInteractionEnabled = YES;
    }];
    [sloganView pop_addAnimation:anim forKey:nil];
}

- (void)buttonClick:(UIButton *)button
{
   [self cancleWithCompletionBlock:^{
       if (button.tag == 2) { // 发段子
           // 判断是否登录
           if (![WXHLoginTool getUid:YES]) return;
           WXHPostSessionViewController *postSessionVC = [[WXHPostSessionViewController alloc] init];
           WXHMainNavigationController *nav = [[WXHMainNavigationController alloc] initWithRootViewController:postSessionVC];
           UIViewController *rootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
           [rootVC presentViewController:nav animated:YES completion:nil];
       }
   }];
}
#pragma mark - 监听取消按钮的点击
- (IBAction)cancleAction:(UIButton *)sender {
    [self cancleWithCompletionBlock:nil];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self cancleWithCompletionBlock:nil];
}
#pragma mark - 先执行退出动画, 动画完毕后执行completionBlock
-(void)cancleWithCompletionBlock:(void(^)())completionBlock{
    // 不能被点击
    self.userInteractionEnabled = NO;
    NSInteger count = self.factors.count;
    for (NSInteger i = count; i > 0; i --) {
        WXHLOG(@"====%ld",i);
        UIView *view = self.factors[i - 1];
        // 基本动画
        POPBasicAnimation *anim = [POPBasicAnimation animationWithPropertyNamed:kPOPViewCenter];
        CGFloat centerEndY = view.wxh_centerY + kHeight;
        anim.toValue = [NSValue valueWithCGPoint:CGPointMake(view.wxh_centerX, centerEndY)];
        anim.beginTime = CACurrentMediaTime() + WXHAnimationDelay * (count - i);
        anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
        [view pop_addAnimation:anim forKey:nil];
        // 监听最后一个动画
        if (i == 1) {
            [anim setCompletionBlock:^(POPAnimation *anim, BOOL finished) {
                // 销毁自定义的窗口
                window_ = nil;
                // 执行传进来的代码块
                if (completionBlock) completionBlock();
            }];
        }
    }


}


@end
