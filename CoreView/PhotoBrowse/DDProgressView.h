//
//  DDProgressView.h
//  DDProgressView
//
//  Created by Damien DeVille on 3/13/11.
//  Copyright 2011 Snappy Code. All rights reserved.
//

#if TARGET_OS_IPHONE
#import <UIKit/UIKit.h>
#elif TARGET_OS_MAC
#import "AppKitCompatibility.h"
#endif

@interface DDProgressView : UIView
{
@private
	float progress ;
	UIColor *innerColor ;
	UIColor *outerColor ;
    UIColor *emptyColor ;
}
/*//进度颜色*/
@property (nonatomic,retain) UIColor *innerColor ;
///*边框 颜色*/
//@property (nonatomic,retain) UIColor *outerColor ;
/*背景*/
@property (nonatomic,retain) UIColor *emptyColor ;

/*
 *拓展 是否支持 自动隐藏 默认 不支持
 */
@property (nonatomic,assign) BOOL automaticHidden;

@property (nonatomic,assign) float progress ;

/*
 * 拓展
 * 爱考拉 webView LoadProgress
 */
@property (nonatomic,assign) float webViewProgress;
@end
