//
//  DividerView.m
//  BabyPictorial
//
//  Created by han chao on 13-3-29.
//  Copyright (c) 2013年 taoxiaoxian. All rights reserved.
//

#import "DividerView.h"

@implementation DividerView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
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
    self.titleLabel = nil;
    
    [super dealloc];
}

@end
