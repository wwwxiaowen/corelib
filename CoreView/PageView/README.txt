//广告图片轮播器
//依赖 SDWebImage 框架    

 
//本地图片
//    NSArray *imageArray = [[NSArray alloc] initWithObjects:@"img_01",@"img_02",@"img_03",@"img_04",nil];
   

 //网络图片
    NSArray *imageArray = @[@"http://i1.douguo.net//upload/banner/0/6/a/06e051d7378040e13af03db6d93ffbfa.jpg", @"http://i1.douguo.net//upload/banner/9/3/4/93f959b4e84ecc362c52276e96104b74.jpg", @"http://i1.douguo.net//upload/banner/5/e/3/5e228cacf18dada577269273971a86c3.jpg", @"http://i1.douguo.net//upload/banner/d/8/2/d89f438789ee1b381966c1361928cb32.jpg"];
    PageView *pageView = [[PageView alloc] initPageViewFrame:CGRectMake(0, 0, self.view.bounds.size.width, 200)];
    //是否是网络图片
    pageView.isWebImage = YES;
    //存放图片数组
    pageView.imageArray = imageArray;
    //停留时间
    pageView.duration = 5.0;
    
    [self.view addSubview:pageView];