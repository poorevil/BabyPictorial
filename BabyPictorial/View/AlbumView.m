//
//  AlbumView.m
//  BabyPictorial
//
//  Created by han chao on 13-3-20.
//  Copyright (c) 2013年 taoxiaoxian. All rights reserved.
//

#import "AlbumView.h"
#import "EGOImageView.h"

@implementation AlbumView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)setImageUrls:(NSArray *)urlArray
{
    for (NSInteger idx = 0 ; idx < urlArray.count ; idx++) {
        NSString *url = [urlArray objectAtIndex:idx];
        
        CGRect frame = CGRectMake(idx%3 * 100, idx>2?100:0, 98, 98);
        
        EGOImageView *image = [[[EGOImageView alloc] initWithFrame:frame] autorelease];
        image.contentMode = UIViewContentModeScaleAspectFit;
        image.clipsToBounds = YES;
        
        image.imageURL = [NSURL URLWithString:url];
        
        [self.imageContener addSubview:image];
    }
}

@end
