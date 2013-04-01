//
//  PicDetailTaokeMsgView.m
//  BabyPictorial
//
//  Created by han chao on 13-3-30.
//  Copyright (c) 2013年 taoxiaoxian. All rights reserved.
//

#import "PicDetailTaokeMsgView.h"

#import <QuartzCore/QuartzCore.h>

@implementation PicDetailTaokeMsgView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)awakeFromNib
{
    self.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin
    | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin
    | UIViewAutoresizingFlexibleBottomMargin;
    
    self.layer.shadowOffset = CGSizeMake(0.5, 0.5);
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOpacity = 0.3;
    
    // mArticleListTileView.layer.shouldRasterize = YES;
    
    // shadow
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    CGPoint topLeft      = self.bounds.origin;
    CGPoint bottomLeft   = CGPointMake(0.0, CGRectGetHeight(self.bounds));
    CGPoint bottomRight  = CGPointMake(CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
    CGPoint topRight     = CGPointMake(CGRectGetWidth(self.bounds), 0.0);
    
    [path moveToPoint:topLeft];
    [path addLineToPoint:bottomLeft];
    [path addLineToPoint:bottomRight];
    [path addLineToPoint:topRight];
    [path addLineToPoint:topLeft];
    [path closePath];
    
    self.layer.shadowPath = path.CGPath;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(void)dealloc
{
    self.buyBtn = nil;
    self.title = nil;
    self.price = nil;
    
    
    [super dealloc];
}

@end
