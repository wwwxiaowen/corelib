//view 顶部图片放大缩小，类似淘宝宝贝详情页导航栏以及图片切换效果

- (void)viewDidLoad 
{   
    //导航栏设置成无色
    [self.navigationController.navigationBar fs_setBackgroundColor:[UIColor clearColor]];
    
    //顶部放大缩小图片
    UIImageView *topView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"6.jpeg"]];
    topView.frame = CGRectMake(0, 0, self.view.frame.size.width, 200);
  
    //嵌入滑动页面
    HUFlexibleParallaxView *flexibleView = [[HUFlexibleParallaxView alloc] initWithFrame:self.view.frame topView:topView];
    flexibleView.delegate = self;
    [flexibleView setContentSize:CGSizeMake(self.view.frame.size.width, 1250)];
    [self.view addSubview:flexibleView];
}

//滑动页面回调
#pragma mark HUFlexibleParallaxView delegate
//到达导航栏并且滑动时一直触发
- (void)flexibleParallaxViewDidScrollToTop:(HUFlexibleParallaxView *)flexibleView {
    //设置导航栏按钮
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.buttonGroup];
}

//滑出导航栏并且滑动时一直触发
-(void)flexibleParallaxViewDidScrollFRomTop:(HUFlexibleParallaxView *)flexibleView {
    //把按钮放大哦scrollview中，类似淘宝宝贝详情中导航栏的切换效果
    self.buttonGroup.frame = _defaultRect;
    [flexibleView addSubView:self.buttonGroup];
}
- (void)flexibleParallaxViewDidScroll:(HUFlexibleParallaxView *)flexibleView {
    CGFloat offsetY = flexibleView.contentOffset.y;
    //滑动页面滑动时导航栏渐变效果
    if (offsetY >0) {
        CGFloat alpha = (offsetY -64) / 64 ;
        alpha = MIN(alpha, 0.9);
        [self.navigationController.navigationBar fs_setBackgroundColor:[[UIColor whiteColor] colorWithAlphaComponent:alpha]];
    } else {
        [self.navigationController.navigationBar fs_setBackgroundColor:[UIColor clearColor]];
    }
}


