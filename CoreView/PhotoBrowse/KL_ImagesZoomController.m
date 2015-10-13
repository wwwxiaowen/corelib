//
//  KL_ImagesZoomController.m
//  ShowImgDome
//
//  Created by chuliangliang on 14-9-28.
//  Copyright (c) 2014年 aikaola. All rights reserved.
//


#import "KL_ImagesZoomController.h"
#import "ZoomImgItem.h"

@interface KL_ImagesZoomController ()
{
    UITableView *m_TableView;
    UILabel *_indexLabel; 
}
@end

@implementation KL_ImagesZoomController

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self _initView];
    }
    return self;
}

- (void)updateImageDate:(NSMutableArray *)imageArr selectIndex:(NSInteger)index
{
    self.imgs = imageArr;
    currentIndex = index;
    [m_TableView reloadData];
    if (index > 0 && index < self.imgs.count) {
        NSInteger row = MAX(index, 0);
        [m_TableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:row  inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    } 
    if (indexBlock) {
        indexBlock(index,self.imgs.count);
    }
     _indexLabel.text = [NSString stringWithFormat:@"%lu / %lu",(unsigned long)(currentIndex+1),(unsigned long)self.imgs.count];
}

- (void)_initView
{
    m_TableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.height, self.frame.size.width)
                                               style:UITableViewStylePlain];
    m_TableView.delegate = self;
    m_TableView.dataSource = self;
    m_TableView.center = CGPointMake(self.frame.size.width * 0.5, self.frame.size.height * 0.5);
    m_TableView.showsVerticalScrollIndicator = NO;
    m_TableView.transform = CGAffineTransformMakeRotation(-M_PI / 2);
    m_TableView.pagingEnabled = YES;
    m_TableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    m_TableView.backgroundView = nil;
    m_TableView.backgroundColor = [UIColor blackColor];
    [self addSubview:m_TableView];
    
    [self createToolbar];
}

- (void)createToolbar
{
    _indexLabel = [[UILabel alloc] init];
    _indexLabel.font = [UIFont boldSystemFontOfSize:20];
    _indexLabel.frame =  CGRectMake(0, kStatusBarAdapterHeight, kWindowWidth, 44);
    _indexLabel.backgroundColor = [UIColor clearColor];
    _indexLabel.textColor = [UIColor whiteColor];
    _indexLabel.textAlignment = NSTextAlignmentCenter;
    _indexLabel.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;;
    [self addSubview:_indexLabel];
}
- (void)updateBrowsePhotoIndex:(DidChangeBrowsePhotoBlock)block{
    indexBlock = [block copy];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.imgs.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *idty = @"imgshowCell";
    ZoomImgItem *cell = [tableView dequeueReusableCellWithIdentifier:idty];
    if (cell == nil) {
        cell = [[[ZoomImgItem alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:idty]  autorelease];
        cell.contentView.transform = CGAffineTransformMakeRotation(M_PI / 2);
    }
    cell.size = self.bounds.size;  
    cell.imgName = [self.imgs objectAtIndex:indexPath.row];;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.frame.size.width;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   
}

- (void)updateTableViewImageData{
    [m_TableView reloadData];
}

//- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
//{
////    NSLog(@"showIndex: %d",indexPath.row);
//    
//    progressLabel.text = [NSString stringWithFormat:@"%d/%d",indexPath.row + 1,self.imgs.count];
//}
//
//- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
//{
//    NSIndexPath *index =  [m_TableView indexPathForRowAtPoint:scrollView.contentOffset];
//    if (index.row != currentIndex) {
//        currentIndex = index.row;
//        if (indexBlock) {
//            indexBlock(index.row,self.imgs.count);
//        }
//    }
//}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSIndexPath *index =  [m_TableView indexPathForRowAtPoint:scrollView.contentOffset];
    if (index.row != currentIndex) { 
        currentIndex = index.row;
        if (indexBlock) {
            indexBlock(index.row,self.imgs.count);
        }
        _indexLabel.text = [NSString stringWithFormat:@"%ld / %ld",(long)(index.row+1),(long)self.imgs.count];
    }
}

@end
