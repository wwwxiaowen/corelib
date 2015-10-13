//
//  SlideTabBarView.m
//  SlideTabBar
//
//  Created by www_xiaowen on 15/6/25.
//  Copyright (c) 2015年 温火光. All rights reserved.
//

#import "SlideTabBarView.h"
#import "SlideBarCell.h"


#define TOPHEIGHT 45
#define MAXTOPITEM 4
@interface SlideTabBarView()<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate>{
    NSArray *tabarArr;
}
@property (assign) CGRect mViewFrame; //@brife 整个视图的大小

@property (strong, nonatomic) UIScrollView *topScrollView; //上方的ScrollView
@property (strong, nonatomic) UIView *slideView;//滑动的slideView
@property (strong, nonatomic) UIScrollView *scrollView; //下方的ScrollView

@property (strong, nonatomic) NSMutableArray *topViews; //上方的按钮数组
@property (strong, nonatomic) NSMutableArray *scrollTableViews; //下方的表格数组
@property (strong, nonatomic) NSMutableArray *dataSource; //ableViews的数据源
@property (assign) NSInteger currentPage; //当前选中页数
@end

@implementation SlideTabBarView

-(instancetype)initWithFrame:(CGRect)frame WithTopBarItemNameArr: (NSArray *)tabArr{
    self = [super initWithFrame:frame];
    
    if (self) {
        _mViewFrame = frame;
        _topViews = [[NSMutableArray alloc] init];
        _scrollTableViews = [[NSMutableArray alloc] init];
        
        tabarArr = tabArr;
        [self initDataSource];
        
        [self initTopTabs];
        [self initSlideView];
        [self initScrollView];
        [self initDownTables];
    }
    return self;
}


#pragma mark -- 初始化滑动的指示View
-(void) initSlideView{
    CGFloat width = _mViewFrame.size.width / MAXTOPITEM;
    if(tabarArr.count <= MAXTOPITEM){
        width = _mViewFrame.size.width / tabarArr.count;
    }
    _slideView = [[UIView alloc] initWithFrame:CGRectMake(0, TOPHEIGHT - 2,width, 2)];
    [_slideView setBackgroundColor:[UIColor redColor]];
    [_topScrollView addSubview:_slideView];
}


#pragma mark -- 初始化表格的数据源
-(void) initDataSource{
    _dataSource = [[NSMutableArray alloc] initWithCapacity:tabarArr.count]; 
    for (int i = 1; i <= tabarArr.count; i ++) {
        NSMutableArray *tempArray  = [[NSMutableArray alloc] initWithCapacity:20];
        for (int j = 1; j <= 20; j ++) {
            NSString *tempStr = [NSString stringWithFormat:@"我是第%d个TableView的第%d条数据。", i, j];
            [tempArray addObject:tempStr];
        }
        [_dataSource addObject:tempArray];
    }
}

#pragma mark -- 实例化ScrollView
-(void) initScrollView{
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, _mViewFrame.origin.y, _mViewFrame.size.width, _mViewFrame.size.height - TOPHEIGHT)];
    _scrollView.contentSize = CGSizeMake(_mViewFrame.size.width * tabarArr.count, _mViewFrame.size.height - TOPHEIGHT);
    _scrollView.backgroundColor = [UIColor whiteColor];
    _scrollView.pagingEnabled = YES;
    _scrollView.delegate = self;
    [self addSubview:_scrollView];
}

#pragma mark -- 实例化顶部的tab
-(void) initTopTabs{
    CGFloat width = _mViewFrame.size.width / MAXTOPITEM;
    if(tabarArr.count <= MAXTOPITEM){
        width = _mViewFrame.size.width / tabarArr.count;
    }
    _topScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, _mViewFrame.size.width, TOPHEIGHT)];
    _topScrollView.showsHorizontalScrollIndicator = NO;
    _topScrollView.showsVerticalScrollIndicator = YES;
    _topScrollView.bounces = NO;
    _topScrollView.delegate = self;
    _topScrollView.pagingEnabled = YES;
    if (tabarArr.count >= MAXTOPITEM) {
        _topScrollView.contentSize = CGSizeMake(width * tabarArr.count, TOPHEIGHT);
    } else {
        _topScrollView.contentSize = CGSizeMake(_mViewFrame.size.width, TOPHEIGHT);
    }
    _topScrollView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self addSubview:_topScrollView];
    
    
    for (int i = 0; i < tabarArr.count; i ++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(i*width, 0, width, TOPHEIGHT)];
        button.tag = i+100;
        [button setTitle:[tabarArr objectAtIndex:i] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(tabButton:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitleColor:i==0?[UIColor redColor]:[UIColor blackColor] forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [_topScrollView addSubview:button];
    }
}

#pragma mark --点击顶部的按钮所触发的方法
-(void) tabButton:(id) sender{
    UIButton *button = sender;
    [_scrollView setContentOffset:CGPointMake((button.tag-100) * _mViewFrame.size.width, 0) animated:YES];
    for (int i=0;i<tabarArr.count;i++) {
        UIButton *btn = (UIButton *)[_topScrollView viewWithTag:i+100];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
}

#pragma mark --初始化下方的TableViews
-(void) initDownTables{
    for (int i = 0; i < 2; i ++) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(i * _mViewFrame.size.width, 0, _mViewFrame.size.width, _mViewFrame.size.height - TOPHEIGHT)];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.tag = i;
        [_scrollTableViews addObject:tableView];
        [_scrollView addSubview:tableView];
    } 
}

#pragma mark --根据scrollView的滚动位置复用tableView，减少内存开支
-(void) updateTableWithPageNumber: (NSUInteger) pageNumber{
    for (int i=0;i<tabarArr.count;i++) {
        UIButton *btn = (UIButton *)[_topScrollView viewWithTag:i+100];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    UIButton *button = (UIButton *)[_topScrollView viewWithTag:100+pageNumber];
    [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    
    if (tabarArr.count >= MAXTOPITEM) {
        NSInteger page = pageNumber/MAXTOPITEM;
        [_topScrollView setContentOffset:CGPointMake(page*_mViewFrame.size.width, 0)];
    }
    int tabviewTag = pageNumber % 2;
    CGRect tableNewFrame = CGRectMake(pageNumber * _mViewFrame.size.width, 0, _mViewFrame.size.width, _mViewFrame.size.height - TOPHEIGHT);
    UITableView *reuseTableView = _scrollTableViews[tabviewTag];
    reuseTableView.frame = tableNewFrame;
    [reuseTableView reloadData];
}

#pragma mark -- scrollView的代理方法
-(void) modifyTopScrollViewPositiong: (UIScrollView *) scrollView{
    if ([_topScrollView isEqual:scrollView]) {
        CGFloat contentOffsetX = _topScrollView.contentOffset.x;
        CGFloat width = _slideView.frame.size.width;
        int count = (int)contentOffsetX/(int)width;
        CGFloat step = (int)contentOffsetX%(int)width;
        CGFloat sumStep = width * count;
        if (step > width/2) {
            sumStep = width * (count + 1);
        }
        [_topScrollView setContentOffset:CGPointMake(sumStep, 0) animated:YES];
        return;
    }
}
///拖拽后调用的方法
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    //[self modifyTopScrollViewPositiong:scrollView];
}

-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    [self scrollViewDidEndDecelerating:scrollView];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if ([scrollView isEqual:_scrollView]) {
        _currentPage = _scrollView.contentOffset.x/_mViewFrame.size.width;
        [self updateTableWithPageNumber:_currentPage];
        return;
    }
    [self modifyTopScrollViewPositiong:scrollView];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if ([_scrollView isEqual:scrollView]) {
        CGRect frame = _slideView.frame;
        if (tabarArr.count <= MAXTOPITEM) {
            frame.origin.x = scrollView.contentOffset.x/tabarArr.count;
        } else {
            frame.origin.x = scrollView.contentOffset.x/MAXTOPITEM;
        }
        _slideView.frame = frame;
    }
}





#pragma mark -- talbeView的代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSMutableArray *tempArray = _dataSource[_currentPage];
    return tempArray.count;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 160;
}

-(UITableViewCell *)tableView:tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    BOOL nibsRegistered=NO;
    if (!nibsRegistered) {
        UINib *nib=[UINib nibWithNibName:@"SlideBarCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:@"SlideBarCell"];
        nibsRegistered=YES;
    }
    
    SlideBarCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SlideBarCell"];
    if ([tableView isEqual:_scrollTableViews[_currentPage%2]]) {
        cell.tipTitle.text = _dataSource[_currentPage][indexPath.row];
    }
   
    return cell;
}
@end
