//
//  PicDetailViewController.h
//  BabyPictorial
//
//  Created by han chao on 13-3-21.
//  Copyright (c) 2013年 taoxiaoxian. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PicDetailInterfaceDelegate;
@class EGOImageView;

@interface PicDetailViewController : UIViewController <PicDetailInterfaceDelegate>

@property (nonatomic,retain) IBOutlet UIView *detailContainer;
@property (nonatomic,retain) IBOutlet UIView *picContainer;

@property (nonatomic,retain) NSString *pid;

@property (nonatomic,retain) IBOutlet EGOImageView *imageView;
@property (nonatomic,retain) IBOutlet UILabel *descriptionLabel;
@property (nonatomic,retain) IBOutlet UIView *ownerAlbumView;

@end
