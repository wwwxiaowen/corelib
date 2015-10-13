//
//  ShareView.h
//  LovePicture
//
//  Created by 温火光 on 15/7/9.
//  Copyright (c) 2015年 dexingrongtong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShareView : UIView <UIGestureRecognizerDelegate>
@property (nonatomic, strong)IBOutlet UIImageView *bgImg;
@property (nonatomic, strong)IBOutlet UIImageView *line;
@property (nonatomic, strong)IBOutlet UIView      *shareView; 
- (void)shareviewshow;
@end
