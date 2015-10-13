//
//  KL_ImageZoomView.m
//  ShowImgDome
//
//  Created by chuliangliang on 14-9-28.
//  Copyright (c) 2014年 aikaola. All rights reserved.
//

#import "KL_ImageZoomView.h"
#import "PublicImageCache.h"
#include "MJPhotoLoadingView.h"
  
#define HandDoubleTap 2
#define HandOneTap 1
#define MaxZoomScaleNum 5.0
#define MinZoomScaleNum 1.0 
@interface KL_ImageZoomView ()
{
    MJPhotoLoadingView *_photoLoadingView;
}
@end
@implementation KL_ImageZoomView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self _initView];
    }
    return self;
}

//获取图片和显示视图宽度的比例系数
- (float)getImgWidthFactor {
   return   self.bounds.size.width / self.image.size.width;
}
//获取图片和显示视图高度的比例系数
- (float)getImgHeightFactor {
    return  self.bounds.size.height / self.image.size.height;
}

//获获取尺寸
- (CGSize)newSizeByoriginalSize:(CGSize)oldSize maxSize:(CGSize)mSize
{
    if (oldSize.width <= 0 || oldSize.height <= 0) {
        return CGSizeZero;
    }
    
    CGSize newSize = CGSizeZero;
    if (oldSize.width > mSize.width || oldSize.height > mSize.height) {
        //按比例计算尺寸
        float bs = [self getImgWidthFactor];
        float newHeight = oldSize.height * bs;
        newSize = CGSizeMake(mSize.width, newHeight);
        
        if (newHeight > mSize.height) {
            bs = [self getImgHeightFactor];
            float newWidth = oldSize.width * bs;
            newSize = CGSizeMake(newWidth, mSize.height);
        }
    }else {
        
        newSize = oldSize;
    }
    return newSize;
}

- (void)_initView {
    
    self.backgroundColor = [UIColor blackColor];
    self.clipsToBounds = YES;
    self.contentMode = UIViewContentModeScaleAspectFill;
    
    _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    _scrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.delegate = self;
    _scrollView.bounces = NO;
    _containerView = [[UIView alloc] initWithFrame:self.bounds];
    [_scrollView addSubview:_containerView];
    
    [self addSubview:_scrollView];

    _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
    [_containerView addSubview:_imageView];
    
    //双击
    UITapGestureRecognizer *doubleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                       action:@selector(TapsAction:)];
    [doubleTapGesture setNumberOfTapsRequired:HandDoubleTap];
    [_containerView addGestureRecognizer:doubleTapGesture];
    
    //单击
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                 action:@selector(TapsAction:)];
    [tapGesture setNumberOfTapsRequired:HandOneTap];
    [_containerView addGestureRecognizer:tapGesture];
    
    //双击失败之后执行单击
    [tapGesture requireGestureRecognizerToFail:doubleTapGesture];

 
    // 进度条
    _photoLoadingView = [[MJPhotoLoadingView alloc] init];
 
//    CGSize showSize = [self newSizeByoriginalSize:self.image.size maxSize:self.bounds.size];
//
//    UIImageView *imgview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, showSize.width, showSize.height)];
//    imgview.image = self.image;
//     self.imageView = imgview;
//    [imgview release];
    
    self.scrollView.maximumZoomScale = MaxZoomScaleNum;
    self.scrollView.minimumZoomScale = MinZoomScaleNum;
    self.scrollView.zoomScale = MinZoomScaleNum;

}

- (void)resetViewFrame:(CGRect)newFrame
{
    self.frame = newFrame;
    _scrollView.frame = self.bounds;
    _containerView.frame = self.bounds;
    
//    CGSize vsize = self.frame.size;
//    self.progress.hidden = NO;
//    self.progress.frame = CGRectMake(15, (vsize.height - 2) * 0.5,vsize.width - 30 , 2);
}


#pragma mark- 手势事件
//单击 / 双击 手势
- (void)TapsAction:(UITapGestureRecognizer *)tap
{
    NSInteger tapCount = tap.numberOfTapsRequired;
    if (HandDoubleTap == tapCount) {
        //双击
        NSLog(@"双击");
        if (self.scrollView.minimumZoomScale <= self.scrollView.zoomScale && self.scrollView.maximumZoomScale > self.scrollView.zoomScale) {
            [self.scrollView setZoomScale:self.scrollView.maximumZoomScale animated:YES];
        }else {
            [self.scrollView setZoomScale:self.scrollView.minimumZoomScale animated:YES];
        }
        
    }else if (HandOneTap == tapCount) {
        //单击
        [[NSNotificationCenter defaultCenter] postNotificationName:@"NNKEY_Browse_Photo_Sigle_Tap_Notification" object:nil];
        NSLog(@"单击");
//        NSLog(@"imgUrl: %@, imgSize:(%f, %f) zoomScale:%f",downImgUrl,self.imageView.frame.size.width,self.imageView.frame.size.height,self.scrollView.zoomScale);
        
    }
}


#pragma mark- Properties

- (UIImage *)image {
    return _imageView.image;
}

- (void)setImage:(UIImage *)image {
    if(_imageView == nil){
        _imageView = [[UIImageView alloc] init];
        _imageView.clipsToBounds = YES;
    }
    _imageView.image = image;
}

//本地图片
- (void)updateImage:(NSString *)imgName {
    self.scrollView.scrollEnabled = YES;
    self.image = [UIImage imageNamed:imgName];
    [self setImageViewWithImg:self.image];
}
//网络图片
- (void)uddateImageWithUrl:(NSString *)imgUrl
{
    self.scrollView.scrollEnabled = NO;
    self.imageView.image = nil;
    downImgUrl = imgUrl;
    [_photoLoadingView setFrame:[UIScreen mainScreen].bounds];
    [_photoLoadingView showLoading];
    [self addSubview:_photoLoadingView];
    
    __block MJPhotoLoadingView *loading = _photoLoadingView;
    if ([imgUrl hasPrefix:@"http"]||[imgUrl hasPrefix:@"HTTP"]) {
        
        [self.imageView setImageWithURL:[NSURL URLWithString:downImgUrl] placeholderImage:nil options:SDWebImageRetryFailed|SDWebImageLowPriority progress:^(NSUInteger receivedSize, long long expectedSize) {
            double progress =(double)((double)receivedSize/((double)expectedSize));
            dispatch_async(dispatch_get_main_queue(), ^{
                if (receivedSize > kMinProgress) {
                    if (loading) {
                        if ([loading respondsToSelector:@selector(setProgress:)]) {
                            loading.progress = progress;
                        }
                    }
                } 
            });
            
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (image) {
                    [_photoLoadingView removeFromSuperview];
                } else {
                    [self addSubview:_photoLoadingView];
                    [_photoLoadingView showFailure];
                }
                [self setImageViewWithImg:image];
            });
        }];
        
//        SDWebImageManager *manager = [SDWebImageManager sharedManager];
//         NSString *url = [[ImageUrlProcessEngine shareEngine] getImageUrlByUrl:downImgUrl];
//        [manager downloadWithURL:[NSURL URLWithString:url] options:SDWebImageRetryFailed progress:^(NSUInteger receivedSize, long long expectedSize) {
//            NSLog(@"receivedSize %lu /expectedSize %lld ---:%lld",(unsigned long)receivedSize,expectedSize,receivedSize/expectedSize);
//            dispatch_async(dispatch_get_main_queue(), ^{ 
//                self.progress.progress = receivedSize/expectedSize;
//            });
//        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished) {
//            dispatch_async(dispatch_get_main_queue(), ^{
//                self.progress.hidden = YES;
//                self.progress.progress = 0;
//                [self setImageViewWithImg:image];
//            });
//        }];
    }else{//取本地生成图片

        [_photoLoadingView removeFromSuperview];
        UIImage *IMAGE = [[PublicImageCache sharedImageCache] imageFromCacheForPath:imgUrl];
        [self setImageViewWithImg:IMAGE];
    }
}
- (void)setImageViewWithImg:(UIImage *)img {
    self.scrollView.scrollEnabled = YES;
    self.imageView.image = img;
    CGSize showSize = [self newSizeByoriginalSize:img.size maxSize:self.bounds.size];
    self.imageView.frame = CGRectMake(0, 0, showSize.width, showSize.height);
    
    _scrollView.zoomScale = 1;
    _scrollView.contentOffset = CGPointZero;
    _containerView.bounds = _imageView.bounds;
//    [self resetZoomScale];
    _scrollView.zoomScale  = _scrollView.minimumZoomScale;
    [self scrollViewDidZoom:_scrollView];
    
//    [self imageDidChange];
}

//- (void)setImageView:(UIImageView *)imageView {
//    if(imageView != _imageView){
//        [_imageView removeObserver:self forKeyPath:@"image"];
//        [_imageView removeFromSuperview];
//        
//        _imageView = imageView;
//        
//        CGSize showSize = [self newSizeByoriginalSize:self.image.size maxSize:self.bounds.size];
//
//        _imageView.frame = CGRectMake(0, 0, showSize.width, showSize.height);
//        
//        [_imageView addObserver:self forKeyPath:@"image" options:0 context:nil];
//        
//        [_containerView addSubview:_imageView];
//        
//        _scrollView.zoomScale = 1;
//        _scrollView.contentOffset = CGPointZero;
//        _containerView.bounds = _imageView.bounds;
//        
//        [self resetZoomScale];
//        _scrollView.zoomScale  = _scrollView.minimumZoomScale;
//        [self scrollViewDidZoom:_scrollView];
//    }
//    
//}

- (BOOL)isViewing {
    return (_scrollView.zoomScale != _scrollView.minimumZoomScale);
}

#pragma mark- observe
//
//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
//    if(object==self.imageView){
//        [self imageDidChange];
//    }
//}

//- (void)imageDidChange {
//    CGSize size = (self.imageView.image) ? self.imageView.image.size : self.bounds.size;
//    CGFloat ratio = MIN(_scrollView.frame.size.width / size.width, _scrollView.frame.size.height / size.height);
//    CGFloat W = ratio * size.width;
//    CGFloat H = ratio * size.height;
//    self.imageView.frame = CGRectMake(0, 0, W, H);
//    
//    _scrollView.zoomScale = 1;
//    _scrollView.contentOffset = CGPointZero;
//    _containerView.bounds = _imageView.bounds;
//    
//    [self resetZoomScale];
//    _scrollView.zoomScale  = _scrollView.minimumZoomScale;
//    [self scrollViewDidZoom:_scrollView];
//}

#pragma mark- Scrollview delegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return _containerView;
}


- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    CGFloat Ws = _scrollView.frame.size.width - _scrollView.contentInset.left - _scrollView.contentInset.right;
    CGFloat Hs = _scrollView.frame.size.height - _scrollView.contentInset.top - _scrollView.contentInset.bottom;
    CGFloat W = _containerView.frame.size.width;
    CGFloat H = _containerView.frame.size.height;
    
    CGRect rct = _containerView.frame;
    rct.origin.x = MAX((Ws-W)*0.5, 0);
    rct.origin.y = MAX((Hs-H)*0.5, 0);
    _containerView.frame = rct;
    
}



//- (void)resetZoomScale {
//    CGFloat Rw = _scrollView.frame.size.width / self.imageView.frame.size.width;
//    CGFloat Rh = _scrollView.frame.size.height / self.imageView.frame.size.height;
//    
//    CGFloat scale = 1;
//    Rw = MAX(Rw, _imageView.image.size.width / (scale * _scrollView.frame.size.width));
//    Rh = MAX(Rh, _imageView.image.size.height / (scale * _scrollView.frame.size.height));
//    
//    _scrollView.contentSize = _imageView.frame.size;
//    _scrollView.minimumZoomScale = 1;
//    _scrollView.maximumZoomScale = MAX(MAX(Rw, Rh), 1);
//}

- (void)dealloc {
    [super dealloc];
}

 

@end
