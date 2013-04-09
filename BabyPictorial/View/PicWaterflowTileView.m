//
//  PicWaterflowTileView.m
//  BabyPictorial
//
//  Created by han chao on 13-3-26.
//  Copyright (c) 2013年 taoxiaoxian. All rights reserved.
//

#import "PicWaterflowTileView.h"

#import "PicDetailModel.h"
#import "EGOImageView.h"

#import "AppDelegate.h"
#import "PicDetailViewController.h"
#import "AlbumModel.h"

@implementation PicWaterflowTileView

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

-(void)setPdm:(PicDetailModel *)pdm
{
    [_pdm release];
    _pdm = nil;
    
    _pdm = [pdm retain];
    
    self.pdm.descTitle = [self.pdm.descTitle stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    self.imageView.imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@_220x10000.jpg",pdm.picUrl]];
    self.imageView.clipsToBounds = YES;
    self.imageView.frame = CGRectMake(5
                                      , 5
                                      , self.imageView.frame.size.width
                                      , pdm.height);
    
    //点击事件
    UITapGestureRecognizer *singleTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onTileTaped:)];
    self.userInteractionEnabled = YES;
    [self addGestureRecognizer:singleTap];
    [singleTap release];
    
    //根据label文字内容计算UILabel高度
    //Calculate the expected size based on the font and linebreak mode of your label
    CGSize maximumLabelSize = CGSizeMake(self.frame.size.width,1000);
    
    CGSize expectedLabelSize = [pdm.descTitle sizeWithFont:self.titleLabel.font
                                               constrainedToSize:maximumLabelSize
                                                   lineBreakMode:self.titleLabel.lineBreakMode];
    
    //adjust the label the the new height.
    CGRect titleFrame = self.titleLabel.frame;
    titleFrame.size.height = expectedLabelSize.height;
    titleFrame.origin.y = self.imageView.frame.origin.y + self.imageView.frame.size.height + 5;
    
    self.titleLabel.frame = titleFrame;
    
    self.titleLabel.text = pdm.descTitle;
    
    self.frame = CGRectMake(0
                            , 0
                            , self.frame.size.width
                            , self.titleLabel.frame.origin.y + self.titleLabel.frame.size.height + 5);
}

-(void)releaseImage{//释放所有子view的图片
    
    [self.imageView cancelImageLoad];
    self.imageView.image = nil;
}

-(void)reloadImage{//重载所有子view的图片
    
    [self.imageView setImageURL:[NSURL URLWithString:[NSString
                                                      stringWithFormat:@"%@_220x10000.jpg" ,self.pdm.picUrl]]];
    
}

-(void)dealloc
{
    self.titleLabel = nil;
    self.imageView = nil;
    self.pdm = nil;
    
    [super dealloc];
}

#pragma mark - tap action
-(void)onTileTaped:(UIGestureRecognizer *)gesture
{
    PicDetailViewController *col = [[PicDetailViewController alloc] initWithNibName:@"PicDetailViewController"
                                                                             bundle:nil];
    
    col.navTitle = self.pdm.albumName;
    col.pid = self.pdm.pid;
    col.smallPicUrl = self.imageView.imageURL;
    col.picDescTitle = self.pdm.descTitle;
    
    AppDelegate *mainDelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    [mainDelegate.navController pushViewController:col animated:YES];
    [col release];
}

@end
