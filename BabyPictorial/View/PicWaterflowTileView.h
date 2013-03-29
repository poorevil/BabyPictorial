//
//  PicWaterflowTileView.h
//  BabyPictorial
//
//  Created by han chao on 13-3-26.
//  Copyright (c) 2013年 taoxiaoxian. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EGOImageView;
@class PicDetailModel;

@interface PicWaterflowTileView : UIView

@property (nonatomic,retain) IBOutlet EGOImageView *imageView;
@property (nonatomic,retain) IBOutlet UILabel *titleLabel;

@property (nonatomic,retain) PicDetailModel *pdm;


-(void)releaseImage;//释放所有子view的图片

-(void)reloadImage;//重载所有子view的图片

@end
