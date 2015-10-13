//
//  MLTransition.h
//  MLTransition
//
//  Created by molon on 7/8/14.
//  Copyright (c) 2014 molon. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    MLTransitionGestureRecognizerTypePan, //拖动模式
	MLTransitionGestureRecognizerTypeScreenEdgePan, //边界拖动模式
} MLTransitionGestureRecognizerType;

@interface MLTransition : NSObject

+ (void)validatePanPackWithMLTransitionGestureRecognizerType:(MLTransitionGestureRecognizerType)type;

@end

@interface UIView(__MLTransition)

//使得此view不响应拖返
@property (nonatomic, assign) BOOL disableMLTransition;

@end

@interface UINavigationController(DisableMLTransition)

- (void)enabledMLTransition:(BOOL)enabled;

@end


//导航右滑返回
//    [MLTransition validatePanPackWithMLTransitionGestureRecognizerType:MLTransitionGestureRecognizerTypePan];


//简单搞下导航栏颜色
//[self setNavBarColor];

//- (void)setNavBarColor{
//    UIColor *navBarColor = [UIColor colorWithRed:0.063 green:0.263 blue:0.455 alpha:1.000];
//    UIColor *navBarTintColor = [UIColor whiteColor];
//    //导航栏
//    [[UINavigationBar appearance]setBarTintColor:navBarColor];
//    
//    [[UINavigationBar appearance]setTintColor:navBarTintColor];
//    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
//    attributes[NSFontAttributeName] = [UIFont boldSystemFontOfSize:18.0f];
//    attributes[NSForegroundColorAttributeName] = navBarTintColor;
//    NSShadow *shadow = [NSShadow new];
//    shadow.shadowColor = [UIColor clearColor];
//    attributes[NSShadowAttributeName] = shadow;
//    [[UINavigationBar appearance] setTitleTextAttributes:attributes];
//}