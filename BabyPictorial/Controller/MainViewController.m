//
//  MainViewController.m
//  BabyPictorial
//
//  Created by han chao on 13-3-19.
//  Copyright (c) 2013年 taoxiaoxian. All rights reserved.
//

#import "MainViewController.h"

#import "MainPageInterface.h"

#import "AlbumModel.h"

#import "AlbumView.h"
#import "PicDetailViewController.h"
#import "WaterflowViewController.h"

#import <QuartzCore/QuartzCore.h>

#import "JSAnimatedImagesView.h"

#import "CycleScrollView.h"

#import "EGOImageView.h"

#import "ADInterface.h"

#import "ADModel.h"

#import "MobClick.h"

#import "SVWebViewController.h"

@interface MainViewController (){
    NSInteger _pageNum ;
    Boolean _hasNext;
    Boolean _isLoading;
}

@property (nonatomic,retain) MainPageInterface *interface;

@property (nonatomic,retain) NSMutableArray *headerScrollViewArray;//轮播图数组

@property (nonatomic,retain) ADInterface *adInterface;//广告接口

@property (nonatomic,retain) NSArray *adArray;//广告列表

@property (nonatomic,retain) UIView *adTitleGroupView;
@property (nonatomic,retain) UILabel *adTitleLabel;

@end

@implementation MainViewController

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
    
    self.headerScrollViewArray = [NSMutableArray array];
    
    self.adTitleGroupView = [[[UIView alloc] initWithFrame:CGRectMake(0, 310, 1024, 50)] autorelease];
    self.adTitleGroupView.backgroundColor = [UIColor colorWithRed:0
                                                       green:0
                                                        blue:0
                                                       alpha:0.7];
    
    self.adTitleLabel = [[[UILabel alloc] initWithFrame:CGRectMake(20, 0, 1004, 50)] autorelease];
    [self.adTitleGroupView addSubview:self.adTitleLabel];
    self.adTitleLabel.backgroundColor = [UIColor clearColor];
    self.adTitleLabel.textColor = [UIColor whiteColor];
    
    [self.mScrollView addSubview:self.adTitleGroupView];
    
    
    //广告接口
    self.adInterface = [[[ADInterface alloc] init] autorelease];
    self.adInterface.delegate = self;
    [self.adInterface getADList];
    
    
    self.navigationItem.title = @"宝贝画报HD";
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.gif"]];
    
    self.mScrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height+264);
    
    self.detailsScrollView.contentSize = CGSizeMake(0, 0);
    
    _pageNum = 0;
    _hasNext = YES;
    _isLoading = YES;
    
    self.interface = [[[MainPageInterface alloc] init] autorelease];
    self.interface.delegate = self;
    
    [self.interface getAlbumListByPageNum:_pageNum];
    
//    self.adView.delegate = self;
//    
//    [self.adView startAnimating];
//    
//    self.adView.userInteractionEnabled = YES;
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(adImageViewTapAction:)];
//    [self.adView addGestureRecognizer:tap];
//    [tap release];
    
    [self showAutoPlay];
}

-(void)showAutoPlay
{
    [self.cycleScrollView showNextPage];
    [self performSelector:@selector(showAutoPlay) withObject:nil afterDelay:5];
}

-(void)adImageViewTapAction:(UIGestureRecognizer *)gesture
{
    WaterflowViewController *waterflowController = [[[WaterflowViewController alloc]
                                                     initWithNibName:@"WaterflowViewController"
                                                     bundle:nil] autorelease];
    
    [self.navigationController pushViewController:waterflowController animated:YES];
}

-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscape;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    if (toInterfaceOrientation == UIInterfaceOrientationPortrait
        || toInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
        
        return NO;
    }
    
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    self.mScrollView = nil;
    
    self.interface.delegate = nil;
    self.interface = nil;
    
    self.detailsScrollView = nil;
    
//    self.adView = nil;
    
    self.adInterface.delegate = nil;
    self.adInterface = nil;
    
    self.adArray = nil;
    
    self.headerScrollViewArray = nil;
    
    self.cycleScrollView = nil;
    
    self.adTitleGroupView = nil;
    self.adTitleLabel = nil;
    
    [super dealloc];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (scrollView == self.detailsScrollView) {
        
        CGPoint bottomOffset = CGPointMake(0, self.mScrollView.contentSize.height - self.mScrollView.bounds.size.height);
        [self.mScrollView setContentOffset:bottomOffset animated:YES];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == self.detailsScrollView) {
        
        if (scrollView.contentOffset.x+scrollView.frame.size.width >= scrollView.contentSize.width
            && !_isLoading) {
            
            _isLoading = YES;
            self.interface = [[[MainPageInterface alloc] init] autorelease];
            self.interface.delegate = self;
            
            [self.interface getAlbumListByPageNum:_pageNum];
            
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == self.detailsScrollView) {
        
        for(UIView *view in [self.detailsScrollView subviews]){
            
            if (view.tag == 999) {
                
                for (AlbumView *albumView in view.subviews) {

                    CGRect frame = view.frame;
                    frame.origin.x -= self.detailsScrollView.contentOffset.x;
                    
                    CGRect theScreenWidthFrame = CGRectMake(-self.view.frame.size.width
                                                            , 0
                                                            , 2*self.view.frame.size.width
                                                            , self.view.frame.size.height);
                    
                    
                    if (CGRectIntersectsRect(frame, theScreenWidthFrame)) {//相交，显示图片
                        
                        [albumView reloadSubViewsImage];
                    
                    }else{//销毁图片
                    
                        [albumView releaseSubViewsImage];
                    
                    }
                }
            }
        }
    }
}


#pragma mark - MainPageInterfaceDelegate
-(void)getAlbumListDidFinished:(NSArray *)resultArray
{
    if (resultArray.count>0) {
        
        _hasNext = YES;
        _pageNum++;
        
        NSInteger offsetW = 0;
        NSInteger offsetH = 0;
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(self.detailsScrollView.contentSize.width, 0, 1004, 528)];
        
        view.tag = 999;
        
        for (NSInteger idx = 0;idx < resultArray.count ; idx++) {
            
            AlbumModel *model = [resultArray objectAtIndex:idx];
            
            AlbumView *albumView = [[[NSBundle mainBundle] loadNibNamed:@"AlbumView"
                                                                  owner:self
                                                                options:nil] objectAtIndex:0];
            
            albumView.frame = CGRectMake( 10+offsetW
                                         ,offsetH
                                         , albumView.frame.size.width
                                         , albumView.frame.size.height);
            
            albumView.albumModel = model;
            
//            albumView.layer.cornerRadius = 4;            
            
            [view addSubview:albumView];
            
            offsetW = (20 + albumView.frame.size.width) * ((idx+1)%3);
            offsetH = (20 + albumView.frame.size.height) * ((idx+1)/3);
            
            albumView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin
            | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin
            | UIViewAutoresizingFlexibleBottomMargin;
            
            albumView.layer.shadowOffset = CGSizeMake(0.5, 0.5);
            albumView.layer.shadowColor = [UIColor blackColor].CGColor;
            albumView.layer.shadowOpacity = 0.3;
            
            // mArticleListTileView.layer.shouldRasterize = YES;
            
            // shadow
            UIBezierPath *path = [UIBezierPath bezierPath];
            
            CGPoint topLeft      = albumView.bounds.origin;
            CGPoint bottomLeft   = CGPointMake(0.0, CGRectGetHeight(albumView.bounds));
            CGPoint bottomRight  = CGPointMake(CGRectGetWidth(albumView.bounds), CGRectGetHeight(albumView.bounds));
            CGPoint topRight     = CGPointMake(CGRectGetWidth(albumView.bounds), 0.0);
            
            [path moveToPoint:topLeft];
            [path addLineToPoint:bottomLeft];
            [path addLineToPoint:bottomRight];
            [path addLineToPoint:topRight];
            [path addLineToPoint:topLeft];
            [path closePath];
            
            albumView.layer.shadowPath = path.CGPath;
            
        }
        
        [self.detailsScrollView addSubview:view];
        
        
        
        self.detailsScrollView.contentSize = CGSizeMake(view.frame.size.width + self.detailsScrollView.contentSize.width
                                                        , view.frame.size.height);
        
        [view release];
    }
    
    _isLoading = NO;
    
    [self scrollViewDidScroll:self.detailsScrollView];
}

-(void)getAlbumListDidFailed:(NSString *)errorMsg
{
    NSLog(@"=======%@",errorMsg);
    _isLoading = NO;
    
    _hasNext = NO;
}

#pragma mark - JSAnimatedImagesViewDelegate
- (NSUInteger)animatedImagesNumberOfImages:(JSAnimatedImagesView *)animatedImagesView
{
    return 5;
}

- (UIImage *)animatedImagesView:(JSAnimatedImagesView *)animatedImagesView imageAtIndex:(NSUInteger)index
{
    switch (index) {
        case 0:
            return [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ad2" ofType:@"png"]];
        case 1:
            return [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ad3" ofType:@"png"]];
        case 2:
            return [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ad1" ofType:@"png"]];
        case 3:
            return [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ad4" ofType:@"png"]];
        case 4:
            return [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ad5" ofType:@"png"]];
            
        default:
            break;
    }
    
    return [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ad2" ofType:@"png"]];
}

#pragma mark - CycleScrollViewDelegate method
- (void)cycleScrollViewDelegate:(CycleScrollView *)cycleScrollView didScrollView:(int)index
{
    if (index > self.adArray.count)
        return;

    ADModel *ad = [self.adArray objectAtIndex:index-1];
    self.adTitleLabel.text = ad.title;
    
    
    
//    if (self.currPageNum != (index - 1)) {
//        self.currPageNum = (index -1);
//        
//        //    self.slideShowPageControl.currentPage = index-1;
//        [UIView animateWithDuration:0.1
//                              delay:0
//                            options:UIViewAnimationOptionBeginFromCurrentState
//         | UIViewAnimationCurveEaseInOut
//                         animations:^{
//                             self.slideShowTitleLabel.alpha = 0;
//                         } completion:^(BOOL finished) {
//                             
//                             if (finished) {
//                                 [UIView animateWithDuration:0.1
//                                                       delay:0
//                                                     options:UIViewAnimationOptionBeginFromCurrentState
//                                  | UIViewAnimationCurveEaseInOut
//                                                  animations:^{
//                                                      self.slideShowTitleLabel.text
//                                                      = [[self.taobaokeItemArray objectAtIndex:index-1] title];
//                                                      self.slideShowTitleLabel.alpha = 1;
//                                                  } completion:nil];
//                             }
//                             
//                         }];
//    }
    
}

#pragma mark - ADInterfaceDelegate <NSObject>

-(void)getADListDidFinished:(NSArray *)result
{
    self.adArray = result;
    
    for (NSInteger idx = 0; idx < result.count; idx++) {
        
        ADModel *ad = [result objectAtIndex:idx];
        
        EGOImageView *imageView = [[[EGOImageView alloc]
                                   initWithFrame:CGRectMake(0,0
                                                            , 1024
                                                            , 360)] autorelease];
        imageView.tag = idx;
        
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.imageURL = [NSURL URLWithString:ad.picUrl];
        imageView.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                              action:@selector(adTappedAction:)];
        [imageView addGestureRecognizer:tap];
        [tap release];
        
        [self.headerScrollViewArray addObject:imageView];
        
    }
    
    self.cycleScrollView = [[[CycleScrollView alloc]
                             initWithFrame:CGRectMake(0, 0, 1024, 360)
                             cycleDirection:CycleDirectionLandscape
                             views:self.headerScrollViewArray] autorelease];
    self.cycleScrollView.delegate = self;
    
    [self.mScrollView insertSubview:self.cycleScrollView belowSubview:self.adTitleGroupView];
    
    
    
}

-(void)getADListDidFailed:(NSString *)errorMsg
{
    NSLog(@"--------%@",errorMsg);
}

#pragma mark - Gesture
-(void)adTappedAction:(UIGestureRecognizer *)gesture
{
    ADModel *ad = [self.adArray objectAtIndex:gesture.view.tag];
    
    PicDetailViewController *picDetailViewController = nil;
    
    //友盟统计
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                          [NSString stringWithFormat:@"%d",gesture.view.tag + 1],@"ad_seat",
                          ad.title, @"ad_title", nil];
    [MobClick event:@"ad" attributes:dict];
    
    
    switch (ad.adType) {
        case 0://普通广告，直接跳转到图片详细页
            
            picDetailViewController = [[PicDetailViewController alloc] initWithNibName:@"PicDetailViewController"
                                                                                     bundle:nil];
            
            picDetailViewController.navTitle = ad.title;
            picDetailViewController.pid = ad.adIdentifier;
            picDetailViewController.picDescTitle = ad.title;
            
            [self.navigationController pushViewController:picDetailViewController animated:YES];
            [picDetailViewController release];

            
            break;
            
        case 1://网页广告，直接打开网页
            
            [self.navigationController
             pushViewController:[[[SVWebViewController alloc] initWithURL:[NSURL URLWithString:ad.adIdentifier]
                                                               thumbImage:nil
                                                                    title:ad.title]
                                 autorelease]
             animated:YES];
            
            
            break;
            
        default:
            break;
    }
}

@end
