
#import "SlightLabel.h"

@implementation SlightLabel
@synthesize slightColor;
@synthesize slightWidth;


- (id)init{
    self = [super init];
    if (self) {
        self.slightColor = [UIColor whiteColor];
        self.slightWidth = 1.0f;
    }
    return self;
}

#pragma mark -
#pragma mark Drawing

- (void)drawTextInRect:(CGRect)rect {
    
    CGSize shadowOffset = self.shadowOffset;
    UIColor *textColor = self.textColor;
    
    CGContextRef c = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(c, self.slightWidth);
    CGContextSetLineJoin(c, kCGLineJoinRound);
    
    CGContextSetTextDrawingMode(c, kCGTextStroke);
    self.textColor = self.slightColor;
    [super drawTextInRect:rect];
    
    CGContextSetTextDrawingMode(c, kCGTextFill);
    self.textColor = textColor;
    self.shadowOffset = CGSizeMake(0, 0);
    [super drawTextInRect:rect];
    
    self.shadowOffset = shadowOffset;
}

@end
