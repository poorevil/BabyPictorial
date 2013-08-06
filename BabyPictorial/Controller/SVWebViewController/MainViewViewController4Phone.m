//
//  MainViewViewController4Phone.m
//  BabyPictorial
//
//  Created by han chao on 13-6-2.
//  Copyright (c) 2013年 taoxiaoxian. All rights reserved.
//

#import "MainViewViewController4Phone.h"

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

@interface MainViewViewController4Phone (){
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

@property (nonatomic,retain) UIView *lunboViewgroup;//轮播图父view

@property (nonatomic,retain) NSMutableArray *albumArray;//图集数组

@end

#define CYCLE_SCROLLVIEW_HEIGHT_PAD 360
#define CYCLE_SCROLLVIEW_HEIGHT_PHONE 120

#define CYCLE_SCROLLVIEW_HEIGHT CYCLE_SCROLLVIEW_HEIGHT_PHONE

#define AD_TITLE_GROUP_HEIGHT_PAD 50
#define AD_TITLE_GROUP_HEIGHT_PHONE 30

#define AD_TITLE_GROUP_HEIGHT AD_TITLE_GROUP_HEIGHT_PHONE

@implementation MainViewViewController4Phone

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
    self.albumArray = [NSMutableArray array];
    
    /*
     * 轮播图
     */
    self.lunboViewgroup = [[[UIView alloc] initWithFrame:CGRectMake(0, 0
                                                                   , self.view.frame.size.width
                                                                   , CYCLE_SCROLLVIEW_HEIGHT)] autorelease];
    
    /*
     * 轮播图对应标题view
     */
    self.adTitleGroupView = [[[UIView alloc] initWithFrame:CGRectMake(0
                                                                      , CYCLE_SCROLLVIEW_HEIGHT - AD_TITLE_GROUP_HEIGHT
                                                                      , self.view.frame.size.width
                                                                      , AD_TITLE_GROUP_HEIGHT)] autorelease];
    self.adTitleGroupView.backgroundColor = [UIColor colorWithRed:0
                                                            green:0
                                                             blue:0
                                                            alpha:0.7];
    
    self.adTitleLabel = [[[UILabel alloc] initWithFrame:CGRectMake(20, 0
                                                                   , self.view.frame.size.width-20
                                                                   , AD_TITLE_GROUP_HEIGHT)] autorelease];
    [self.adTitleGroupView addSubview:self.adTitleLabel];
    self.adTitleLabel.backgroundColor = [UIColor clearColor];
    self.adTitleLabel.textColor = [UIColor whiteColor];
    
    [self.lunboViewgroup addSubview:self.adTitleGroupView];
    

    
    //广告接口
    self.adInterface = [[[ADInterface alloc] init] autorelease];
    self.adInterface.delegate = self;
    [self.adInterface getADList];
    
    
    self.navigationItem.title = @"宝贝画报HD";
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.gif"]];
    
    self.mTableview.tableHeaderView = self.lunboViewgroup;
    
    _pageNum = 0;
    _hasNext = YES;
    _isLoading = YES;
    
    self.interface = [[[MainPageInterface alloc] init] autorelease];
    self.interface.delegate = self;
    
    [self.interface getAlbumListByPageNum:_pageNum];
    
}

-(void)showAutoPlay
{
    [self.cycleScrollView showNextPage];
    [self performSelector:@selector(showAutoPlay) withObject:nil afterDelay:5];
}

//-(void)adImageViewTapAction:(UIGestureRecognizer *)gesture
//{
//    WaterflowViewController *waterflowController = [[[WaterflowViewController alloc]
//                                                     initWithNibName:@"WaterflowViewController"
//                                                     bundle:nil] autorelease];
//    
//    [self.navigationController pushViewController:waterflowController animated:YES];
//}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    if (IDIOM == IPAD){
        
        if (toInterfaceOrientation == UIInterfaceOrientationPortrait
            || toInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
            
            return NO;
        }
        
        return YES;
        
    }else{
        
        if (toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft
            || toInterfaceOrientation == UIInterfaceOrientationLandscapeRight) {
            
            return NO;
        }
        
        return YES;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    self.albumArray = nil;
    
    self.mTableview = nil;
    
    self.interface.delegate = nil;
    self.interface = nil;
    
    self.adInterface.delegate = nil;
    self.adInterface = nil;
    
    self.adArray = nil;
    
    self.headerScrollViewArray = nil;
    
    self.adTitleGroupView = nil;
    self.adTitleLabel = nil;
    
    [super dealloc];
}








#pragma mark - MainPageInterfaceDelegate
-(void)getAlbumListDidFinished:(NSArray *)resultArray
{
    if (resultArray.count>0) {
        
        _hasNext = YES;
        _pageNum++;
        
        [self.albumArray addObjectsFromArray:resultArray];
        
        [self.mTableview reloadData];
        
//        
//        NSInteger offsetW = 0;
//        NSInteger offsetH = 0;
//        
//        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(self.detailsScrollView.contentSize.width, 0, 1004, 528)];
//        
//        view.tag = 999;
//        
//        for (NSInteger idx = 0;idx < resultArray.count ; idx++) {
//            
//            AlbumModel *model = [resultArray objectAtIndex:idx];
//            
//            AlbumView *albumView = [[[NSBundle mainBundle] loadNibNamed:@"AlbumView"
//                                                                  owner:self
//                                                                options:nil] objectAtIndex:0];
//            
//            albumView.frame = CGRectMake( 10+offsetW
//                                         ,offsetH
//                                         , albumView.frame.size.width
//                                         , albumView.frame.size.height);
//            
//            albumView.albumModel = model;
//            
//            //            albumView.layer.cornerRadius = 4;
//            
//            [view addSubview:albumView];
//            
//            offsetW = (20 + albumView.frame.size.width) * ((idx+1)%3);
//            offsetH = (20 + albumView.frame.size.height) * ((idx+1)/3);
//            
//            albumView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin
//            | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin
//            | UIViewAutoresizingFlexibleBottomMargin;
//            
//            albumView.layer.shadowOffset = CGSizeMake(0.5, 0.5);
//            albumView.layer.shadowColor = [UIColor blackColor].CGColor;
//            albumView.layer.shadowOpacity = 0.3;
//            
//            // mArticleListTileView.layer.shouldRasterize = YES;
//            
//            // shadow
//            UIBezierPath *path = [UIBezierPath bezierPath];
//            
//            CGPoint topLeft      = albumView.bounds.origin;
//            CGPoint bottomLeft   = CGPointMake(0.0, CGRectGetHeight(albumView.bounds));
//            CGPoint bottomRight  = CGPointMake(CGRectGetWidth(albumView.bounds), CGRectGetHeight(albumView.bounds));
//            CGPoint topRight     = CGPointMake(CGRectGetWidth(albumView.bounds), 0.0);
//            
//            [path moveToPoint:topLeft];
//            [path addLineToPoint:bottomLeft];
//            [path addLineToPoint:bottomRight];
//            [path addLineToPoint:topRight];
//            [path addLineToPoint:topLeft];
//            [path closePath];
//            
//            albumView.layer.shadowPath = path.CGPath;
//            
//        }
//        
//        [self.detailsScrollView addSubview:view];
//        
//        
//        
//        self.detailsScrollView.contentSize = CGSizeMake(view.frame.size.width + self.detailsScrollView.contentSize.width
//                                                        , view.frame.size.height);
//        
//        [view release];
    }else{
        _hasNext = NO;
    }
    
    _isLoading = NO;
    
//    [self scrollViewDidScroll:self.detailsScrollView];
}

-(void)getAlbumListDidFailed:(NSString *)errorMsg
{
    NSLog(@"=======%@",errorMsg);
    _isLoading = NO;
    
    _hasNext = NO;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.albumArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (cell == NULL) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:@"cell"] autorelease];
        
        AlbumView *albumView = [[[NSBundle mainBundle] loadNibNamed:@"AlbumView"
                                                              owner:self
                                                            options:nil] objectAtIndex:0];
        
        albumView.tag = 999;
        
        albumView.frame = CGRectMake( 5
                                     ,0
                                     , albumView.frame.size.width
                                     , albumView.frame.size.height);
        
        [cell addSubview:albumView];
    }
    
    //初始化
    AlbumView *albumView = (AlbumView *)[cell viewWithTag:999];
    AlbumModel *model = [self.albumArray objectAtIndex:indexPath.row];
    albumView.albumModel = model;
    
    //获取下一页
    if (indexPath.row == (self.albumArray.count -1) && !_isLoading) {
        
        _isLoading = YES;
        self.interface = [[[MainPageInterface alloc] init] autorelease];
        self.interface.delegate = self;
        
        [self.interface getAlbumListByPageNum:_pageNum];
        
    }
    
    
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 254;
}

#pragma mark - CycleScrollViewDelegate method
- (void)cycleScrollViewDelegate:(CycleScrollView *)cycleScrollView didScrollView:(int)index
{
    if (index > self.adArray.count)
        return;
    
    ADModel *ad = [self.adArray objectAtIndex:index-1];
    self.adTitleLabel.text = ad.title;

    
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
        imageView.clipsToBounds = YES;
        imageView.imageURL = [NSURL URLWithString:ad.picUrl];
        imageView.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                              action:@selector(adTappedAction:)];
        [imageView addGestureRecognizer:tap];
        [tap release];
        
        [self.headerScrollViewArray addObject:imageView];
        
    }
    
    CGRect cycleScrollViewFrame = CGRectMake(0, 0
                                             , self.view.frame.size.width
                                             , CYCLE_SCROLLVIEW_HEIGHT);
    
    self.cycleScrollView = [[[CycleScrollView alloc]
                             initWithFrame:cycleScrollViewFrame
                             cycleDirection:CycleDirectionLandscape
                             views:self.headerScrollViewArray] autorelease];
    self.cycleScrollView.delegate = self;
    self.cycleScrollView.backgroundColor = [UIColor redColor];
    
    [self.lunboViewgroup insertSubview:self.cycleScrollView belowSubview:self.adTitleGroupView];
    
    [self showAutoPlay];
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
