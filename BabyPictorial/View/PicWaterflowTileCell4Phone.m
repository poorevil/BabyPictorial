//
//  PicWaterflowTileCell4Phone.m
//  BabyPictorial
//
//  Created by han chao on 13-6-3.
//  Copyright (c) 2013年 taoxiaoxian. All rights reserved.
//

#import "PicWaterflowTileCell4Phone.h"

#import "PicDetailModel.h"

#import "PicDetailViewController4Phone.h"

#import "AppDelegate.h"

@implementation PicWaterflowTileCell4Phone

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)dealloc
{
    self.imageView = nil;
    self.titleLabel = nil;
    
    self.pdm = nil;
    
    [super dealloc];
}

-(void)setPdm:(PicDetailModel *)pdm
{
    [_pdm release];
    _pdm = nil;
    
    _pdm = [pdm retain];
    
    self.pdm.descTitle = [self.pdm.descTitle
                          stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    self.imageView.imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@_150x10000.jpg",pdm.picUrl]];
    self.imageView.clipsToBounds = YES;
    self.imageView.frame = CGRectMake(5
                                      , 5
                                      , self.imageView.frame.size.width
                                      , 140);//, pdm.height);
    
    //点击事件
    UITapGestureRecognizer *singleTap =[[UITapGestureRecognizer alloc]initWithTarget:self
                                                                              action:@selector(onTileTaped:)];
    self.userInteractionEnabled = YES;
    [self addGestureRecognizer:singleTap];
    [singleTap release];
    
//    //根据label文字内容计算UILabel高度
//    //Calculate the expected size based on the font and linebreak mode of your label
//    CGSize maximumLabelSize = CGSizeMake(self.frame.size.width,1000);
//    
//    CGSize expectedLabelSize = [pdm.descTitle sizeWithFont:self.titleLabel.font
//                                         constrainedToSize:maximumLabelSize
//                                             lineBreakMode:self.titleLabel.lineBreakMode];
//    
//    //adjust the label the the new height.
//    CGRect titleFrame = self.titleLabel.frame;
//    titleFrame.size.height = expectedLabelSize.height;
//    titleFrame.origin.y = self.imageView.frame.origin.y + self.imageView.frame.size.height + 5;
//    
//    self.titleLabel.frame = titleFrame;
    
    self.titleLabel.text = pdm.descTitle;
    
//    self.frame = CGRectMake(0
//                            , 0
//                            , self.frame.size.width
//                            , self.titleLabel.frame.origin.y + self.titleLabel.frame.size.height + 5);
    
}

#pragma mark - tap action
-(void)onTileTaped:(UIGestureRecognizer *)gesture
{
    PicDetailViewController4Phone *col = [[PicDetailViewController4Phone alloc]
                                          initWithNibName:@"PicDetailViewController4Phone"
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
