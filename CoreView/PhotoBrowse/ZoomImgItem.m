//
//  ZoomImgItem.m
//  ShowImgDome
//
//  Created by chuliangliang on 14-9-28.
//  Copyright (c) 2014年 aikaola. All rights reserved.
//

#import "ZoomImgItem.h"
@implementation ZoomImgItem
@synthesize zoomImageView;

- (void)dealloc {
    self.imgName = nil;
    if (zoomImageView) {
        [zoomImageView release];
        zoomImageView = nil;
    }
    [super dealloc];
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self _initView];
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}


- (void)_initView {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor clearColor];
    zoomImageView = [[KL_ImageZoomView alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:zoomImageView];
    [zoomImageView release];
    
    //单击
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                 action:@selector(TapsAction:)];
    [tapGesture setNumberOfTapsRequired:1];
    [self addGestureRecognizer:tapGesture];
}

- (void)setImgName:(NSString *)imgName {
    if (_imgName != imgName) {
        [_imgName release];
        _imgName = [imgName retain];
    }
    [zoomImageView resetViewFrame:CGRectMake(0, 0, self.size.width, self.size.height)];
    [zoomImageView uddateImageWithUrl:imgName];
}
- (void)TapsAction:(id)sender{
     [[NSNotificationCenter defaultCenter] postNotificationName:@"NNKEY_Browse_Photo_Sigle_Tap_Notification" object:nil];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
