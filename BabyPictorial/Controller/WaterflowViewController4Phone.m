//
//  WaterflowViewController4Phone.m
//  BabyPictorial
//
//  Created by han chao on 13-6-3.
//  Copyright (c) 2013年 taoxiaoxian. All rights reserved.
//

#import "WaterflowViewController4Phone.h"

#import "PicWaterflowInterface.h"
#import "PicDetailModel.h"

#import "PicWaterflowTileView.h"
#import "PicWaterflowTileCell4Phone.h"

#import <QuartzCore/QuartzCore.h>

@interface WaterflowViewController4Phone (){
    NSInteger _pageNum ;
    Boolean _hasNext;
    Boolean _isLoading;
}

@property (nonatomic,retain) PicWaterflowInterface *interface;

@property (nonatomic,retain) NSMutableArray *picArray;

@end

@implementation WaterflowViewController4Phone

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
    
    [[button titleLabel] setFont:[UIFont systemFontOfSize:12.0]];
    [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [button setTitleShadowColor:[UIColor colorWithWhite:1.0 alpha:0.7] forState:UIControlStateNormal];
    [button setTitleShadowColor:[UIColor clearColor] forState:UIControlStateHighlighted];
    [[button titleLabel] setShadowOffset:CGSizeMake(0.0, 1.0)];
    
    CGRect buttonFrame = [button frame];
    buttonFrame.size.width = ([t sizeWithFont:[UIFont systemFontOfSize:12.0]].width + 14.0);
    buttonFrame.size.height = buttonImage.size.height;
    [button setFrame:buttonFrame];
    
    [button setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [button setBackgroundImage:buttonPressedImage forState:UIControlStateHighlighted];
    
    [button setTitle:t forState:UIControlStateNormal];
    
    [button addTarget:tgt action:a forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    //后退按钮，左边填充10px
    if ([@"back_btn_bg.png" isEqualToString:bgImgName]) {
        [button setTitleEdgeInsets:UIEdgeInsetsMake(0.0f, 10.0f, 0.0f, 2.0f)];
    }
    
    
    return [buttonItem autorelease];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.picArray = [NSMutableArray array];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.gif"]];
    
    NSString *parentTitle = nil;
    
    if (self.navigationController.viewControllers.count>1)
        parentTitle = [[[self.navigationController.viewControllers
                         objectAtIndex:self.navigationController.viewControllers.count-2] navigationItem] title];
    
    //返回
    UIBarButtonItem *backBtn = [WaterflowViewController4Phone createSquareBarButtonItemWithTitle:parentTitle==nil?@"宝贝画报HD":parentTitle
                                                                                    target:self
                                                                                    action:@selector(backAction)
                                                                                 bgImgName:@"back_btn_bg.png"
                                                                          pressedBgImgName:@"back_btn_pressed_bg.png"];
    self.navigationItem.leftBarButtonItem = backBtn;
    
    //返回首页
    UIBarButtonItem *homeBtn = [WaterflowViewController4Phone createSquareBarButtonItemWithTitle:@"宝贝画报HD"
                                                                                    target:self
                                                                                    action:@selector(homeAction)
                                                                                 bgImgName:@"home_btn_bg.png"
                                                                          pressedBgImgName:@"home_btn_pressed_bg.png"];
    self.navigationItem.rightBarButtonItem = homeBtn;
    
    self.navigationItem.title = self.albumName;
    
//    self.mscrollView = [[[UIScrollView alloc] initWithFrame:self.view.frame] autorelease];
//    self.mscrollView.contentSize = CGSizeMake(self.view.frame.size.width, 0);
//    self.mscrollView.delegate = self;
//    self.mscrollView.backgroundColor = [UIColor clearColor];
//    
//    [self.view addSubview:self.mscrollView];
    
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
    self.picArray = nil;
    self.mTableView = nil;
    
    self.interface.delegate = nil;
    self.interface = nil;
    
    [super dealloc];
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.picArray.count/2 + self.picArray.count%2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (cell == NULL) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier:@"cell"] autorelease];
        
        
        PicWaterflowTileCell4Phone *view = [[[NSBundle mainBundle] loadNibNamed:@"PicWaterflowTileCell4Phone"
                                                                         owner:self
                                                                       options:nil] objectAtIndex:0];
        
        view.tag = 101;
        view.frame = CGRectMake(7
                                , 0
                                , view.frame.size.width
                                , view.frame.size.height);
        
        [cell addSubview:view];
        
        view = nil;
        
        
        //第二个
        view = [[[NSBundle mainBundle] loadNibNamed:@"PicWaterflowTileCell4Phone"
                                                                          owner:self
                                                                        options:nil] objectAtIndex:0];
        
        view.tag = 102;
        
        view.frame = CGRectMake(cell.frame.size.width / 2 + 1
                                , 0
                                , view.frame.size.width
                                , view.frame.size.height);
        
        [cell addSubview:view];
        
        if ((indexPath.row*2+1)>=self.picArray.count) {
            view.hidden = YES;
        }
        
    }
    
    PicWaterflowTileCell4Phone *view = (PicWaterflowTileCell4Phone *)[cell viewWithTag:101];
    view.pdm = [self.picArray objectAtIndex:indexPath.row*2];
    
    view = nil;
    
    //第二个
    if ((indexPath.row*2+1)<self.picArray.count) {
        view = (PicWaterflowTileCell4Phone *)[cell viewWithTag:102];
        view.pdm = [self.picArray objectAtIndex:(indexPath.row*2+1)];
        
        view.hidden = NO;
    }else{
        view = (PicWaterflowTileCell4Phone *)[cell viewWithTag:102];
        view.pdm = nil;
        
        view.hidden = YES;
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 180;
}

#pragma mark - PicWaterflowInterfaceDelegate

-(void)getPicWaterflowByPageNumDidFinished:(NSArray *)array
{
    if (array.count > 0) {
        _hasNext = YES;
        _pageNum++;
        
        [self.picArray addObjectsFromArray:array];
        
        [self.mTableView reloadData];
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
