//
//  PicDetailViewController.m
//  BabyPictorial
//
//  Created by han chao on 13-3-21.
//  Copyright (c) 2013年 taoxiaoxian. All rights reserved.
//

#import "PicDetailViewController.h"
#import <QuartzCore/QuartzCore.h>

#import "PicDetailInterface.h"    
#import "EGOImageView.h"

#import "PicDetailModel.h"
#import "AlbumModel.h"

#import "AlbumView.h"

#import "RecommendAlbumView.h"

#import "DividerView.h"

@interface PicDetailViewController ()

@property (nonatomic,retain) PicDetailInterface *interface;

@end

@implementation PicDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.gif"]];
    
    self.interface = [[[PicDetailInterface alloc] init] autorelease];
    self.interface.delegate = self;
    [self.interface getPicDetailByPid:self.pid];
    
    //返回首页
    UIBarButtonItem *homeBtn = [[UIBarButtonItem alloc]
                                   initWithTitle:@"首页"
                                   style:UIBarButtonItemStyleBordered
                                   target:self
                                   action:@selector(homeAction)];
    self.navigationItem.rightBarButtonItem = homeBtn;
    [homeBtn release];
    
    self.navigationItem.title = self.title;
    
    self.mScrollView.contentSize = self.view.frame.size;
    
    
    self.picContainer.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"img_bg_2.png"]];
    
    
    self.detailContainer.layer.borderColor = [UIColor colorWithWhite:1 alpha:0.85].CGColor;
    self.detailContainer.layer.borderWidth = 1;
    self.rightContainer.layer.borderColor = [UIColor colorWithWhite:1 alpha:0.85].CGColor;
    self.rightContainer.layer.borderWidth = 1;
    
    
    EGOImageView *tmpImg = [[[EGOImageView alloc] init] autorelease];
    tmpImg.imageURL = self.smallPicUrl;
    
    self.smallPicUrl = nil;
    
    self.imageView.placeholderImage = tmpImg.image;
    self.imageView.imageURL = nil;
    
    [self imageViewLoadedImage:self.imageView];
    
}

-(void)setShadow
{
    //self.picContainer.superview 阴影
    self.picContainer.superview.layer.shadowColor = [UIColor blackColor].CGColor;
    self.picContainer.superview.layer.shadowOpacity = 0.2;
    
    // shadow
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    CGPoint topLeft      = CGPointMake(0.0, 6.0);
    CGPoint bottomLeft   = CGPointMake(0.0, CGRectGetHeight(self.picContainer.superview.bounds)+3);
    CGPoint bottomRight  = CGPointMake(CGRectGetWidth(self.picContainer.superview.bounds)+2, CGRectGetHeight(self.picContainer.superview.bounds)+3);
    CGPoint topRight     = CGPointMake(CGRectGetWidth(self.picContainer.superview.bounds)+2, 3.0);
    
    [path moveToPoint:topLeft];
    [path addLineToPoint:bottomLeft];
    [path addLineToPoint:bottomRight];
    [path addLineToPoint:topRight];
    [path addLineToPoint:topLeft];
    [path closePath];
    
    self.picContainer.superview.layer.shadowPath = path.CGPath;
    
    //self.detailContainer 阴影
    self.detailContainer.layer.shadowColor = [UIColor blackColor].CGColor;
    self.detailContainer.layer.shadowOpacity = 0.2;
    
    // shadow
    path = [UIBezierPath bezierPath];
    
    topLeft      = CGPointMake(0.0, 6.0);
    bottomLeft   = CGPointMake(0.0, CGRectGetHeight(self.detailContainer.bounds)+6);
    bottomRight  = CGPointMake(CGRectGetWidth(self.detailContainer.bounds)+2
                               , CGRectGetHeight(self.detailContainer.bounds)+6);
    topRight     = CGPointMake(CGRectGetWidth(self.detailContainer.bounds)+2, 3.0);
    
    [path moveToPoint:topLeft];
    [path addLineToPoint:bottomLeft];
    [path addLineToPoint:bottomRight];
    [path addLineToPoint:topRight];
    [path addLineToPoint:topLeft];
    [path closePath];
    
    self.detailContainer.layer.shadowPath = path.CGPath;
}

//更新scrollview高度
-(void)updateScrollViewContentSize
{
    CGRect detailFrame = self.detailContainer.frame;
    CGRect rightContainerFrame = self.rightContainer.frame;
    
    self.mScrollView.contentSize = CGSizeMake(self.view.frame.size.width
                                              , MAX(detailFrame.size.height, rightContainerFrame.size.height)
                                              + 40 + 20);
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    self.title = nil;
    
    self.pid = nil;
    
    self.detailContainer = nil;
    self.picContainer = nil;
    
    self.interface.delegate = nil;
    self.interface = nil;
    
    self.imageView = nil;
    self.descriptionLabel = nil;
    
    self.mScrollView = nil;
    
    self.rightContainer = nil;
    
    self.smallPicUrl = nil;
    
    [super dealloc];
}

#pragma mark - PicDetailInterfaceDelegate

-(void)getPicDetailDidFinished:(PicDetailModel *)pdm
{
    self.imageView.delegate = self;
    self.imageView.imageURL = [NSURL URLWithString:pdm.picUrl];
    
    
    self.descriptionLabel.text = pdm.descTitle;
    
    
    AlbumView *albumView = [[[NSBundle mainBundle] loadNibNamed:@"AlbumView"
                                                          owner:self
                                                        options:nil] objectAtIndex:0];
    
    albumView.frame = CGRectMake( 2
                                 , 0
                                 , albumView.frame.size.width
                                 , albumView.frame.size.height);
    
    albumView.albumModel = pdm.ownerAlbum;
    
    [self.detailContainer addSubview:albumView];
    
    //分割线
    DividerView *dv = [[[NSBundle mainBundle] loadNibNamed:@"DividerView"
                                                     owner:self
                                                   options:nil] objectAtIndex:0];
    
    CGRect frame = dv.frame;
    
    frame.origin.y = [[self.detailContainer.subviews lastObject] frame].origin.y
    +[[self.detailContainer.subviews lastObject] frame].size.height+20;
    
    dv.frame = frame;
    
    [self.detailContainer addSubview:dv];
    
    //推荐图集
    for (AlbumModel *am in pdm.recommendAlbumArray) {
        
        RecommendAlbumView *rav = [[[NSBundle mainBundle] loadNibNamed:@"RecommendAlbumView"
                                                                 owner:self
                                                               options:nil] objectAtIndex:0];
        
        CGRect frame = rav.frame;
        
        frame.origin.y = [[self.detailContainer.subviews lastObject] frame].origin.y
        +[[self.detailContainer.subviews lastObject] frame].size.height;
        
        rav.frame = frame;
        
        rav.albumModel = am;
        
        [self.detailContainer addSubview:rav];
        
        CGRect dcFrame = self.detailContainer.frame;
        dcFrame.size.height = (rav.frame.origin.y+rav.frame.size.height);
        
        self.detailContainer.frame = dcFrame;
        
        self.mScrollView.contentSize = CGSizeMake(self.view.frame.size.width
                                                  , self.detailContainer.frame.origin.y+self.detailContainer.frame.size.height+10);
        
        
    }
    
    [self setShadow];
    
    [self updateScrollViewContentSize];
    
}

-(void)getPicDetailDidFailed:(NSString *)errorMsg
{
    NSLog(@"=======%@",errorMsg);
}


#pragma mark -homeAction
-(void)homeAction
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - EGOImageViewDelegate
- (void)imageViewLoadedImage:(EGOImageView*)imageView
{
    UIView *parentView = imageView.superview;
    
    CGRect imageFrame = imageView.frame;
    imageFrame.size.height = imageFrame.size.width / imageView.image.size.width  * imageView.image.size.height;
    
    
    CGRect parentFrame = parentView.frame;
    parentFrame.size.height += (imageFrame.size.height - imageView.frame.size.height);
    parentView.frame = parentFrame;
    
    imageView.frame = imageFrame;
    
    CGRect frame = parentView.superview.frame;
    frame.size.height = parentView.frame.size.height + parentView.frame.origin.y;
    parentView.superview.frame = frame;
    
    [self setShadow];
    
    [self updateScrollViewContentSize];
}

@end
