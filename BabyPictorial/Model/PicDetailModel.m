//
//  PicDetailModel.m
//  BabyPictorial
//
//  Created by han chao on 13-3-20.
//  Copyright (c) 2013年 taoxiaoxian. All rights reserved.
//

#import "PicDetailModel.h"
#import "AlbumModel.h"

@implementation PicDetailModel

-(id)init
{
    if (self = [super init]) {
        
        self.recommendAlbumArray = [NSMutableArray array];
    }
    
    return self;
}

-(void)dealloc
{
    self.pid = nil;
    self.picUrl = nil;
    
    self.albumId = nil;
    self.userId = nil;
    self.descTitle = nil;
    self.taokePrice = nil;

    self.time = nil;
    self.taokeTitle = nil;
    self.albumName = nil;
    self.taokeNumiid = nil;
    
    self.ownerAlbum = nil;
    
    self.recommendAlbumArray = nil;
    
    self.taokeUrl = nil;
    
    [super dealloc];
}
@end
