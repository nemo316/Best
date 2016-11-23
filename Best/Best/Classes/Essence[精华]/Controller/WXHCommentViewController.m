//
//  WXHCommentViewController.m
//  Best1.0
//
//  Created by 初七 on 2016/11/22.
//  Copyright © 2016年 nemo. All rights reserved.
//

#import "WXHCommentViewController.h"
#import "WXHComment.h"
#import "WXHTopicCell.h"
#import "WXHTopic.h"
#import "WXHRefreshHeader.h"
#import "WXHRefreshFooter.h"
#import "WXHHttpTool.h"
#import <MJExtension.h>
#import "WXHCommentHeaderView.h"
#import "WXHCommentCell.h"
@interface WXHCommentViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/** 保存热门评论*/
@property(nonatomic,strong) WXHComment *saved_top_cmt;
/** 最热评论 */
@property (nonatomic, strong) NSMutableArray *hotComments;
/** 最新评论 */
@property (nonatomic, strong) NSMutableArray *latestComments;
/** 保存当前的页码 */
@property (nonatomic, assign) NSInteger currentPage;

/** 管理者 */
@property (nonatomic, strong) AFHTTPSessionManager *manager;
@end

static NSString *const ID = @"commentCell";
@implementation WXHCommentViewController
-(NSMutableArray *)hotComments{
    if (_hotComments == nil) {
        _hotComments = [NSMutableArray array];
    }
    return _hotComments;
}
-(NSMutableArray *)latestComments{
    if (_latestComments == nil) {
        _latestComments = [NSMutableArray array];
    }
    return _latestComments;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupBasic];
    [self setupHeader];
    [self setupRefresh];
}
#pragma mark - basic
-(void)setupBasic{

    self.title = @"评论";
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithimage:[UIImage imageNamed:@"comment_nav_item_share_icon"] highImage:[UIImage imageNamed:@"comment_nav_item_share_icon_click"] target:nil action:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];

    // cell的高度设置
    self.tableView.estimatedRowHeight = 44;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    // 背景色
    self.tableView.backgroundColor = WXHGrayColor(244);
    
    // 注册
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([WXHCommentCell class]) bundle:nil] forCellReuseIdentifier:ID];
    
    // 去掉分割线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // 内边距
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, WXHCommonMargin, 0);
}
#pragma mark - header
-(void)setupHeader{

    // 清空热门评论
    if (self.topic.top_cmt) {
        self.saved_top_cmt = self.topic.top_cmt;
        self.topic.top_cmt = nil;
        self.topic.cellHeight = 0;
    }
    // 创建header
    UIView *header = [[UIView alloc] init];
    // 添加cell
    WXHTopicCell *cell = [WXHTopicCell viewFromXib];
    cell.topic = self.topic;
    cell.wxh_size = CGSizeMake(kWidth, self.topic.cellHeight);
    [header addSubview:cell];
    
    // header的高度
    header.wxh_height = self.topic.cellHeight + WXHCommonMargin;
    
    // 设置header
    self.tableView.tableHeaderView = header;
}
#pragma mark - refresh
- (void)setupRefresh
{
    self.tableView.mj_header = [WXHRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    [self.tableView.mj_header beginRefreshing];
    
    self.tableView.mj_footer = [WXHRefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    self.tableView.mj_footer.hidden = YES;
}
#pragma mark - 加载新数据
-(void)loadNewData{

    // 取消所有的请求
    [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];
    // 参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = @"dataList";
    params[@"c"] = @"comment";
    params[@"data_id"] = self.topic.ID;
    params[@"hot"] = @"1";
    [WXHHttpTool get:WXHCommonURL params:params success:^(id responseObj) {
        WXHAFNWriteToPlist(comment);
        // 最热评论
        self.hotComments = [WXHComment mj_objectArrayWithKeyValuesArray:responseObj[@"hot"]];
        // 最新评论
        self.latestComments = [WXHComment mj_objectArrayWithKeyValuesArray:responseObj[@"data"]];
        // 当前页码
        self.currentPage = 1;
        // 刷新数据
        [self.tableView reloadData];
        // 结束刷新
        [self.tableView.mj_header endRefreshing];
        // 控制footer的状态
        NSInteger total = [responseObj[@"total"] integerValue];
        self.tableView.mj_footer.hidden = (self.latestComments.count >= total);
        
    } failure:^(NSError *error) {
        // 结束刷新
        [self.tableView.mj_header endRefreshing];
    }];

}
#pragma mark - 加载更多数据
-(void)loadMoreData{
    // 取消所有的请求
    [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];
    WXHComment *lastComment = [self.latestComments lastObject];
    // 页码
    NSInteger page = self.currentPage + 1;
    // 参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = @"dataList";
    params[@"c"] = @"comment";
    params[@"data_id"] = self.topic.ID;
    params[@"hot"] = @(page);
    params[@"lastcid"] = lastComment.ID;
    [WXHHttpTool get:WXHCommonURL params:params success:^(id responseObj) {
        WXHAFNWriteToPlist(comment);
        // 最新评论
        NSArray *moreComments = [WXHComment mj_objectArrayWithKeyValuesArray:responseObj[@"data"]];
            self.currentPage = page;
        [self.latestComments addObjectsFromArray:moreComments];
        // 刷新数据
        [self.tableView reloadData];
        // 控制footer的状态
        NSInteger total = [responseObj[@"total"] integerValue];
        WXHLOG(@"count = %ld    total = %ld",self.latestComments.count,total);
        if (self.latestComments.count >= total) {
            // 全部加载完毕
            self.tableView.mj_footer.hidden = YES;
        }else{
            [self.tableView.mj_footer endRefreshing];
        }
        
    } failure:^(NSError *error) {
        // 结束刷新
        [self.tableView.mj_footer endRefreshing];
    }];

}
#pragma mark - 监听键盘frame的改变
-(void)keyboardWillChangeFrame:(NSNotification *)note{

    // 键盘显示\隐藏完毕时的frame
    CGRect frame = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    // 修改底部约束
    self.bottomConstraint.constant = kHeight - frame.origin.y;
    // 动画时间
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    [UIView animateWithDuration:duration animations:^{
        [self.view layoutIfNeeded];
    }];
}
#pragma mark - <UITableViewDataSource>
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    NSInteger hotCount = self.hotComments.count;
    NSInteger latestCount = self.latestComments.count;
    
    if (hotCount) return 2; // 有"最热评论" + "最新评论" 2组
    if (latestCount) return 1; // 有"最新评论" 1 组
    return 0;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self commentsInSection:section].count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WXHCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    cell.comment = [self commentInIndexPath:indexPath];
    
    return cell;
}
#pragma mark - 返回第section组的所有评论数组
-(NSArray *)commentsInSection:(NSInteger)section{
    if (section == 0) {
        return self.hotComments.count ? self.hotComments : self.latestComments;
    }
    return self.latestComments;
}
#pragma mark - 返回某行的评论
-(WXHComment *)commentInIndexPath:(NSIndexPath *)indexPath{
    return [self commentsInSection:indexPath.section][indexPath.row];
}
#pragma mark - <UITableViewDelegate>
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    WXHCommentHeaderView *view = [WXHCommentHeaderView headerViewWithTableView:tableView];
    // 设置label数据
    NSInteger hotCount = self.hotComments.count;
    if (section == 0) {
        view.headerTitle = hotCount ? @"热门评论" : @"最新评论";
    }else{
        view.headerTitle = @"最新评论";
    }
    return view;
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];
}
@end
