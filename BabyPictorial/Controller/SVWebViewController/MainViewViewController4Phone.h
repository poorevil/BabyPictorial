//
//  MainViewViewController4Phone.h
//  BabyPictorial
//
//  Created by han chao on 13-6-2.
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

@interface MainViewViewController4Phone : UIViewController <UITableViewDataSource,UITableViewDelegate
,MainPageInterfaceDelegate,JSAnimatedImagesViewDelegate,CycleScrollViewDelegate
,ADInterfaceDelegate>


@property (nonatomic,retain) IBOutlet UITableView *mTableview;

@property (nonatomic,retain) CycleScrollView *cycleScrollView;

@end
