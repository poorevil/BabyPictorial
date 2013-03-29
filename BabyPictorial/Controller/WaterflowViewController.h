//
//  WaterflowViewController.h
//  BabyPictorial
//
//  Created by han chao on 13-3-26.
//  Copyright (c) 2013年 taoxiaoxian. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PicWaterflowInterfaceDelegate;

@interface WaterflowViewController : UIViewController <PicWaterflowInterfaceDelegate,UIScrollViewDelegate>

@property (nonatomic,retain) NSString *albumId;

@property (nonatomic,retain) NSString *albumName;

@end
