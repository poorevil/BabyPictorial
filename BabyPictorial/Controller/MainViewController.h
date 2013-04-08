//
//  MainViewController.h
//  BabyPictorial
//
//  Created by han chao on 13-3-19.
//  Copyright (c) 2013年 taoxiaoxian. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MainPageInterface;
@protocol MainPageInterfaceDelegate;

@class JSAnimatedImagesView;
@protocol JSAnimatedImagesViewDelegate;

@class CycleScrollView;
@protocol CycleScrollViewDelegate;

@protocol ADInterfaceDelegate;

@interface MainViewController : UIViewController <UIScrollViewDelegate
,MainPageInterfaceDelegate,JSAnimatedImagesViewDelegate,CycleScrollViewDelegate,ADInterfaceDelegate>

@property (retain,nonatomic) IBOutlet UIScrollView *mScrollView;

@property (retain,nonatomic) IBOutlet UIScrollView *detailsScrollView;

//@property (retain,nonatomic) IBOutlet JSAnimatedImagesView *adView;


@property (nonatomic,retain) CycleScrollView *cycleScrollView;

@end
