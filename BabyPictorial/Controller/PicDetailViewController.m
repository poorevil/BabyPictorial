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

#import "PicDetailTaokeMsgView.h"

#import "TaokeItemDetailInterface.h"

#import "MobClick.h"

#import "SVWebViewController.h"

#import "MBProgressHUD.h"

@interface PicDetailViewController ()

@property (nonatomic,retain) PicDetailInterface *interface;

@property (nonatomic,retain) TaokeItemDetailInterface *taokeItemDetailInterface;

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

+ (UIBarButtonItem *)createSquareBarButtonItemWithTitle:(NSString *)t
                                                 target:(id)tgt
                                                 action:(SEL)a
                                              bgImgName:(NSString *)bgImgName
                                       pressedBgImgName:(NSString *)pressedBgImgName
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    // Since the buttons can be any width we use a thin image with a stretchable center point
    UIImage *buttonImage = [[UIImage imageNamed:bgImgName] stretchableImageWithLeftCapWidth:13 topCapHeight:0];
    UIImage *buttonPressedImage = [[UIImage imageNamed:pressedBgImgName] stretchableImageWithLeftCapWidth:13 topCapHeight:0];
    
    [[button titleLabel] setFont:[UIFont boldSystemFontOfSize:12.0]];
    [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [button setTitleShadowColor:[UIColor colorWithWhite:1.0 alpha:0.7] forState:UIControlStateNormal];
    [button setTitleShadowColor:[UIColor clearColor] forState:UIControlStateHighlighted];
    [[button titleLabel] setShadowOffset:CGSizeMake(0.0, 1.0)];
    
    CGRect buttonFrame = [button frame];
    buttonFrame.size.width = [t sizeWithFont:[UIFont boldSystemFontOfSize:12.0]].width + 24.0;
    buttonFrame.size.height = buttonImage.size.height;
    [button setFrame:buttonFrame];
    
    [button setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [button setBackgroundImage:buttonPressedImage forState:UIControlStateHighlighted];
    
    [button setTitle:t forState:UIControlStateNormal];
    
    [button addTarget:tgt action:a forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    return [buttonItem autorelease];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.descriptionLabel.text = self.picDescTitle;
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.gif"]];
    
    self.interface = [[[PicDetailInterface alloc] init] autorelease];
    self.interface.delegate = self;
    [self.interface getPicDetailByPid:self.pid];
    
    
    NSString *parentTitle = nil;
    
    if (self.navigationController.viewControllers.count>1)
        parentTitle = [[[self.navigationController.viewControllers
                         objectAtIndex:self.navigationController.viewControllers.count-2] navigationItem] title];
    
    //返回
    UIBarButtonItem *backBtn = [PicDetailViewController createSquareBarButtonItemWithTitle:parentTitle==nil?@"宝贝画报HD":parentTitle
                                                                                    target:self
                                                                                    action:@selector(backAction)
                                                                                 bgImgName:@"back_btn_bg.png"
                                                                          pressedBgImgName:@"back_btn_pressed_bg.png"];
    self.navigationItem.leftBarButtonItem = backBtn;
    
    //返回首页
    UIBarButtonItem *homeBtn = [PicDetailViewController createSquareBarButtonItemWithTitle:@"宝贝画报HD"
                                                                                    target:self
                                                                                    action:@selector(homeAction)
                                                                                 bgImgName:@"home_btn_bg.png"
                                                                          pressedBgImgName:@"home_btn_pressed_bg.png"];
    self.navigationItem.rightBarButtonItem = homeBtn;
    
    
    self.navigationItem.title = self.navTitle;
    
    self.mScrollView.contentSize = self.view.frame.size;
    
    
    self.picContainer.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"img_bg_2.png"]];
    
    
    self.detailContainer.layer.borderColor = [UIColor colorWithWhite:1 alpha:0.85].CGColor;
    self.detailContainer.layer.borderWidth = 1;
    self.rightContainer.layer.borderColor = [UIColor colorWithWhite:1 alpha:0.85].CGColor;
    self.rightContainer.layer.borderWidth = 1;
    
    
    EGOImageView *tmpImg = [[[EGOImageView alloc] init] autorelease];
    tmpImg.imageURL = self.smallPicUrl;
    
//    self.smallPicUrl = nil;
    
    self.imageView.placeholderImage = tmpImg.image;
    self.imageView.imageURL = [NSURL URLWithString:[[self.smallPicUrl absoluteString]
                                                    stringByReplacingOccurrencesOfString:@"_100x100.jpg"
                                                                              withString:@""]];
    
    if (self.imageView.image)
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
    
    CGPoint bottomPoint = CGPointZero;
    
    for (UIView *view in self.mScrollView.subviews) {
        
        bottomPoint.y = MAX(bottomPoint.y, (view.frame.size.height + view.frame.origin.y));
    }
    
    self.mScrollView.contentSize = CGSizeMake(self.view.frame.size.width
                                              , bottomPoint.y + 20);
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    self.picDescTitle = nil;
    
    self.taokeItemDetailInterface.delegate = nil;
    self.taokeItemDetailInterface = nil;
    
    self.navTitle = nil;
    
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
    
    self.pdm = nil;
    
    [super dealloc];
}

#pragma mark - Gesture 
-(void)initGesture
{
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                                action:@selector(swipeGestureAction:)];
    
    self.rightContainer.userInteractionEnabled = YES;
    [self.rightContainer addGestureRecognizer:swipe];
    [swipe release];
    
    swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                                action:@selector(swipeGestureAction:)];
    
    swipe.direction = UISwipeGestureRecognizerDirectionLeft;
    self.rightContainer.userInteractionEnabled = YES;
    [self.rightContainer addGestureRecognizer:swipe];
    [swipe release];
}

-(void)swipeGestureAction:(UISwipeGestureRecognizer *)gesture
{
    NSInteger currentIdx = 0;//当前位置
    
    for (NSInteger idx = 0 ; idx < self.pdm.ownerAlbum.picArray.count; idx++) {
        
        PicDetailModel *pdmTmp = [self.pdm.ownerAlbum.picArray objectAtIndex:idx];
        if ([self.pdm.pid isEqualToString:pdmTmp.pid]) {
            currentIdx = idx;
        }
    }
    
    switch (gesture.direction) {
        case UISwipeGestureRecognizerDirectionLeft://向左
            
            if (currentIdx < self.pdm.ownerAlbum.picArray.count - 1) {
                
                PicDetailViewController *col = [[PicDetailViewController alloc] initWithNibName:@"PicDetailViewController"
                                                                                         bundle:nil];
                
                PicDetailModel *pdmTmp = [self.pdm.ownerAlbum.picArray objectAtIndex:currentIdx+1];
                
                col.picDescTitle = pdmTmp.descTitle;
                col.navTitle = self.pdm.ownerAlbum.albumName;
                col.pid = pdmTmp.pid;
                col.smallPicUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@_100x100.jpg",pdmTmp.picUrl]];
                
                [self.navigationController pushViewController:col animated:YES];
                [col release];
            }else{
                MBProgressHUD *hud = [[[MBProgressHUD alloc] initWithView:self.view] autorelease];
                hud.labelText = @"孩儿他妈，已经到最后一页啦！";
                
                hud.customView = [[[UIView alloc] init] autorelease];
                hud.mode = MBProgressHUDModeCustomView;
                
                [self.view addSubview:hud];
                [self.view bringSubviewToFront:hud];
                
                [hud show:NO];
                
                Boolean showFlag = YES;
                NSTimeInterval begin = [[NSDate date] timeIntervalSince1970];
                
                while (showFlag) {
                    
                    if ([[NSDate date] timeIntervalSince1970] - begin > 1.5) {
                        showFlag = NO;
                    }
                    
                    [[NSRunLoop currentRunLoop] runUntilDate:[NSDate distantPast]];
                }
                [hud hide:YES];
                
                [hud removeFromSuperview];
            }
            
            
            break;
        case UISwipeGestureRecognizerDirectionRight://向右
            
            if (currentIdx >0) {
                
                PicDetailViewController *col = [[PicDetailViewController alloc] initWithNibName:@"PicDetailViewController"
                                                                                         bundle:nil];
                
                PicDetailModel *pdmTmp = [self.pdm.ownerAlbum.picArray objectAtIndex:currentIdx-1];
                
                col.picDescTitle = pdmTmp.descTitle;
                col.navTitle = self.pdm.ownerAlbum.albumName;
                col.pid = pdmTmp.pid;
                col.smallPicUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@_100x100.jpg",pdmTmp.picUrl]];
                
                CATransition* transition = [CATransition animation];
                transition.duration = 0.3;
                transition.type = kCATransitionPush;
                transition.subtype = kCATransitionFromTop;
                
                [self.navigationController.view.layer
                 addAnimation:transition forKey:kCATransition];
                
                [self.navigationController pushViewController:col animated:NO];
                
                [col release];
            }else{
                MBProgressHUD *hud = [[[MBProgressHUD alloc] initWithView:self.view] autorelease];
                hud.labelText = @"孩儿他妈，已经是第一页啦！";
                
                hud.customView = [[[UIView alloc] init] autorelease];
                hud.mode = MBProgressHUDModeCustomView;
                
                [self.view addSubview:hud];
                [self.view bringSubviewToFront:hud];
                
                [hud show:NO];
                
                Boolean showFlag = YES;
                NSTimeInterval begin = [[NSDate date] timeIntervalSince1970];
                
                while (showFlag) {
                    
                    if ([[NSDate date] timeIntervalSince1970] - begin > 1.5) {
                        showFlag = NO;
                    }
                    
                    [[NSRunLoop currentRunLoop] runUntilDate:[NSDate distantPast]];
                }
                [hud hide:YES];
                
                [hud removeFromSuperview];
            }
            
            
            break;
            
        default:
            break;
    }
}


#pragma mark - PicDetailInterfaceDelegate

-(void)getPicDetailDidFinished:(PicDetailModel *)pdm
{
    self.imageView.delegate = self;
    self.imageView.imageURL = [NSURL URLWithString:pdm.picUrl];
    
    self.pdm = pdm;
    
    
    self.descriptionLabel.text = pdm.descTitle;
    
    
    AlbumView *albumView = [[[NSBundle mainBundle] loadNibNamed:@"AlbumView"
                                                          owner:self
                                                        options:nil] objectAtIndex:0];
    
    albumView.frame = CGRectMake( 2
                                 , 0
                                 , albumView.frame.size.width
                                 , albumView.frame.size.height);
    
    albumView.albumModel = pdm.ownerAlbum;
    [albumView setCurrentPicId:self.pdm.pid];
    
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
    
    
    self.taokeItemDetailInterface = [[[TaokeItemDetailInterface alloc] init] autorelease];
    self.taokeItemDetailInterface.delegate = self;
    [self.taokeItemDetailInterface getTaokeItemDetailsByNumiid:self.pdm.taokeNumiid];
    
    
    [self initGesture];
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

-(void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - EGOImageViewDelegate
- (void)imageViewLoadedImage:(EGOImageView*)imageView
{
    UIView *parentView = imageView.superview;
    
    CGRect imageFrame = imageView.frame;

    imageFrame.size.height = (CGFloat)imageFrame.size.width / (CGFloat)imageView.image.size.width  * imageView.image.size.height;
    
    
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

#pragma mark - TaokeItemDetailInterfaceDelegate
-(void)getTaokeItemDetailsByNumiidDidFinished:(NSString *)url
{
    self.pdm.taokeUrl = url;
    
    PicDetailTaokeMsgView *ptmv = [[[NSBundle mainBundle] loadNibNamed:@"PicDetailTaokeMsgView"
                                                                 owner:self
                                                               options:nil] objectAtIndex:0];
    
    CGRect ptmvFrame = ptmv.frame;
    ptmvFrame.origin.x = self.rightContainer.frame.origin.x;
    ptmvFrame.origin.y = self.rightContainer.frame.origin.y + self.rightContainer.frame.size.height + 10;
    
    
    ptmv.title.text = self.pdm.taokeTitle;
    ptmv.price.text = [NSString stringWithFormat:@"￥%@",self.pdm.taokePrice];
    
    [ptmv.buyBtn addTarget:self
                    action:@selector(buyBtnAction:)
          forControlEvents:UIControlEventTouchUpInside];
    
    
    ptmv.frame = ptmvFrame;
    
    [self.mScrollView addSubview:ptmv];
    
    [self updateScrollViewContentSize];
}

-(void)getTaokeItemDetailsByNumiidDidFailed
{
    NSLog(@"====getTaokeItemDetailsByNumiidDidFailed===");
}

-(void)buyBtnAction:(id)sender
{
    
    //友盟统计
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:self.pdm.pid,@"pid", nil];
    [MobClick event:@"buy_btn" attributes:dict];
    
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@&ttid=400000_21125417@txx_iPhone_0.0.0"
                                       , self.pdm.taokeUrl]];
    
    SVWebViewController *webViewController = [[[SVWebViewController alloc] initWithURL:URL
                                                                            thumbImage:nil
                                                                                 title:self.pdm.taokeTitle] autorelease];
    
    [self.navigationController pushViewController:webViewController animated:YES];
    
}

@end
