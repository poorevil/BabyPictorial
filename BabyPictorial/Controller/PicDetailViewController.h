//
//  PicDetailViewController.h
//  BabyPictorial
//
//  Created by han chao on 13-3-21.
//  Copyright (c) 2013年 taoxiaoxian. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PicDetailInterfaceDelegate;
@class EGOImageView;
@protocol EGOImageViewDelegate;
@class PicDetailModel;

@protocol TaokeItemDetailInterfaceDelegate;

@interface PicDetailViewController : UIViewController <PicDetailInterfaceDelegate
,UIScrollViewDelegate,EGOImageViewDelegate,TaokeItemDetailInterfaceDelegate>

@property (nonatomic,retain) IBOutlet UIView *detailContainer;

@property (nonatomic,retain) IBOutlet UIScrollView *mScrollView;

@property (nonatomic,retain) IBOutlet EGOImageView *imageView;

@property (nonatomic,retain) IBOutlet UIView *picContainer;//图片父view

@property (nonatomic,retain) NSString *pid;


@property (nonatomic,retain) IBOutlet UILabel *descriptionLabel;

@property (nonatomic,retain) IBOutlet UIView *rightContainer;//右侧图片最外层view

@property (nonatomic,retain) NSURL *smallPicUrl;//小图标url地址

@property (nonatomic,retain) NSString *navTitle;
@property (nonatomic,retain) NSString *picDescTitle;

@property (nonatomic,retain) PicDetailModel *pdm;


@end
