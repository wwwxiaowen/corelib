//  Created by  on 12-8-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//


#ifndef  DefineUtil_h
#define  DefineUtil_h


//常用 宏定义 －－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－

//ios系统版本
#define ios8x    [[[UIDevice currentDevice] systemVersion] floatValue] >=8.0f
#define ios7x    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0f) && ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0f)
#define ios6x    [[[UIDevice currentDevice] systemVersion] floatValue] < 7.0f
#define iosNot6x [[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0f

#define IS_iOS7AndLater   ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)

#define iphone4x_3_5   ([UIScreen mainScreen].bounds.size.height==480.0f)

#define iphone5x_4_0   ([UIScreen mainScreen].bounds.size.height==568.0f)

#define iphone6_4_7    ([UIScreen mainScreen].bounds.size.height==667.0f)

#define iphone6Plus_5_5 ([UIScreen mainScreen].bounds.size.height==736.0f || [UIScreen mainScreen].bounds.size.height==414.0f)

//屏幕宽高
#define kScreenW [[UIScreen mainScreen] bounds].size.width
#define kScreenH [[UIScreen mainScreen] bounds].size.height

//屏幕frame,bounds,size
#define kScreenFrame [UIScreen mainScreen].bounds
#define kScreenBounds [UIScreen mainScreen].bounds
#define kScreenSize [UIScreen mainScreen].bounds.size

#define kWindowFrame           [[UIScreen mainScreen] bounds]
#define kWindowWidth           [[UIScreen mainScreen] bounds].size.width
#define kWindowHeight          [[UIScreen mainScreen] bounds].size.height
#define kWindowSize            [UIScreen mainScreen].bounds.size
#define kWindowStatusBarFrame  [[UIApplication sharedApplication] statusBarFrame]
#define kNavigationViewHeight  44
#define kWindowTabBarHeight    49

#define kTipsTopOffset         70
#define kTipsTopOffset2        140
#define kTipsDuration          1.5f

#define kStatusBarHeight          ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0 ? 0 : (([UIApplication sharedApplication].statusBarHidden) ? 0 : 20 ))
#define kStatusBarAdapterHeight   ([[[UIDevice currentDevice] systemVersion] floatValue] >=  7.0 ? 20 : 0)



//常用 font －－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－
#define kUIFONT_10 [UIFont systemFontOfSize:10]
#define kUIFONT_11 [UIFont systemFontOfSize:11]
#define kUIFONT_12 [UIFont systemFontOfSize:12]
#define kUIFONT_13 [UIFont systemFontOfSize:13]
#define kUIFONT_14 [UIFont systemFontOfSize:14]
#define kUIFONT_15 [UIFont systemFontOfSize:15]
#define kUIFONT_16 [UIFont systemFontOfSize:16]
#define kUIFONT_18 [UIFont systemFontOfSize:18]


#define rgb(r,g,b) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1.0f]
#define rgba(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define hexColor(colorV) [UIColor colorWithHexColorString:@#colorV]
#define hexColorAlpha(colorV,a) [UIColor colorWithHexColorString:@#colorV alpha:a];


 
//常用 color －－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－
#define kUIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0  green:((float)((rgbValue & 0xFF00) >> 8))/255.0  blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define kRGBA(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define kUIColorFromRGBA(rValue ,aplaValue) [UIColor colorWithRed:((float)((rValue & 0xFF0000) >> 16))/255.0  green:((float)((rValue & 0xFF00) >> 8))/255.0  blue:((float)(rValue & 0xFF))/255.0 alpha:aplaValue]


//常用 path －－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－
#define kDOCUMENTS_DICTORY_URL  [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject]

#define kDOCUMENTS_DICTORY_PATH [(NSArray *)(NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)) objectAtIndex:0]

#define kDOCUMENTS_PATH         [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]

#define kHOME_DICTORY_PATH      NSHomeDirectory()
#define kTMP_DICTORY_PATH       NSTemporaryDirectory()
#define kFILE_MANAGER           [NSFileManager defaultManager]


//高度计算适配－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 70000
    #define kMULTILINE_TEXTSIZE(text, font, maxSize, mode) [text length] > 0 ? [text \
        boundingRectWithSize:maxSize options:(NSStringDrawingUsesLineFragmentOrigin) \
        attributes:@{NSFontAttributeName:font} context:nil].size : CGSizeZero;
#else
    #define kMULTILINE_TEXTSIZE(text, font, maxSize, mode) [text length] > 0 ? [text \
        sizeWithFont:font constrainedToSize:maxSize lineBreakMode:mode] : CGSizeZero;
#endif


//释放－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－
#define release(id) if(id){[id release]; id=nil;}

//如果是null 就改成 @""
#define NULL_TO_NIL(object) (object?([object isKindOfClass:[NSNull class]] ? (@"") : (object)):@"")
 
 
//-------------------------------------------日志打印-------------------------------------------------
#ifdef DEBUG
#       define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#       define DLog(...)
#endif

// app delegate ref --------------------------------------------------------------------------------------
#define AppDelegate_Ref ((PassportAppDelegate *)[[UIApplication sharedApplication] delegate])


#endif
