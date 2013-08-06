//
//  PicWaterflowTileCell4Phone.h
//  BabyPictorial
//
//  Created by han chao on 13-6-3.
//  Copyright (c) 2013年 taoxiaoxian. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "EGOImageView.h"

@class PicDetailModel;

@interface PicWaterflowTileCell4Phone : UIView

@property (nonatomic,retain) IBOutlet EGOImageView *imageView;
@property (nonatomic,retain) IBOutlet UILabel *titleLabel;

@property (nonatomic,retain) PicDetailModel *pdm;

@end
