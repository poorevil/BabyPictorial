//
//  WaterflowViewController4Phone.h
//  BabyPictorial
//
//  Created by han chao on 13-6-3.
//  Copyright (c) 2013年 taoxiaoxian. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PicWaterflowInterfaceDelegate;

@interface WaterflowViewController4Phone : UIViewController<UITableViewDelegate,UITableViewDataSource
,PicWaterflowInterfaceDelegate>

@property (nonatomic,retain) IBOutlet UITableView *mTableView;

@property (nonatomic,retain) NSString *albumId;

@property (nonatomic,retain) NSString *albumName;

@end
