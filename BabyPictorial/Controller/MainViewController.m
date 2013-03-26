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

#import <QuartzCore/QuartzCore.h>

@interface MainViewController (){
    NSInteger _pageNum ;
    Boolean _hasNext;
    Boolean _isLoading;
}

@property (nonatomic,retain) MainPageInterface *interface;

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
    
    self.mScrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height+164);
    
    self.detailsScrollView.contentSize = CGSizeMake(0, 0);
    
    
    _pageNum = 0;
    _hasNext = YES;
    _isLoading = YES;
    
    self.interface = [[[MainPageInterface alloc] init] autorelease];
    self.interface.delegate = self;
    
    [self.interface getAlbumListByPageNum:_pageNum];
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

#pragma mark - MainPageInterfaceDelegate
-(void)getAlbumListDidFinished:(NSArray *)resultArray
{
    _hasNext = YES;
    _pageNum++;
    
    NSInteger offsetW = 0;
    NSInteger offsetH = 0;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(self.detailsScrollView.contentSize.width, 0, 984, 528)];
    
    for (NSInteger idx = 0;idx < resultArray.count ; idx++) {
        
        AlbumModel *model = [resultArray objectAtIndex:idx];
        
        AlbumView *albumView = [[[NSBundle mainBundle] loadNibNamed:@"AlbumView"
                                                              owner:self
                                                            options:nil] objectAtIndex:0];
        
        albumView.frame = CGRectMake( offsetW 
                                     ,offsetH
                                     , albumView.frame.size.width
                                     , albumView.frame.size.height);
        
        [albumView setImageUrls:model.picArray];
        [albumView.titleLabel setText:[model albumName]];
        
        albumView.layer.cornerRadius = 4;
        
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
//        albumView.userInteractionEnabled = YES;
//        [albumView addGestureRecognizer:tap];
//        [tap release];
        
        
        [view addSubview:albumView];
        
        offsetW = (20 + albumView.frame.size.width) * ((idx+1)%3);
        offsetH = (20 + albumView.frame.size.height) * ((idx+1)/3);
        
    }
    
    [self.detailsScrollView addSubview:view];
    
    
    
    self.detailsScrollView.contentSize = CGSizeMake(view.frame.size.width + self.detailsScrollView.contentSize.width
                                                    , view.frame.size.height);
    
    [view release];
    
    _isLoading = NO;
    
}

-(void)getAlbumListDidFailed:(NSString *)errorMsg
{
    NSLog(@"=======%@",errorMsg);
    _isLoading = NO;
    
    _hasNext = NO;
}

//-(void)tapAction:(UITapGestureRecognizer *)gesture
//{
//    PicDetailViewController *col = [[PicDetailViewController alloc] initWithNibName:@"PicDetailViewController"
//                                                                             bundle:nil];
//    
//    [self.navigationController pushViewController:col animated:YES];
//    [col release];
//}

@end
