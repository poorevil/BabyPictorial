//
//  PicDetailModel.h
//  BabyPictorial
//
//  Created by han chao on 13-3-20.
//  Copyright (c) 2013年 taoxiaoxian. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AlbumModel;

@interface PicDetailModel : NSObject

@property (nonatomic,retain) NSString *pid;
@property (nonatomic,retain) NSString *picUrl;

@property (nonatomic,retain) NSString *albumId;
@property (nonatomic,retain) NSString *userId;
@property (nonatomic,retain) NSString *descTitle;
@property (nonatomic,retain) NSString *taokePrice;
@property (nonatomic,assign) NSInteger rootCateId;
@property (nonatomic,assign) NSInteger height;
@property (nonatomic,assign) NSInteger width;
@property (nonatomic,assign) NSInteger cateId;
@property (nonatomic,retain) NSString *time;
@property (nonatomic,retain) NSString *taokeTitle;
@property (nonatomic,retain) NSString *albumName;
@property (nonatomic,retain) NSString *taokeNumiid;

@property (nonatomic,retain) AlbumModel *ownerAlbum;

@property (nonatomic,retain) NSMutableArray *recommendAlbumArray;

@property (nonatomic,retain) NSString *taokeUrl;

@end
