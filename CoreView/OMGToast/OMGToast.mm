//
//  OMGToast.m
//  Tencent
//
//  Created by MagicStudio on 12-3-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "OMGToast.h"  
#import <QuartzCore/QuartzCore.h>  

@interface OMGToast (OMGToastPrivate)  

- (id)initWithText:(NSString *)text_;  
- (void)setDuration:(CGFloat) duration_;  

- (void)dismisToast;  
- (void)toastTaped:(UIButton *)sender_;  

- (void)showAnimation;  
- (void)hideAnimation;  

- (void)show;  
- (void)showFromTopOffset:(CGFloat) topOffset_;  
- (void)showFromBottomOffset:(CGFloat) bottomOffset_;  

@end  


@implementation OMGToast  

- (void)dealloc{  
    [[NSNotificationCenter defaultCenter] removeObserver:self  
                                                    name:UIDeviceOrientationDidChangeNotification  
                                                  object:[UIDevice currentDevice]];  
    _contentView = nil;
    _text = nil;
}  


- (id)initWithText:(NSString *)text_{  
    if (self = [super init]) {  
        
        _text = [text_ copy];  
        
        UIFont *font = [UIFont boldSystemFontOfSize:14];  
        CGSize textSize = [_text sizeWithFont:font  
                           constrainedToSize:CGSizeMake(280, MAXFLOAT)  
                               lineBreakMode:NSLineBreakByWordWrapping];  
        
        UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, textSize.width + 12, textSize.height + 12)];  
        textLabel.backgroundColor = [UIColor clearColor];  
        textLabel.textColor = [UIColor whiteColor];  
        textLabel.textAlignment = NSTextAlignmentCenter;
        textLabel.font = font;  
        textLabel.text = _text;  
        textLabel.numberOfLines = 0;
        if ([[_text stringByReplacingOccurrencesOfString:@" " withString:@""] isEqualToString:@""])
        {
            textLabel.frame = CGRectMake(0, 0, 0, 0);
        }
        
        _contentView = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, textLabel.frame.size.width, textLabel.frame.size.height)];  
        _contentView.layer.cornerRadius = 5.0f;  
        _contentView.layer.borderWidth = 1.0f;  
        _contentView.layer.borderColor = [[UIColor grayColor] colorWithAlphaComponent:0.5].CGColor;  
        _contentView.backgroundColor = [UIColor colorWithRed:0.2f  
                                                      green:0.2f  
                                                       blue:0.2f  
                                                      alpha:0.75f];  
        [_contentView addSubview:textLabel];  
        _contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth;  
        [_contentView addTarget:self  
                        action:@selector(toastTaped:)  
              forControlEvents:UIControlEventTouchDown];  
        _contentView.alpha = 0.0f;  
       
        _duration = DEFAULT_DISPLAY_DURATION;  
        
        [[NSNotificationCenter defaultCenter] addObserver:self  
                                                 selector:@selector(deviceOrientationDidChanged:)  
                                                     name:UIDeviceOrientationDidChangeNotification  
                                                   object:[UIDevice currentDevice]];  
    }  
    return self;  
}  

- (void)deviceOrientationDidChanged:(NSNotification *)notify_{  
    [self hideAnimation];  
}  

-(void)dismissToast{  
    [_contentView removeFromSuperview];  
}  

-(void)toastTaped:(UIButton *)sender_{  
    [self hideAnimation];  
}  

- (void)setDuration:(CGFloat) duration_{  
    _duration = duration_;  
}  

-(void)showAnimation{  
    [UIView beginAnimations:@"show" context:NULL];  
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];  
    [UIView setAnimationDuration:0.3];  
    _contentView.alpha = 1.0f;  
    [UIView commitAnimations];  
}  

-(void)hideAnimation{  
    [UIView beginAnimations:@"hide" context:NULL];  
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];  
    [UIView setAnimationDelegate:self];  
    [UIView setAnimationDidStopSelector:@selector(dismissToast)];  
    [UIView setAnimationDuration:0.3];  
    _contentView.alpha = 0.0f;  
    [UIView commitAnimations];  
}  

- (void)show{  
    UIWindow *window = [UIApplication sharedApplication].keyWindow;  
    _contentView.center = window.center;  
    [window  addSubview:_contentView];  
    [self showAnimation];  
    [self performSelector:@selector(hideAnimation) withObject:nil afterDelay:_duration];  
}  

- (void)showFromTopOffset:(CGFloat) top_{  
    UIWindow *window = [UIApplication sharedApplication].keyWindow;  
    _contentView.center = CGPointMake(window.center.x, top_ + _contentView.frame.size.height/2);  
    [window  addSubview:_contentView];  
    [self showAnimation];  
    [self performSelector:@selector(hideAnimation) withObject:nil afterDelay:_duration];  
}  

- (void)showFromBottomOffset:(CGFloat) bottom_{  
    UIWindow *window = [UIApplication sharedApplication].keyWindow;      
    _contentView.center = CGPointMake(window.center.x, window.frame.size.height-(bottom_ + _contentView.frame.size.height/2));  
    [window  addSubview:_contentView];  
    [self showAnimation];  
    [self performSelector:@selector(hideAnimation) withObject:nil afterDelay:_duration];  
}  


+ (void)showWithText:(NSString *)text_{  
    [OMGToast showWithText:text_ duration:DEFAULT_DISPLAY_DURATION];  
}  

+ (void)showWithText:(NSString *)text_  
            duration:(CGFloat)duration_{  
    OMGToast *toast = [[OMGToast alloc] initWithText:text_];
    [toast setDuration:duration_];  
    [toast show];  
}  

+ (void)showWithText:(NSString *)text_  
           topOffset:(CGFloat)topOffset_{  
    [OMGToast showWithText:text_  topOffset:topOffset_ duration:DEFAULT_DISPLAY_DURATION];  
}  

+ (void)showWithText:(NSString *)text_  
           topOffset:(CGFloat)topOffset_  
            duration:(CGFloat)duration_{  
    OMGToast *toast = [[OMGToast alloc] initWithText:text_];
    [toast setDuration:duration_];  
    [toast showFromTopOffset:topOffset_];  
}  

+ (void)showWithText:(NSString *)text_  
        bottomOffset:(CGFloat)bottomOffset_{  
    [OMGToast showWithText:text_  bottomOffset:bottomOffset_ duration:DEFAULT_DISPLAY_DURATION];  
}  

+ (void)showWithText:(NSString *)text_  
        bottomOffset:(CGFloat)bottomOffset_  
            duration:(CGFloat)duration_{  
    OMGToast *toast = [[OMGToast alloc] initWithText:text_];  
    [toast setDuration:duration_];  
    [toast showFromBottomOffset:bottomOffset_];  
}  

@end  
