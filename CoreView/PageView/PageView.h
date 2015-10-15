//
//  PageView.h
//  05-图片轮播器
//
//  Created by 柒月丶 on 15-8-6.
//  Copyright (c) 2015年 柒月丶. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PageViewDelegate <NSObject>

- (void)didSelectPageViewWithNumber:(NSInteger)selectNumber;

@end


@interface PageView : UIView

@property (nonatomic, strong) NSArray * imageArray;

@property (nonatomic ,assign) NSTimeInterval duration;

@property (nonatomic ,assign) BOOL isWebImage;

-(instancetype)initPageViewFrame:(CGRect)frame;

@property (nonatomic ,weak) id<PageViewDelegate> delegate;

@end
