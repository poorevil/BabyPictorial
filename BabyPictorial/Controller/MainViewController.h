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

@interface MainViewController : UIViewController <UIScrollViewDelegate,MainPageInterfaceDelegate>

@property (retain,nonatomic) IBOutlet UIScrollView *mScrollView;

@end
