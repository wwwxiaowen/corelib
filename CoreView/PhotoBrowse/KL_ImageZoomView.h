//
//  KL_ImageZoomView.h
//  ShowImgDome
//
//  Created by chuliangliang on 14-9-28.
//  Copyright (c) 2014年 aikaola. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDWebImageManager.h"
#import "UIImageView+WebCache.h"

@interface KL_ImageZoomView : UIView <UIScrollViewDelegate,SDWebImageManagerDelegate>
{
    CGFloat viewscale;
    NSString *downImgUrl;
    
}
@property (nonatomic, retain) UIScrollView *scrollView;
@property (nonatomic, retain) UIImageView *imageView;
@property (nonatomic, retain) UIImage *image;
@property (nonatomic, assign) BOOL isViewing;
@property (nonatomic, retain)UIView *containerView; 

- (void)resetViewFrame:(CGRect)newFrame;
- (void)updateImage:(NSString *)imgName;
- (void)uddateImageWithUrl:(NSString *)imgUrl;

@end
