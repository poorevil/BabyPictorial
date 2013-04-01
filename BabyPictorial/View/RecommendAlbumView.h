//
//  RecommendAlbumView.h
//  BabyPictorial
//
//  Created by han chao on 13-3-28.
//  Copyright (c) 2013年 taoxiaoxian. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AlbumModel;

@interface RecommendAlbumView : UIView

@property (nonatomic,retain) IBOutlet UILabel *albumTitle;

@property (nonatomic,retain) IBOutlet UIView *imageContainer;


@property (nonatomic,retain) AlbumModel *albumModel;

@property (nonatomic,retain) IBOutlet UIView *titlContainerView;

@end
