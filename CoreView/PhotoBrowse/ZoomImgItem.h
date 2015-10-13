//
//  ZoomImgItem.h
//  ShowImgDome
//
//  Created by chuliangliang on 14-9-28.
//  Copyright (c) 2014年 aikaola. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KL_ImageZoomView.h"

@interface ZoomImgItem : UITableViewCell
{
    KL_ImageZoomView *zoomImageView;
}

@property (nonatomic, retain)NSString *imgName;//可能是本地路径/也可以能是http地址
@property (nonatomic, assign)CGSize size;
@property (nonatomic, retain)KL_ImageZoomView *zoomImageView;
@end
