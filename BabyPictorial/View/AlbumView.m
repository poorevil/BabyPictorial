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

#import "AlbumModel.h"

#import "WaterflowViewController.h"

#import <QuartzCore/QuartzCore.h>

@implementation AlbumView

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
    self.layer.borderColor = [UIColor colorWithWhite:1 alpha:0.7 ].CGColor;
    self.layer.borderWidth = 1;
}

-(void)setAlbumModel:(AlbumModel *)albumModel
{
    [_albumModel release];
    _albumModel = nil;
    
    _albumModel = [albumModel retain];
    
    self.titleLabel.text = [self.albumModel.albumName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(albumTapAction:)];
    
    self.titleLabel.userInteractionEnabled = YES;
    [self.titleLabel addGestureRecognizer:tap];
    
    [tap release];
    
    [self setImageUrls:self.albumModel.picArray];
}

-(void)setImageUrls:(NSArray *)urlArray
{
    
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

-(void)releaseSubViewsImage{//释放所有子view的图片
    
    for (UIView *view in [self.imageContener subviews]) {
        
        if ([view isMemberOfClass:[EGOImageView class]]) {
            EGOImageView *imageView = (EGOImageView *)view;
            
            [imageView cancelImageLoad];
            imageView.image = nil;
        }
    }
}

-(void)reloadSubViewsImage{//重载所有子view的图片
    
    for (UIView *view in [self.imageContener subviews]) {
        
        if ([view isMemberOfClass:[EGOImageView class]]) {
            EGOImageView *imageView = (EGOImageView *)view;
            
            PicDetailModel *pdm = [self.albumModel.picArray objectAtIndex:view.tag];
            
            NSString *url = [NSString stringWithFormat:@"%@_100x100.jpg",pdm.picUrl];
            
            imageView.imageURL = [NSURL URLWithString:url];
        }
    }
    
}

-(void)dealloc
{
    
//    self.urlArray = nil;
    self.albumModel = nil;
    self.titleLabel = nil;
    self.imageContener = nil;
    
    [super dealloc];
}

-(void)tapAction:(UITapGestureRecognizer *)gesture
{
    NSInteger idx = gesture.view.tag;
    
    PicDetailViewController *col = [[PicDetailViewController alloc] initWithNibName:@"PicDetailViewController"
                                                                             bundle:nil];
    
    col.title = self.albumModel.albumName;
    col.pid = [[self.albumModel.picArray objectAtIndex:idx] pid];
    col.smallPicUrl = ((EGOImageView *)gesture.view).imageURL;
    
    
    AppDelegate *mainDelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    [mainDelegate.navController pushViewController:col animated:YES];
    [col release];
}

-(void)albumTapAction:(UITapGestureRecognizer *)gesture
{
    WaterflowViewController *col = [[WaterflowViewController alloc] initWithNibName:@"WaterflowViewController"
//                                                                            albumId:self.albumModel.albumId
                                                                             bundle:nil];
    col.albumId = self.albumModel.albumId;
    col.albumName = self.albumModel.albumName;
    
    AppDelegate *mainDelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    [mainDelegate.navController pushViewController:col animated:YES];
    [col release];
    
}

@end
