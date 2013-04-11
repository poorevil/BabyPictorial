//
//  RecommendAlbumView.m
//  BabyPictorial
//
//  Created by han chao on 13-3-28.
//  Copyright (c) 2013年 taoxiaoxian. All rights reserved.
//

#import "RecommendAlbumView.h"

#import "AlbumModel.h"

#import "PicDetailModel.h"

#import "EGOImageView.h"

#import "WaterflowViewController.h"
#import "AppDelegate.h"

#import "PicDetailViewController.h"

#import <QuartzCore/QuartzCore.h>

@implementation RecommendAlbumView

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

-(void)setAlbumModel:(AlbumModel *)albumModel
{
    [_albumModel release];
    _albumModel = nil;
    _albumModel = [albumModel retain];
    
    
    self.albumTitle.text = albumModel.albumName;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(albumTapAction:)];
    
    self.titlContainerView.userInteractionEnabled = YES;
    [self.titlContainerView addGestureRecognizer:tap];
    
    [tap release];
    
    for (NSInteger idx = 0;idx<albumModel.picArray.count;idx++) {
        
        if (idx == 3) {
            return;
        }
        
        PicDetailModel *pdm = [albumModel.picArray objectAtIndex:idx];
        
        EGOImageView *image = [[[EGOImageView alloc] init] autorelease];
        image.contentMode = UIViewContentModeScaleAspectFill;
        image.clipsToBounds = YES;
        image.tag = idx;
        
        image.layer.borderColor = [UIColor colorWithWhite:0.9 alpha:0.9].CGColor;
        image.layer.borderWidth = 1;
        
        image.imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@_100x100.jpg",pdm.picUrl]];
        image.frame = CGRectMake(idx%3 * 100, idx>2?100:0, 98, 98);
        
        [self.imageContainer addSubview:image];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        image.userInteractionEnabled = YES;
        [image addGestureRecognizer:tap];
        [tap release];
        
    }
    
    
}

-(void)dealloc
{
    self.albumModel = nil;
    self.imageContainer = nil;
    
    self.albumTitle = nil;
    
    self.titlContainerView = nil;
    
    
    [super dealloc];
}

-(void)tapAction:(UITapGestureRecognizer *)gesture
{
    NSInteger idx = gesture.view.tag;
    
    PicDetailViewController *col = [[PicDetailViewController alloc] initWithNibName:@"PicDetailViewController"
                                                                             bundle:nil];
    
    col.navTitle = self.albumModel.albumName;
    col.pid = [[self.albumModel.picArray objectAtIndex:idx] pid];
    col.smallPicUrl = ((EGOImageView *)gesture.view).imageURL;
    col.picDescTitle = [[self.albumModel.picArray objectAtIndex:idx] descTitle];

    AppDelegate *mainDelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];

    [mainDelegate.navController pushViewController:col animated:YES];

    [col release];

}

-(void)albumTapAction:(UITapGestureRecognizer *)gesture
{
    WaterflowViewController *col = [[WaterflowViewController alloc] initWithNibName:@"WaterflowViewController"
                                                                             bundle:nil];
    col.albumId = self.albumModel.albumId;
    col.albumName = self.albumModel.albumName;
    
    AppDelegate *mainDelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    [mainDelegate.navController pushViewController:col animated:YES];
    
    [col release];
    
}

@end
