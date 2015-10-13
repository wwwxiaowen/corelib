//
//  MJPhotoProgressView.m
//
//  Created by mj on 13-3-4.
//  Copyright (c) 2013年 itcast. All rights reserved.
//

#import "MJPhotoProgressView.h"

#define kDegreeToRadian(x) (M_PI/180.0 * (x))

@implementation MJPhotoProgressView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{    
//    CGPoint centerPoint = CGPointMake(rect.size.height / 2, rect.size.width / 2);
//    CGFloat radius = MIN(rect.size.height, rect.size.width) / 2;
//    
//    CGFloat pathWidth = radius * 0.3f;
//    
//    CGFloat radians = kDegreeToRadian((_progress*359.9)-90);
//    CGFloat xOffset = radius*(1 + 0.85*cosf(radians));
//    CGFloat yOffset = radius*(1 + 0.85*sinf(radians));
//    CGPoint endPoint = CGPointMake(xOffset, yOffset);
//    
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    
//    [self.trackTintColor setFill];
//    CGMutablePathRef trackPath = CGPathCreateMutable();
//    CGPathMoveToPoint(trackPath, NULL, centerPoint.x, centerPoint.y);
//    CGPathAddArc(trackPath, NULL, centerPoint.x, centerPoint.y, radius, kDegreeToRadian(270), kDegreeToRadian(-90), NO);
//    CGPathCloseSubpath(trackPath);
//    CGContextAddPath(context, trackPath);
//    CGContextFillPath(context);
//    CGPathRelease(trackPath);
//    
//    [self.progressTintColor setFill];
//    CGMutablePathRef progressPath = CGPathCreateMutable();
//    CGPathMoveToPoint(progressPath, NULL, centerPoint.x, centerPoint.y);
//    CGPathAddArc(progressPath, NULL, centerPoint.x, centerPoint.y, radius, kDegreeToRadian(270), radians, NO);
//    CGPathCloseSubpath(progressPath);
//    CGContextAddPath(context, progressPath);
//    CGContextFillPath(context);
//    CGPathRelease(progressPath);
//    
//    CGContextAddEllipseInRect(context, CGRectMake(centerPoint.x - pathWidth/2, 0, pathWidth, pathWidth));
//    CGContextFillPath(context);
//    
//    CGContextAddEllipseInRect(context, CGRectMake(endPoint.x - pathWidth/2, endPoint.y - pathWidth/2, pathWidth, pathWidth));
//    CGContextFillPath(context);
//    
//    CGContextSetBlendMode(context, kCGBlendModeClear);;
//    CGFloat innerRadius = radius * 0.7;
//	CGPoint newCenterPoint = CGPointMake(centerPoint.x - innerRadius, centerPoint.y - innerRadius);    
//	CGContextAddEllipseInRect(context, CGRectMake(newCenterPoint.x, newCenterPoint.y, innerRadius*2, innerRadius*2));
//	CGContextFillPath(context);
    
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGFloat lineWidth = 5.f;
    UIBezierPath *processBackgroundPath = [UIBezierPath bezierPath];
    processBackgroundPath.lineWidth = lineWidth;
    processBackgroundPath.lineCapStyle = kCGLineCapRound;
    CGPoint center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    CGFloat radius = (self.bounds.size.width - lineWidth)/2;
    CGFloat startAngle = - ((float)M_PI / 2);
    CGFloat endAngle = (2 * (float)M_PI) + startAngle;
    [processBackgroundPath addArcWithCenter:center radius:radius startAngle:startAngle endAngle:endAngle clockwise:YES];
    [[UIColor grayColor] set];
    [processBackgroundPath stroke];
    
    UIBezierPath *processPath = [UIBezierPath bezierPath];
    processPath.lineCapStyle = kCGLineCapRound;
    processPath.lineWidth = lineWidth;
    endAngle = (self.progress * 2 * (float)M_PI) + startAngle;
    [processPath addArcWithCenter:center radius:radius startAngle:startAngle endAngle:endAngle clockwise:YES];
    [[UIColor whiteColor] set];
    [processPath stroke];
    
    
    
    CGRect allRect = self.bounds;
    
    UIFont *font = [UIFont systemFontOfSize:10];
    NSString *text = [NSString stringWithFormat:@"%i%%", (int)(self.progress * 100.0f)];
    
    CGSize textSize = [text sizeWithFont:font constrainedToSize:CGSizeMake(30000, 13)];
    
    float x = floorf(allRect.size.width / 2) + 3 + CGPointZero.x;
    float y = floorf(allRect.size.height / 2) - 6 + CGPointZero.y;
    
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    [text drawAtPoint:CGPointMake(x - textSize.width / 2.0, y) withFont:font];

}


#pragma mark - Property Methods

- (UIColor *)trackTintColor
{
    if (!_trackTintColor)
    {
        _trackTintColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.7f];
    }
    return _trackTintColor;
}

- (UIColor *)progressTintColor
{
    if (!_progressTintColor)
    {
        _progressTintColor = [UIColor whiteColor];
    }
    return _progressTintColor;
}

- (void)setProgress:(float)progress
{
    _progress = progress;
    [self setNeedsDisplay];
}

@end
