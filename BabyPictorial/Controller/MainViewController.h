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

@interface MainViewController : UIViewController <UIScrollViewDelegate
,MainPageInterfaceDelegate,JSAnimatedImagesViewDelegate>

@property (retain,nonatomic) IBOutlet UIScrollView *mScrollView;

@property (retain,nonatomic) IBOutlet UIScrollView *detailsScrollView;

@property (retain,nonatomic) IBOutlet JSAnimatedImagesView *adView;

@end
