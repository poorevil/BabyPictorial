//
//  UILabelStrikeThrough.m
//  DiscountCid30
//
//  Created by han chao on 12-10-16.
//  Copyright (c) 2012年 han chao. All rights reserved.
//

#import "UILabelStrikeThrough.h"

@implementation UILabelStrikeThrough

@synthesize isWithStrikeThrough;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
//    if (isWithStrikeThrough)
//    {
        CGContextRef c = UIGraphicsGetCurrentContext();
        
        CGFloat black[4] = {0.0f, 0.0f, 0.0f, 0.7f};
        CGContextSetStrokeColor(c, black);
        CGContextSetLineWidth(c, 1);
        CGContextBeginPath(c);
        CGFloat halfWayUp = (self.bounds.size.height - self.bounds.origin.y) / 1.8;
        CGContextMoveToPoint(c, self.bounds.origin.x, halfWayUp );
        CGContextAddLineToPoint(c, self.bounds.origin.x + self.bounds.size.width, halfWayUp);
        CGContextStrokePath(c);
//    }
    
    [super drawRect:rect];
}


@end
