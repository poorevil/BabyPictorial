//
//  WaterflowViewController.m
//  BabyPictorial
//
//  Created by han chao on 13-3-26.
//  Copyright (c) 2013年 taoxiaoxian. All rights reserved.
//

#import "WaterflowViewController.h"

#import "PicWaterflowInterface.h"
#import "PicDetailModel.h"

#import "PicWaterflowTileView.h"

#import <QuartzCore/QuartzCore.h>

@interface WaterflowViewController (){
    
    NSMutableArray *lastTileOrignPointInCol;
    
    NSInteger _pageNum ;
    Boolean _hasNext;
    Boolean _isLoading;
}

@property (nonatomic,retain) PicWaterflowInterface *interface;

@property (nonatomic,retain) UIScrollView *mscrollView;

@end

@implementation WaterflowViewController

- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        //两列左右padding 10 两列之间距离10
        lastTileOrignPointInCol = [[NSMutableArray alloc]
                                   initWithObjects:[NSValue valueWithCGPoint:CGPointMake(25, 20)]
                                   ,[NSValue valueWithCGPoint:CGPointMake(25+(25+220)*1, 20)]
                                   ,[NSValue valueWithCGPoint:CGPointMake(25+(25+220)*2, 20)]
                                   ,[NSValue valueWithCGPoint:CGPointMake(25+(25+220)*3, 20)]
                                   , nil];
        
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
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.gif"]];
    
    NSString *parentTitle = nil;
    
    if (self.navigationController.viewControllers.count>1) 
        parentTitle = [[[self.navigationController.viewControllers
                       objectAtIndex:self.navigationController.viewControllers.count-2] navigationItem] title];
    
    //返回
    UIBarButtonItem *backBtn = [WaterflowViewController createSquareBarButtonItemWithTitle:parentTitle==nil?@"宝贝画报HD":parentTitle
                                                                                    target:self
                                                                                    action:@selector(backAction)
                                                                                 bgImgName:@"back_btn_bg.png"
                                                                          pressedBgImgName:@"back_btn_pressed_bg.png"];
    self.navigationItem.leftBarButtonItem = backBtn;
    
    //返回首页
    UIBarButtonItem *homeBtn = [WaterflowViewController createSquareBarButtonItemWithTitle:@"宝贝画报HD"
                                                                                    target:self
                                                                                    action:@selector(homeAction)
                                                                                 bgImgName:@"home_btn_bg.png"
                                                                          pressedBgImgName:@"home_btn_pressed_bg.png"];
    self.navigationItem.rightBarButtonItem = homeBtn;
    
    self.navigationItem.title = self.albumName;
    
    self.mscrollView = [[[UIScrollView alloc] initWithFrame:self.view.frame] autorelease];
    self.mscrollView.contentSize = CGSizeMake(self.view.frame.size.width, 0);
    self.mscrollView.delegate = self;
    self.mscrollView.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:self.mscrollView];
    
    _pageNum = 0;
    _hasNext = YES;
    _isLoading = YES;
    
    self.interface = [[[PicWaterflowInterface alloc] init] autorelease];
    
    self.interface.delegate = self;
    
    [self.interface getPicWaterflowByPageNum:_pageNum andAlbumId:self.albumId];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    self.interface.delegate = nil;
    self.interface = nil;
    
    self.albumId = nil;
    
    self.albumName = nil;
    
    [super dealloc];
}

#pragma mark - addTileWithArticle
//添加tile
-(void)addTileWithResults:(NSArray *) resultArray {
    
    for (PicDetailModel *pdm in resultArray) {
    
        NSArray *viewArray = [[NSBundle mainBundle] loadNibNamed:@"PicWaterflowTileView" owner:self options:nil];
        PicWaterflowTileView *mPicWaterflowTileView = (PicWaterflowTileView *)[viewArray objectAtIndex:0];
        
        mPicWaterflowTileView.pdm = pdm;
                
        //修改原点位置
        NSInteger index = [self.mscrollView.subviews count];
        CGPoint lastPoint = [((NSValue *)[lastTileOrignPointInCol objectAtIndex:index%lastTileOrignPointInCol.count]) CGPointValue];
        CGRect frame = mPicWaterflowTileView.frame;
        frame.origin.x = lastPoint.x;
        frame.origin.y = lastPoint.y;
        mPicWaterflowTileView.frame = frame;
        
        //阴影效果
        [self addShadow:mPicWaterflowTileView];
        //阴影效果结束
        
        [self.mscrollView addSubview:mPicWaterflowTileView];
        //        //计算下次使用的原点位置
        lastPoint.y += frame.size.height + 20;
        [lastTileOrignPointInCol replaceObjectAtIndex:index%lastTileOrignPointInCol.count
                                           withObject:[NSValue valueWithCGPoint:lastPoint]];
        
        //计算scrollview的contentSize
        CGFloat height = 0;
        for (NSValue *val in lastTileOrignPointInCol) {
            CGPoint point = [val CGPointValue];
            if (height < point.y) {
                height = point.y;
            }
        }
        
        self.mscrollView.contentSize = CGSizeMake(self.view.frame.size.width , height);
        
    }
    
}

//添加阴影效果
-(void)addShadow:(UIView *)view{
    view.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin
    | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin
    | UIViewAutoresizingFlexibleBottomMargin;
    
    view.layer.shadowOffset = CGSizeMake(0.5, 0.5);
    view.layer.shadowColor = [UIColor blackColor].CGColor;
    view.layer.shadowOpacity = 0.3;
    
    // mArticleListTileView.layer.shouldRasterize = YES;
    
    // shadow
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    CGPoint topLeft      = view.bounds.origin;
    CGPoint bottomLeft   = CGPointMake(0.0, CGRectGetHeight(view.bounds));
    CGPoint bottomRight  = CGPointMake(CGRectGetWidth(view.bounds), CGRectGetHeight(view.bounds));
    CGPoint topRight     = CGPointMake(CGRectGetWidth(view.bounds), 0.0);
    
    [path moveToPoint:topLeft];
    [path addLineToPoint:bottomLeft];
    [path addLineToPoint:bottomRight];
    [path addLineToPoint:topRight];
    [path addLineToPoint:topLeft];
    [path closePath];
    
    view.layer.shadowPath = path.CGPath;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y+scrollView.frame.size.height >= scrollView.contentSize.height
        && !_isLoading) {
        
        _isLoading = YES;
        self.interface = [[[PicWaterflowInterface alloc] init] autorelease];
        self.interface.delegate = self;
        
        [self.interface getPicWaterflowByPageNum:_pageNum andAlbumId:self.albumId];
        
    }
    
    
    
}

- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView
{
    for(UIView *view in [self.mscrollView subviews]){
        if ([view isMemberOfClass:[PicWaterflowTileView class]]) {
            PicWaterflowTileView *picWaterflowTileView = (PicWaterflowTileView *)view;
            
            CGRect frame = view.frame;
            frame.origin.y -= self.mscrollView.contentOffset.y;
            
            CGRect theScreenWidthFrame = CGRectMake(0, -self.view.frame.size.height, self.view.frame.size.width, 2*self.view.frame.size.height);
            
            if (CGRectIntersectsRect(frame, theScreenWidthFrame)) {//相交，显示图片
                [picWaterflowTileView reloadImage];
            }else{//销毁图片
                [picWaterflowTileView releaseImage];
            }
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    for(UIView *view in [self.mscrollView subviews]){
        if ([view isMemberOfClass:[PicWaterflowTileView class]]) {
            PicWaterflowTileView *picWaterflowTileView = (PicWaterflowTileView *)view;
            
            CGRect frame = view.frame;
            frame.origin.y -= self.mscrollView.contentOffset.y;
            
            CGRect theScreenWidthFrame = CGRectMake(0, -self.view.frame.size.height, self.view.frame.size.width, 2*self.view.frame.size.height);
            
            if (CGRectIntersectsRect(frame, theScreenWidthFrame)) {//相交，显示图片
                [picWaterflowTileView reloadImage];
            }else{//销毁图片
                [picWaterflowTileView releaseImage];
            }
        }
    }
}

#pragma mark - PicWaterflowInterfaceDelegate

-(void)getPicWaterflowByPageNumDidFinished:(NSArray *)array
{
    if (array.count > 0) {
        _hasNext = YES;
        _pageNum++;
        
        [self addTileWithResults:array];
    }
    
    _isLoading = NO;
}
-(void)getPicWaterflowByPageNumDidFailed:(NSString *)errorMsg
{
    NSLog(@"-----%@",errorMsg);
    _isLoading = NO;
    
    _hasNext = NO;
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

@end
