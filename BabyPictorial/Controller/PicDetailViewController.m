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
    
    self.interface = [[[PicDetailInterface alloc] init] autorelease];
    self.interface.delegate = self;
    [self.interface getPicDetailByPid:self.pid];
    
    
    
    
    
    
    self.picContainer.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"img_bg_2.png"]];
    
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
    bottomLeft   = CGPointMake(0.0, CGRectGetHeight(self.detailContainer.bounds)+3);
    bottomRight  = CGPointMake(CGRectGetWidth(self.detailContainer.bounds)+2
                               , CGRectGetHeight(self.detailContainer.bounds)+3);
    topRight     = CGPointMake(CGRectGetWidth(self.detailContainer.bounds)+2, 3.0);
    
    [path moveToPoint:topLeft];
    [path addLineToPoint:bottomLeft];
    [path addLineToPoint:bottomRight];
    [path addLineToPoint:topRight];
    [path addLineToPoint:topLeft];
    [path closePath];
    
    self.detailContainer.layer.shadowPath = path.CGPath;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    self.pid = nil;
    
    self.detailContainer = nil;
    self.picContainer = nil;
    
    self.interface.delegate = nil;
    self.interface = nil;
    
    self.imageView = nil;
    self.descriptionLabel = nil;
    
    self.ownerAlbumView = nil;
    
    [super dealloc];
}

#pragma mark - PicDetailInterfaceDelegate

-(void)getPicDetailDidFinished:(PicDetailModel *)pdm
{
    self.imageView.imageURL = [NSURL URLWithString:pdm.picUrl];
    
    self.descriptionLabel.text = pdm.description;
    
    
    AlbumView *albumView = [[[NSBundle mainBundle] loadNibNamed:@"AlbumView"
                                                          owner:self
                                                        options:nil] objectAtIndex:0];
    
    albumView.frame = CGRectMake( 2
                                 , 0
                                 , albumView.frame.size.width
                                 , albumView.frame.size.height);
    
    [albumView setImageUrls:pdm.ownerAlbum.picArray];
    [albumView.titleLabel setText:pdm.ownerAlbum.albumName];
    
    [self.ownerAlbumView addSubview:albumView];
}

-(void)getPicDetailDidFailed:(NSString *)errorMsg
{
    NSLog(@"=======%@",errorMsg);
}


@end
