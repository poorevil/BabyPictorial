//
//  AlbumView.m
//  BabyPictorial
//
//  Created by han chao on 13-3-20.
//  Copyright (c) 2013年 taoxiaoxian. All rights reserved.
//

#import "AlbumView.h"
#import "EGOImageView.h"
#import "PicDetailModel.h"

#import "PicDetailViewController.h"

#import "AppDelegate.h"

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
    self.urlArray = urlArray;
    
    for (NSInteger idx = 0 ; idx < urlArray.count ; idx++) {
        PicDetailModel *pdm = [urlArray objectAtIndex:idx];
        
        NSString *url = [NSString stringWithFormat:@"%@_100x100.jpg",pdm.picUrl];
        
        CGRect frame = CGRectMake(idx%3 * 100, idx>2?100:0, 98, 98);
        
        EGOImageView *image = [[[EGOImageView alloc] initWithFrame:frame] autorelease];
        image.contentMode = UIViewContentModeScaleAspectFit;
        image.clipsToBounds = YES;
        image.tag = idx;
        
        image.imageURL = [NSURL URLWithString:url];
        
        [self.imageContener addSubview:image];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        image.userInteractionEnabled = YES;
        [image addGestureRecognizer:tap];
        [tap release];
    }
}

-(void)dealloc
{
    
    self.urlArray = nil;
    self.titleLabel = nil;
    self.imageContener = nil;
    
    [super dealloc];
}

-(void)tapAction:(UITapGestureRecognizer *)gesture
{
    NSInteger idx = gesture.view.tag;
    
    PicDetailViewController *col = [[PicDetailViewController alloc] initWithNibName:@"PicDetailViewController"
                                                                             bundle:nil];
    
    col.pid = [[self.urlArray objectAtIndex:idx] pid];
    
    AppDelegate *mainDelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    [mainDelegate.navController pushViewController:col animated:YES];
    [col release];
}

@end
