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
    
    _pageNum = 0;
    _hasNext = YES;
    _isLoading = YES;
    
    self.mScrollView.contentSize = CGSizeMake(self.view.frame.size.width, 280);
    
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
    
    [super dealloc];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y+scrollView.frame.size.height >= scrollView.contentSize.height
        && !_isLoading) {
        
        _isLoading = YES;
        self.interface = [[[MainPageInterface alloc] init] autorelease];
        self.interface.delegate = self;
        
        [self.interface getAlbumListByPageNum:_pageNum];
        
    }
}

#pragma mark - MainPageInterfaceDelegate
-(void)getAlbumListDidFinished:(NSArray *)resultArray
{
    _hasNext = YES;
    _pageNum++;
    
    NSInteger offset = self.mScrollView.contentSize.height;
    
    for (NSInteger idx = 0;idx < resultArray.count ; idx++) {
        
        AlbumModel *model = [resultArray objectAtIndex:idx];
        
        AlbumView *albumView = [[[NSBundle mainBundle] loadNibNamed:@"AlbumView"
                                                              owner:self
                                                            options:nil] objectAtIndex:0];
        
        albumView.frame = CGRectMake(20+(20+albumView.frame.size.width)*(idx%3)
                                     , offset +(albumView.frame.size.height+20)*(idx/3)
                                     , albumView.frame.size.width
                                     , albumView.frame.size.height);
        [albumView setImageUrls:[model picUrls]];
        [albumView.titleLabel setText:[model albumName]];
        
        albumView.layer.cornerRadius = 4;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        albumView.userInteractionEnabled = YES;
        [albumView addGestureRecognizer:tap];
        [tap release];
        
        
        [self.mScrollView addSubview:albumView];
        
        self.mScrollView.contentSize = CGSizeMake(self.mScrollView.frame.size.width
                                                  , 20+albumView.frame.size.height+albumView.frame.origin.y);
    }
    
    _isLoading = NO;
    
}

-(void)getAlbumListDidFailed:(NSString *)errorMsg
{
    NSLog(@"=======%@",errorMsg);
    _isLoading = NO;
    
    _hasNext = NO;
}

-(void)tapAction:(UITapGestureRecognizer *)gesture
{
    PicDetailViewController *col = [[PicDetailViewController alloc] initWithNibName:@"PicDetailViewController"
                                                                             bundle:nil];
    
    [self.navigationController pushViewController:col animated:YES];
    [col release];
}

@end
