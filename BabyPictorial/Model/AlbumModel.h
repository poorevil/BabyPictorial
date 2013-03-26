//
//  AlbumModel.h
//  BabyPictorial
//
//  Created by han chao on 13-3-20.
//  Copyright (c) 2013年 taoxiaoxian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AlbumModel : NSObject

@property (nonatomic,retain) NSString *albumId;
@property (nonatomic,retain) NSString *albumName;
@property (nonatomic,retain) NSMutableArray *picArray;

@end
