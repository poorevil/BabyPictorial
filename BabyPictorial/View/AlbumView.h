//
//  AlbumView.h
//  BabyPictorial
//
//  Created by han chao on 13-3-20.
//  Copyright (c) 2013年 taoxiaoxian. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AlbumModel;

@interface AlbumView : UIView

@property (nonatomic,retain) IBOutlet UILabel *titleLabel;
@property (nonatomic,retain) IBOutlet UIView *imageContener;

@property (nonatomic,retain) IBOutlet UIView *titlContainerView;

@property (nonatomic,retain) AlbumModel *albumModel;

-(void)releaseSubViewsImage;

-(void)reloadSubViewsImage;

-(void)setCurrentPicId:(NSString *)picId;

@end
